using Test
using StaticMPI, StaticTools
using MPICH_jll

@testset "StaticMPI.jl" begin

    let
        status = -1
        try
            isfile("mpihello") && rm("mpihello")
            status = run(`julia --compile=min scripts/mpihello.jl`)
        catch e
            @warn "Could not compile ./scripts/mpihello.jl"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        println("mpihello:")
        status = -1
        try
            status = run(`$(MPICH_jll.PATH[])/mpiexec -np 4 ./mpihello`) # --oversubscribe option is not needed with mpich
        catch e
            @warn "Could not run ./mpihello"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0
    end

    let
        status = -1
        try
            isfile("mpisendrecv") && rm("mpisendrecv")
            status = run(`julia --compile=min scripts/mpisendrecv.jl`)
        catch e
            @warn "Could not compile ./scripts/mpisendrecv.jl"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        println("mpisendrecv:")
        status = -1
        try
            status = run(`$(MPICH_jll.PATH[])/mpiexec -np 4 ./mpisendrecv`) # --oversubscribe option is not needed with mpich
        catch e
            @warn "Could not run ./mpisendrecv"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        A = parsedlm(Float64, c"results.csv", ',')
        @test A ≈ [-0.1075215, -2.110675, -0.6649428]
        free(A)
    end

end
