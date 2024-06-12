using LinearAlgebra
using Plots
gr()

# Belief is its Euclidean distance to the goal, like a heat sensor
function belief(agent_pos,prize_pos)
    distance = sqrt(sum(agent_pos-prize_pos).^2)
    return distance
end

# Desire is to reduce its distance to the goal
function desire(belief)
    return belief > 0.0
end

# Intention is action, movement towards goal
function intention(desire,agent_pos,prize_pos)
    if desire
        r = prize_pos - agent_pos
        direction = r/norm(r)
    
        return direction*0.8
    else
        return [0,0]
    end
end

# Initial conditions
prize_pos = [5.0, 2.0]
agent_pos = [1.0, 1.0]
cnt = 0
trajectory = [agent_pos]
plt = plot(xlim=(0, 10), ylim=(0, 10), aspect_ratio=:equal, legend=false)
scatter!(plt,[prize_pos[1]],[prize_pos[2]],color=:red, markerstrokewidth=0, markerstrokealpha=0)

# Loop
anim = @animate for cnt in 1:100
    cnt += 1
    if cnt % 10 == 0
        scatter!(plt,[prize_pos[1]],[prize_pos[2]],color=:white,markerstrokewidth=0, markerstrokealpha=0)
        global prize_pos = [rand(1:10), rand(1:10)]
        scatter!(plt,[prize_pos[1]],[prize_pos[2]],color=:red,markerstrokewidth=0, markerstrokealpha=0)
    end

    B = belief(agent_pos, prize_pos)
    D = desire(B)
    I = intention(D, agent_pos, prize_pos)
    
    global agent_pos = agent_pos + I
    push!(trajectory,agent_pos)
    
    x = [t[1] for t in trajectory]
    y = [t[2] for t in trajectory]    
    plot!(plt,x,y)
end

gif(anim,"test.gif",fps=10)


