# StaticMPI

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://brenhinkeller.github.io/StaticMPI.jl/dev/)
[![Build Status](https://github.com/brenhinkeller/StaticMPI.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/brenhinkeller/StaticMPI.jl/actions/workflows/CI.yml?query=branch%3Amain)

A minimal interface for calling [MPI](https://www.mpi-forum.org/) from
[`StaticCompiler.compile_executable`](https://github.com/tshort/StaticCompiler.jl)'d
statically compiled Julia executables.

For all other purposes, see [MPI.jl](https://github.com/JuliaParallel/MPI.jl) instead.

Note that the functions herein insert LLVM IR that directly calls functions from libmpi.
As such, they will only work when linked against a valid libmpi during compilation.
For example, they will generally not work interactively in the REPL.
If they are called without linking to libmpi, expect segfaults!

Both [OpenMPI](https://www.open-mpi.org/) and [MPICH](https://www.mpich.org/) are
supported, though as they internally implement MPI communicators slightly
differently, you will have to specify which one you are using for your libmpi.

```julia
julia> using StaticTools, StaticCompiler, StaticMPI

julia> function mpihello(argc, argv)
           MPI_Init(argc, argv)

           comm = mpi_comm_world(OpenMPI)
           world_size, world_rank = MPI_Comm_size(comm), MPI_Comm_rank(comm)

           printf((c"Hello from ", world_rank, c" of ", world_size, c" processors!\n"))
           MPI_Finalize()
       end
mpihello (generic function with 1 method)

julia> compile_executable(mpihello, (Int, Ptr{Ptr{UInt8}}), "./";
           cflags=`-lmpi -L/opt/local/lib/openmpi-mp/`
       )

ld: warning: object file (./mpihello.o) was built for newer OSX version (12.0) than being linked (10.13)
"/Users/cbkeller/code/StaticTools.jl/mpihello"

shell> mpiexec -np 4 ./mpihello
Hello from 1 of 4 processors!
Hello from 3 of 4 processors!
Hello from 2 of 4 processors!
Hello from 0 of 4 processors!
```
