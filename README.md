# StaticMPI

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://brenhinkeller.github.io/StaticMPI.jl/dev/)
[![CI](https://github.com/brenhinkeller/StaticMPI.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/brenhinkeller/StaticMPI.jl/actions/workflows/CI.yml)
[![CI (Julia nightly)](https://github.com/brenhinkeller/StaticMPI.jl/workflows/CI%20(Julia%20nightly)/badge.svg)](https://github.com/brenhinkeller/StaticMPI.jl/actions/workflows/CI-julia-nightly.yml)


An MPICH-compatible interface for calling [MPI](https://www.mpi-forum.org/) from
[StaticCompiler.jl](https://github.com/tshort/StaticCompiler.jl) `compile_executable`'d
standalone Julia executables, building upon the [StaticTools.jl](https://github.com/brenhinkeller/StaticTools.jl) approach.

For all purposes other than compiling standalone exacutables, see
[MPI.jl](https://github.com/JuliaParallel/MPI.jl) instead.

Currently, only [MPICH](https://www.mpich.org)-style implementations of libmpi
are supported. A relatively complete low-level interface is provided in the
[Mpich](src/mpich.jl) submodule, while the more Julian top-level implementation
is still relatively incomplete and under active development.

Note that the functions herein insert LLVM IR that directly calls functions from libmpi.
As such, they will only work when linked against a valid libmpi during compilation.
If you want to use them interactively in the REPL (e.g., for debugging), you will
have to first `dlopen` your libmpi with mode `RTLD_GLOBAL` to make the symbols
from libmpi available within your Julia session:
```julia
julia> using Libdl, MPICH_jll, StaticMPI

julia> path_to_libmpi = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib", "libmpi")
"/Users/me/.julia/artifacts/10a7002eea557072e8e2ec81f16de1421d5bf667/lib/libmpi"

julia> dlopen(path_to_libmpi, RTLD_GLOBAL)
Ptr{Nothing} @0x00007fa51443bbe0

julia> MPI_Init() == MPI_SUCCESS
true
```
If any MPI functions herein are ever called *without* linking to libmpi one way or another, expect segfaults!

## Examples
#### Hello World:
```julia
julia> using StaticCompiler, StaticTools, StaticMPI

julia> function mpihello(argc, argv)
           MPI_Init(argc, argv)

           comm = MPI_COMM_WORLD
           world_size, world_rank = MPI_Comm_size(comm), MPI_Comm_rank(comm)

           printf((c"Hello from ", world_rank, c" of ", world_size, c" processors!\n"))
           MPI_Finalize()
       end
mpihello (generic function with 1 method)

julia> compile_executable(mpihello, (Int, Ptr{Ptr{UInt8}}), "./";
           cflags=`-lmpi -L/opt/local/lib/mpich-mp/`
           # -lmpi instructs compiler to link against libmpi.so / libmpi.dylib
           # -L/opt/local/lib/mpich-mp/ provides path to my local MPICH installation where libmpi can be found
       )

ld: warning: object file (./mpihello.o) was built for newer OSX version (12.0) than being linked (10.13)
"/Users/me/code/StaticTools.jl/mpihello"

shell> mpiexec -np 4 ./mpihello
Hello from 1 of 4 processors!
Hello from 3 of 4 processors!
Hello from 2 of 4 processors!
Hello from 0 of 4 processors!
```
#### Send and recieve:
```julia
using StaticCompiler, StaticTools, StaticMPI, MPICH_jll
libpath = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib")

# Function to compile
function mpisendrecv(argc, argv)
    MPI_Init(argc, argv) == MPI_SUCCESS || error(c"MPI failed to initialize\n")

    comm = MPI_COMM_WORLD
    world_size, world_rank = MPI_Comm_size(comm), MPI_Comm_rank(comm)
    nworkers = world_size - 1

    if world_rank == 0
        # Gather results on root note
        buffer = mfill(0, nworkers)
        requests = mfill(MPI_REQUEST_NULL, nworkers)
        for i ∈ 1:nworkers
            MPI_Irecv(buffer[i:i], i, 10, MPI_COMM_WORLD, requests[i:i])
            # Note that this [i:i] syntax only works because contiguous indexing
            # of `StaticTools.MallocArray`s returns a view
        end
        MPI_Waitall(requests)
        printf((c"Rank 0 recieved:\n", buffer, c"\n"))
        printdlm(c"results.csv", buffer)
        free(requests), free(buffer)
    else
        # Send results back to root node
        # Best to use malloc'd things when Sending (or esp. Isend-ing),
        # to ensure they won't get unwound before send happens
        x = mfill(world_rank)
        printf((c"Rank ", world_rank, c", sending ", x[], c"\n"))
        MPI_Send(x, 0, 10, comm)
        free(x)
    end
    MPI_Finalize()
end

# Compile it to binary executable
compile_executable(mpisendrecv, (Int, Ptr{Ptr{UInt8}}), "./";
    cflags=`-lmpi -L$libpath -Wl,-rpath,$libpath`
    # -lmpi instructs compiler to link against libmpi.so / libmpi.dylib
    # -L$libpath tells the compiler about the path to libmpi
    # -Wl,-rpath,$libpath tells the linker about the path to libmpi (not needed on all systems)
)
```
Since this example linked to the `libmpi` from [MPICH_jll](https://github.com/JuliaBinaryWrappers/MPICH_jll.jl), let's also use the `mpiexec` `from MPICH_jll`.
```julia
shell> $(MPICH_jll.PATH[])/mpiexec -np 6 ./mpisendrecv
Rank 1, sending 1
Rank 2, sending 2
Rank 3, sending 3
Rank 4, sending 4
Rank 5, sending 5
Rank 0 recieved:
1
2
3
4
5
```
Since we're compiling to standalone executables, we've used the special non-GC-allocating
arrays, strings, and IO from [StaticTools.jl](https://github.com/brenhinkeller/StaticTools.jl)
throughout the above examples.
