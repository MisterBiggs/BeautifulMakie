#by Lazaro Alonso
using CairoMakie
CairoMakie.activate!()
let
    x(t; v₀ = 270,θ = 60) = v₀*t*cos(θ*π/180)
    y(t; v₀ = 270,θ = 60, g = 9.8) = v₀*t*sin(θ*π/180) - g*t^2/2
    t = 0:0.5:50
    xcoord = x.(t)
    ycoord = y.(t)

    xnode = Node(xcoord[1:2])
    ynode = Node(ycoord[1:2])

    xnodePt = Node([xcoord[2]])
    ynodePt = Node([ycoord[2]])
    # first frame, initial plot
    fig, ax = lines(xnode, ynode, color = :black, linewidth = 2,
        figure = (resolution=(700,450),), axis = (xlabel = "x", ylabel = "y",))
    scatter!(xnodePt, ynodePt, color = :red, markersize = 15)
    # the animation is done by updating the nodes values
    record(fig,joinpath(@__DIR__, "output", "animLinePoint.mp4")) do io
        for i in 3:length(t)
            push!(xnode[], xcoord[i])
            push!(ynode[], ycoord[i])
            xnodePt[] = [xcoord[i]]
            ynodePt[] = [ycoord[i]]
            xnode[] = xnode[] # trigger all updates for the new frame
            autolimits!(ax)
            ax.title = "t = $(t[i])"
            ylims!(ax, -1000, 3000)
            recordframe!(io)  # record a new frame
        end
    end
end



using Pkg # HIDE
Pkg.status("CairoMakie") # HIDE
