using StaticCompiler, StaticTools, StaticMPI, MPICH_jll
libpath = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib")

function mpihello(argc, argv)
    MPI_Init(argc, argv)

    comm = MPI_COMM_WORLD
    world_size, world_rank = MPI_Comm_size(comm), MPI_Comm_rank(comm)

    printf((c"Hello from ", world_rank, c" of ", world_size, c" processors!\n"))
    MPI_Finalize()
end

compile_executable(mpihello, (Int, Ptr{Ptr{UInt8}}), "./";
    cflags=`-lmpi -L$libpath -Wl,-rpath,$libpath`
)
