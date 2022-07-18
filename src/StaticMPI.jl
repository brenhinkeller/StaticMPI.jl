module StaticMPI

    using StaticTools

    export MPI_Init, MPI_Finalize
    export MPI_COMM_WORLD, mpi_comm_world
    export MPI_Comm_size, MPI_Comm_rank

    @inline function MPI_Init(argc::Int=0, argv::Ptr{Ptr{UInt8}}=Ptr{Ptr{UInt8}}(C_NULL))
        c,v = Ref(argc), Ref(argv)
        @symbolcall MPI_Init(⅋(c)::Ptr{Int}, ⅋(v)::Ptr{Ptr{Ptr{UInt8}}})::Int32
        return c[], v[]
    end
    @inline MPI_Finalize() = @symbolcall MPI_Finalize()::Int32

    mpi_comm_world() = @externptr ompi_mpi_comm_world::Ptr{UInt8}
    const MPI_COMM_WORLD = mpi_comm_world

    @inline function MPI_Comm_size(comm::Ptr{Ptr{UInt8}})
        comm_size = Ref(0)
        @symbolcall MPI_Comm_size(comm::Ptr{Ptr{UInt8}}, ⅋(comm_size)::Ptr{Int64})::Int32
        return comm_size[]
    end
    @inline function MPI_Comm_rank(comm::Ptr{Ptr{UInt8}})
        comm_rank = Ref(0)
        @symbolcall MPI_Comm_rank(comm::Ptr{Ptr{UInt8}}, ⅋(comm_rank)::Ptr{Int64})::Int32
        return comm_rank[]
    end

end
