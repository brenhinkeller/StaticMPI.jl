using StaticMPI
using Test

using StaticTools, StaticCompiler
using OpenMPI_jll
@testset "StaticMPI.jl" begin
    if OpenMPI_jll.is_available()
        function mpihello(argc, argv)
            MPI_Init(argc, argv)

            comm = mpi_comm_world()
            world_size, world_rank = MPI_Comm_size(comm), MPI_Comm_rank(comm)

            printf((c"Hello from ", world_rank, c" of ", world_size, c" processors!\n"))
            MPI_Finalize()
        end

        compile_executable(mpihello, (Int, Ptr{Ptr{UInt8}}), "./";
            cflags=`-lmpi -L$(OpenMPI_jll.LIBPATH[])`
        )

        run(`$(OpenMPI_jll.PATH[])/mpiexec --oversubscribe -mp 4 ./mpihello`)
    end
end
