using Test
using StaticMPI, StaticTools
using MPICH_jll

@testset "StaticMPI.jl" begin
    @test MPICH_jll.is_available()

@static if MPICH_jll.is_available()
    jlpath = joinpath(Sys.BINDIR, Base.julia_exename()) # Get path to julia executable
    @test MPI_Init() == MPI_SUCCESS # Check that we have loaded libmpi

    @static if Sys.isbsd() # VERSION > v"1.9.0-0" #
    let status = -1
        try
            isfile("mpifile") && rm("mpifile")
            status = run(`$jlpath --compile=min scripts/mpifile.jl`)
        catch e
            @warn "Could not compile ./scripts/mpifile.jl"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        println("mpifile:")
        status = -1
        try
            isfile("results0.b") && rm("results0.b")
            isfile("results1.b") && rm("results1.b")
            status = run(`$(MPICH_jll.PATH[])/mpiexec -np 4 ./mpifile`) # --oversubscribe option is not needed with mpich
        catch e
            @warn "Error running ./mpifile"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        A = read("results0.b", String)
        @test A == "0000111122223333"
        A = read("results1.b", String)
        @test A == "0000111122223333"
    end
    end

    let status = -1
        try
            isfile("mpihello") && rm("mpihello")
            status = run(`$jlpath --compile=min scripts/mpihello.jl`)
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
            @warn "Error running ./mpihello"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0
    end

    let status = -1
        try
            isfile("mpimatmul") && rm("mpimatmul")
            status = run(`$jlpath --compile=min scripts/mpimatmul.jl`)
        catch e
            @warn "Could not compile ./scripts/mpimatmul.jl"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        println("mpimatmul:")
        status = -1
        try
            isfile("results.csv") && rm("results.csv")
            status = run(`$(MPICH_jll.PATH[])/mpiexec -np 4 ./mpimatmul 5 10`) # --oversubscribe option is not needed with mpich
        catch e
            @warn "Error running ./mpimatmul"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        A = parsedlm(Float64, c"results.csv", ',')
        @test A ≈ 10ones(5,5)
        free(A)
    end

    let status = -1
        try
            isfile("mpisendrecv") && rm("mpisendrecv")
            status = run(`$jlpath --compile=min scripts/mpisendrecv.jl`)
        catch e
            @warn "Could not compile ./scripts/mpisendrecv.jl"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        println("mpisendrecv:")
        status = -1
        try
            status = run(`$(MPICH_jll.PATH[])/mpiexec -np 8 ./mpisendrecv`) # --oversubscribe option is not needed with mpich
        catch e
            @warn "Error running ./mpisendrecv"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        A = parsedlm(Float64, c"results.csv", ',')
        @test vec(A) == 1:7
        free(A)
    end


    let status = -1
        try
            isfile("mpisendrecvrand") && rm("mpisendrecvrand")
            status = run(`$jlpath --compile=min scripts/mpisendrecvrand.jl`)
        catch e
            @warn "Could not compile ./scripts/mpisendrecvrand.jl"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        println("mpisendrecvrand:")
        status = -1
        try
            isfile("results.csv") && rm("results.csv")
            status = run(`$(MPICH_jll.PATH[])/mpiexec -np 4 ./mpisendrecvrand`) # --oversubscribe option is not needed with mpich
        catch e
            @warn "Error running ./mpisendrecvrand"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        A = parsedlm(Float64, c"results.csv", ',')
        @test A ≈ [-0.1075215, -2.110675, -0.6649428]
        free(A)
    end

    let status = -1
        try
            isfile("scattergatherbcast") && rm("scattergatherbcast")
            status = run(`$jlpath --compile=min scripts/scattergatherbcast.jl`)
        catch e
            @warn "Could not compile ./scripts/scattergatherbcast.jl"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        println("scattergatherbcast:")
        status = -1
        try
            isfile("results.csv") && rm("results.csv")
            status = run(`$(MPICH_jll.PATH[])/mpiexec -np 4 ./scattergatherbcast`) # --oversubscribe option is not needed with mpich
        catch e
            @warn "Error running ./scattergatherbcast"
            println(e)
        end
        @test isa(status, Base.Process)
        @test isa(status, Base.Process) && status.exitcode == 0

        for i=0:3
            name = c"results.1.0.b"
            name[11] += i % UInt8
            A = read(name, MallocArray{Float64})
            @test A == fill(10., 5)
            free(A)
        end

        A = read(c"results.3.0.b", MallocArray{Float64})
        @test A == fill(11., 20)
        free(A)
    end


end
end
