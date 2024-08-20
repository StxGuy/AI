# Inspired by Tobin Fricke's code in MatLab: https://www.asc.ohio-state.edu/braaten.1/statphys/Ising_MatLab.pdf

using PyPlot
using Statistics

# Optimized Ising model solver using Monte Carlo
function Ising(N::Int, β::Float64, B::Float64,T::Int)
    grid = rand((-1, 1), N, N)
    Energy = Float64[]
    Magnetization = Float64[]
    J = 1.0
    
    @inbounds @fastmath for step in 1:(500+T)
        Nei = circshift(grid,(0,1))+
              circshift(grid,(0,-1))+
              circshift(grid,(1,0))+
              circshift(grid,(-1,0))
          
        Δε = 2J*grid.*Nei        
        p = exp.(-β*Δε)
        # Choose 10% of the eligible transitions
        transitions = -2*(rand(N,N) .< p).*(rand(N,N) .< 0.1) .+ 1
        grid .*= transitions

        # Wait for thermalization
        if step > 500
            push!(Magnetization, sum(grid))
            push!(Energy, -sum(Δε)/2)
        end
    end

    # Explore ergodicity
    return mean(Energy)/N^2, mean(Magnetization)/N^2
end


# Plot
function plot_results()
    DataPoints = 200
    Averaging = 2000
    GridSize = 20
    
    Tsp = LinRange(1E-10,5.0,DataPoints)
    Msp = Vector{Float64}(undef, DataPoints)
    @inbounds @fastmath for (i, T) in enumerate(Tsp)
        println(i/DataPoints)
        β = 1.0 / T
        ε,M = Ising(GridSize, β, 0.0, Averaging)
        Msp[i] = M
    end

    scatter(Tsp,Msp)
    show()
end

plot_results()
