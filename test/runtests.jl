using StaticMPI
using Test
using OpenMPI_jll, MPICH_jll

@testset "StaticMPI.jl" begin

    if OpenMPI_jll.is_available()
        status = -1
        try
            isfile("mpihello_openmpi") && rm("mpihello_openmpi")
            status = run(`julia --compile=min ./scripts/mpihello_openmpi.jl`)
        catch e
            @warn "Could not compile ./scripts/mpihello_openmpi.jl"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        println("mpihello_openmpi:")
        status = -1
        try
            status = run(`$(OpenMPI_jll.PATH[])/mpiexec --oversubscribe -np 4 ./mpihello_openmpi`)
        catch e
            @warn "Could not run ./mpihello_openmpi"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0
    end

    if MPICH_jll.is_available()
        status = -1
        try
            isfile("mpihello_mpich") && rm("mpihello_mpich")
            status = run(`julia --compile=min scripts/mpihello_mpich.jl`)
        catch e
            @warn "Could not compile ./scripts/mpihello_mpich.jl"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        println("mpihello_mpich:")
        status = -1
        try
            status = run(`$(MPICH_jll.PATH[])/mpiexec -np 4 ./mpihello_mpich`) # --oversubscribe option is not needed with mpich
        catch e
            @warn "Could not run ./mpihello_mpich"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0
    end

end
