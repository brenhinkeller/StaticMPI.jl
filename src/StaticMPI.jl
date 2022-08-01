module StaticMPI

    using StaticTools
    using MPICH_jll
    using Libdl

    const Buffer{T} = Union{AbstractArray{T}, Ref{T}}
    const libmpiptr = Ref(C_NULL)
    function __init__()
        # Check if any libmpi is already loaded
        handle = Ptr{Nothing}(StaticTools.RTLD_DEFAULT)
        if ccall(:dlsym, Ptr{Cvoid}, (Ptr{Nothing}, Cstring), handle, "MPI_Init") == C_NULL
            if MPICH_jll.is_available()
                # If not, load
                path_to_libmpi = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib", "libmpi")
                libmpiptr[] = Libdl.dlopen(path_to_libmpi, RTLD_GLOBAL)
                (libmpiptr[] == C_NULL) && @warn "Could not load MPICH_JLL libmpi"
            end
        end
    end

    include("mpich.jl")
    export Mpich
    using .Mpich
    # Defined instances of MPI types
    export MPI_COMM_WORLD, MPI_COMM_SELF, MPI_COMM_NULL, MPI_REQUEST_NULL,
    MPI_STATUS_NULL, MPI_MESSAGE_NULL, MPI_FILE_NULL, MPI_DATATYPE_NULL,
    MPI_INFO_NULL, MPI_OP_NULL, MPI_MAX, MPI_MIN, MPI_SUM, MPI_PROD, MPI_LAND,
    MPI_BAND, MPI_LOR, MPI_BOR, MPI_LXOR, MPI_BXOR, MPI_MINLOC, MPI_MAXLOC,
    MPI_REPLACE, MPI_NO_OP
    # Status codes and flags
    export MPI_THREAD_SINGLE, MPI_THREAD_FUNNELED, MPI_THREAD_SERIALIZED,
    MPI_THREAD_MULTIPLE, MPI_IDENT, MPI_CONGRUENT, MPI_SIMILAR, MPI_UNEQUAL,
    MPI_MODE_RDONLY, MPI_MODE_RDWR, MPI_MODE_WRONLY, MPI_MODE_CREATE, MPI_MODE_EXCL,
    MPI_MODE_DELETE_ON_CLOSE, MPI_MODE_UNIQUE_OPEN, MPI_MODE_APPEND,
    MPI_MODE_SEQUENTIAL, MPI_SEEK_SET, MPI_SEEK_CUR, MPI_SEEK_END, MPI_SUCCESS


    """
    ```julia
    MPI_Init(argc::Int, argv::Ptr{Ptr{UInt8}})
    MPI_Init()
    ```
    Initialize the execution environment of the calling MPI task for single-
    threaded execution. The optional arguments `argc` and `argv` are the
    traditional argument count and argument value pointer variables passed to a
    compiled executable by the operating system.

    Returns `MPI_SUCCESS` on success
    """
    @inline MPI_Init() = MPI_Init(0, ⅋(Base.RefValue(Ptr{UInt8}(C_NULL))))
    @inline function MPI_Init(argc::Int, argv::Ptr{Ptr{UInt8}})
        c,v = Base.RefValue(argc), Base.RefValue(argv)
        Mpich.MPI_Init(⅋(c), ⅋(v))
    end
    export MPI_Init

    """
    ```julia
    MPI_Finalize()
    ```
    Conclude the execution of the calling MPI task.
    """
    @inline MPI_Finalize() = Mpich.MPI_Finalize()
    export MPI_Finalize

    """
    ```julia
    MPI_Comm_size(comm)
    ```
    Obtain the number of tasks in the specified MPI communicator `comm`.
    """
    @inline function MPI_Comm_size(comm::Mpich.MPI_Comm) #MPICH
        comm_size = Base.RefValue(0)
        Mpich.MPI_Comm_size(comm, ⅋(comm_size))
        comm_size[]
    end
    export MPI_Comm_size

    """
    ```julia
    MPI_Comm_rank(comm)
    ```
    Obtain the rank of the calling MPI task within the specified MPI
    communicator `comm`
    """
    @inline function MPI_Comm_rank(comm::Mpich.MPI_Comm) #MPICH
        comm_rank = Base.RefValue(0)
        Mpich.MPI_Comm_rank(comm, ⅋(comm_rank))
        comm_rank[]
    end
    export MPI_Comm_rank

    """
    ```julia
    MPI_Recv(buffer::Buffer{T}, source::Int, tag::Int, comm::MPI_Comm, status::Buffer{MPI_Status})
    status = MPI_Recv(buffer::Buffer{T}, source::Int, tag::Int, comm::MPI_Comm)
    ```
    Receive `length(buffer)` elements of type `T` from rank `source` sent with tag
    `tag` over MPI communicator `comm`. Recived data is stored in `buffer`, with
    `MPI_Status` stored in `status`.

    Does not return until the message has been received (blocking receive).

    See also: `MPI_Irecv` for non-blocking equivalent
    """
    @inline function MPI_Recv(buffer, source, tag, comm::Mpich.MPI_Comm)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_Recv(buffer, source, tag, comm, status)
        status[]
    end
    @inline function MPI_Recv(buffer::Buffer{T}, source, tag, comm::Mpich.MPI_Comm, status::Buffer{Mpich.MPI_Status}) where T
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Recv(bufptr, length(buffer), Mpich.mpitype(T), source, tag, comm, ⅋(status))
    end
    export MPI_Recv

    """
    ```julia
    MPI_Irecv(buffer::Buffer{T}, source::Int, tag::Int, comm::MPI_Comm, request::Buffer{MPI_Request})
    request = MPI_Irecv(buffer::Buffer{T}, source::Int, tag::Int, comm::MPI_Comm)
    ```
    Receive `length(buffer)` elements of type `T` from rank `source` sent with tag
    `tag` over MPI communicator `comm`. Recived data is stored in `buffer`, with
    `MPI_Request` stored in `request`.

    Returns immediately, even though `buffer` will not be updated until the message
    has been received (non-blocking receive). The status of the incoming message
    can later be checked using the resulting `MPI_Request` object.

    Returns MPI_SUCCESS on success.

    See also: `MPI_Recv` for blocking equivalent, `MPI_Wait`*
    """
    @inline function MPI_Irecv(buffer, source, tag, comm::Mpich.MPI_Comm)
        request = Base.RefValue(MPI_REQUEST_NULL)
        MPI_Irecv(buffer, source, tag, comm, request)
        request[]
    end
    @inline function MPI_Irecv(buffer::Buffer{T}, source, tag, comm::Mpich.MPI_Comm, request::Buffer{Mpich.MPI_Request}) where T
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Irecv(bufptr, length(buffer), Mpich.mpitype(T), source, tag, comm, ⅋(request))
    end
    export MPI_Irecv

    """
    ```julia
    MPI_Send(buffer::Buffer{T}, dest::Int, tag::Int, comm::MPI_Comm)
    ```
    Send `length(buffer)` elements of type `T` to rank `source` with tag `tag`
    over MPI communicator `comm`.

    Does not return until `buffer` can safely be reused, which may not be until
    the message has been received (blocking send).

    Returns MPI_SUCCESS on success.

    See also: `MPI_Isend` for non-blocking equivalent
    """
    @inline function MPI_Send(buffer::Buffer{T}, dest, tag, comm::Mpich.MPI_Comm) where T
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Send(bufptr, length(buffer), Mpich.mpitype(T), dest, tag, comm)
    end
    export MPI_Send

    """
    ```julia
    MPI_Isend(buffer::Buffer{T}, dest::Int, tag::Int, comm::MPI_Comm, request::Buffer{MPI_Request})
    request = MPI_Isend(buffer::Buffer{T}, dest::Int, tag::Int, comm::MPI_Comm)
    ```
    Send `length(buffer)` elements of type `T` to rank `source` with tag `tag`
    over MPI communicator `comm`, with resulting `MPI_Request` stored in
    `request`.

    Returns immediately, regardless of whether the message has been received
    (non-blocking send). The status of the sent message can later be checked
    using the resulting `MPI_Request` object.

    Returns MPI_SUCCESS on success.

    See also: `MPI_Send` for blocking equivalent, `MPI_Wait`*
    """
    @inline function MPI_Isend(buffer, dest, tag, comm::Mpich.MPI_Comm)
        request = Base.RefValue(MPI_REQUEST_NULL)
        Mpich.MPI_Isend(buffer, dest, tag, comm, request)
        request[]
    end
    @inline function MPI_Isend(buffer::Buffer{T}, dest, tag, comm::Mpich.MPI_Comm, request::Buffer{Mpich.MPI_Request}) where T
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Isend(bufptr, length(buffer), Mpich.mpitype(T), dest, tag, comm, ⅋(request))
    end
    export MPI_Isend

    """
    ```julia
    MPI_Barrier(comm::Mpich.MPI_Comm)
    ```
    Wait (i.e., do not return) until all ranks of the communicator `comm` have
    called `MPI_Barrier`.

    Returns MPI_SUCCESS on success.

    See also: `MPI_Wait`, `MPI_Waitall`, `MPI_Waitany`.
    """
    @inline MPI_Barrier(comm::Mpich.MPI_Comm) = Mpich.MPI_Barrier(comm)
    export MPI_Barrier

    """
    ```julia
    MPI_Wait(request::MPI_Request, status::Buffer{MPI_Status})
    status = MPI_Wait(request::MPI_Request)
    ```
    Wait (i.e., do not return) until the operation corresponding to the
    `MPI_request` object `request` has been completed. The resulting `MPI_Status`
    objects will be stored in the buffer `status`

    Returns MPI_SUCCESS on success.

    See also: `MPI_Isend`, `MPI_Irecv`, C.f. `MPI_Waitany`, `MPI_Waitall`
    """
    @inline MPI_Wait(request, status::Buffer{Mpich.MPI_Status}) = Mpich.MPI_Wait(⅋(request), ⅋(status))
    @inline function MPI_Wait(request::Mpich.MPI_Request)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_Wait(Base.RefValue(request), status)
        status[]
    end
    export MPI_Wait
    @inline MPIO_Wait(request, status::Buffer{Mpich.MPI_Status}) = Mpich.MPIO_Wait(⅋(request), ⅋(status))
    @inline function MPIO_Wait(request::Mpich.MPI_Request)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPIO_Wait(Base.RefValue(request), status)
        status[]
    end
    export MPIO_Wait

    """
    ```julia
    MPI_Waitany(array_of_requests::Buffer{MPI_Request}, status::Buffer{MPI_Status})
    status = MPI_Waitany(array_of_requests::Buffer{MPI_Request})
    ```
    Wait (i.e., do not return) until the at least one of the operations
    corresponding to the `MPI_request` objects in `array_of_requests``
    has been completed. The resulting `MPI_Status` object for the first operation
    to complete will be stored in `status`.

    Returns the index of the request corresponding to the first operation to complete.

    See also: `MPI_Isend`, `MPI_Irecv`, C.f. `MPI_Wait`, `MPI_Waitall`
    """
    @inline function MPI_Waitany(requests)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_Waitany(requests, status)
        status[]
    end
    @inline function MPI_Waitany(requests, status)
        index = Base.RefValue(0)
        Mpich.MPI_Waitany(length(requests), ⅋(requests), ⅋(index), ⅋(status))
        index[]
    end
    export MPI_Waitany
    @inline function MPIO_Waitany(requests)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPIO_Waitany(requests, status)
        status[]
    end
    @inline function MPIO_Waitany(requests, status)
        index = Base.RefValue(0)
        Mpich.MPIO_Waitany(length(requests), ⅋(requests), ⅋(index), ⅋(status))
        index[]
    end
    export MPIO_Waitany


    """
    ```julia
    MPI_Waitall(array_of_requests::Buffer{MPI_Request}, [array_of_statuses::Buffer{MPI_Status}])
    ```
    Wait (i.e., do not return) until the all of the operation scorresponding
    to the `MPI_request` objects in `array_of_requests` have been completed.
    The resulting `MPI_Status` objects will be stored in the corresponding
    positions of `array_of_statuses`.

    Returns MPI_SUCCESS on success.

    See also: `MPI_Isend`, `MPI_Irecv`, C.f. `MPI_Wait`, `MPI_Waitany`
    """
    @inline function MPI_Waitall(requests)
        mfill(MPI_STATUS_NULL, length(requests)) do statuses
            rc = MPI_Waitall(requests, statuses)
        end
    end
    @inline MPI_Waitall(requests, statuses) = Mpich.MPI_Waitall(length(requests), ⅋(requests), ⅋(statuses))
    export MPI_Waitall
    @inline function MPIO_Waitall(requests)
        mfill(MPI_STATUS_NULL, length(requests)) do statuses
            rc = MPIO_Waitall(requests, statuses)
        end
    end
    @inline MPIO_Waitall(requests, statuses) = Mpich.MPIO_Waitall(length(requests), ⅋(requests), ⅋(statuses))
    export MPIO_Waitall


    # File IO
    @inline function MPI_File_open(comm, filename, amode::Int)
        file = Base.RefValue(MPI_FILE_NULL)
        MPI_File_open(comm, filename, amode, MPI_INFO_NULL, file)
        file[]
    end
    @inline function MPI_File_open(comm::Mpich.MPI_Comm, filename::AbstractString, amode::Int, info::Mpich.MPI_Info, file::Buffer{Mpich.MPI_File})
        GC.@preserve filename Mpich.MPI_File_open(comm, ⅋(filename), amode, info, ⅋(file))
    end
    export MPI_File_open

    @inline MPI_File_close(file::Mpich.MPI_File) = MPI_File_close(Base.RefValue(file))
    @inline MPI_File_close(file::Buffer{Mpich.MPI_File}) = Mpich.MPI_File_close(⅋(file))
    export MPI_File_close

    # Blocking read and write at
    @inline function MPI_File_read_at(file, offset, buf)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_File_read_at(file, offset, buf, status)
        status[]
    end
    @inline function MPI_File_read_at(file::Mpich.MPI_File, offset::Int64, buf::Buffer{T}, status::Buffer{Mpich.MPI_Status}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_read_at(file, offset, bufptr, length(buf), Mpich.mpitype(T), ⅋(status))
    end
    export MPI_File_read_at

    @inline function MPI_File_read_at_all(file, offset, buf)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_File_read_at_all(file, offset, buf, status)
        status[]
    end
    @inline function MPI_File_read_at_all(file::Mpich.MPI_File, offset::Int64, buf::Buffer{T}, status::Buffer{Mpich.MPI_Status}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_read_at_all(file, offset, bufptr, length(buf), Mpich.mpitype(T), ⅋(status))
    end
    export MPI_File_read_at_all

    @inline function MPI_File_write_at(file, offset, buf)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_File_write_at(file, offset, buf, status)
        status[]
    end
    @inline function MPI_File_write_at(file::Mpich.MPI_File, offset::Int64, buf::Buffer{T}, status::Buffer{Mpich.MPI_Status}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_write_at(file, offset, bufptr, length(buf), Mpich.mpitype(T), ⅋(status))
    end
    export MPI_File_write_at

    @inline function MPI_File_write_at_all(file, offset, buf)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_File_write_at_all(file, offset, buf, status)
        status[]
    end
    @inline function MPI_File_write_at_all(file::Mpich.MPI_File, offset::Int64, buf::Buffer{T}, status::Buffer{Mpich.MPI_Status}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_write_at_all(file, offset, bufptr, length(buf), Mpich.mpitype(T), ⅋(status))
    end
    export MPI_File_write_at_all

    # Nonblocking read and write at
    @inline function MPI_File_iread_at(file, offset, buf)
        request = Base.RefValue(MPI_REQUEST_NULL)
        MPI_File_iread_at(file, offset, buf, request)
        request[]
    end
    @inline function MPI_File_iread_at(file::Mpich.MPI_File, offset::Int64, buf::Buffer{T}, request::Buffer{Mpich.MPI_Request}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_iread_at(file, offset, bufptr, length(buf), Mpich.mpitype(T), ⅋(request))
    end
    export MPI_File_iread_at

    @inline function MPI_File_iwrite_at(file, offset, buf)
        request = Base.RefValue(MPI_REQUEST_NULL)
        MPI_File_iwrite_at(file, offset, buf, request)
        request[]
    end
    @inline function MPI_File_iwrite_at(file::Mpich.MPI_File, offset::Int64, buf::Buffer{T}, request::Buffer{Mpich.MPI_Request}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_iwrite_at(file, offset, bufptr, length(buf), Mpich.mpitype(T), ⅋(request))
    end
    export MPI_File_iwrite_at


    @inline function MPI_File_read(file, buf)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_File_read(file, buf, status)
        status[]
    end
    @inline function MPI_File_read(file::Mpich.MPI_File, buf::Buffer{T}, status::Buffer{Mpich.MPI_Status}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_read(file, bufptr, length(buf), Mpich.mpitype(T), ⅋(status))
    end
    export MPI_File_read

    @inline function MPI_File_read_all(file, buf)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_File_read_all(file, buf, status)
        status[]
    end
    @inline function MPI_File_read_all(file::Mpich.MPI_File, buf::Buffer{T}, status::Buffer{Mpich.MPI_Status}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_read_all(file, bufptr, length(buf), Mpich.mpitype(T), ⅋(status))
    end
    export MPI_File_read_all

    @inline function MPI_File_write(file, buf)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_File_read_all(file, buf, status)
        status[]
    end
    @inline function MPI_File_write(file::Mpich.MPI_File, buf::Buffer{T}, status::Buffer{Mpich.MPI_Status}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_write(file, bufptr, length(buf), Mpich.mpitype(T), ⅋(status))
    end
    export MPI_File_write

    @inline function MPI_File_write_all(file, buf)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_File_write_all(file, buf, status)
        status[]
    end
    @inline function MPI_File_write_all(file::Mpich.MPI_File, buf::Buffer{T}, status::Buffer{Mpich.MPI_Status}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_write_all(file, bufptr, length(buf), Mpich.mpitype(T), ⅋(status))
    end
    export MPI_File_write_all


    @inline function MPI_File_iread(file, buf)
        request = Base.RefValue(MPI_REQUEST_NULL)
        MPI_File_iread(file, buf, request)
        request[]
    end
    @inline function MPI_File_iread(file::Mpich.MPI_File, buf::Buffer{T}, request::Buffer{Mpich.MPI_Request}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_iread(file, bufptr, length(buf), Mpich.mpitype(T), ⅋(request))
    end
    export MPI_File_iwrite_at

    @inline function MPI_File_iwrite(file, buf)
        request = Base.RefValue(MPI_REQUEST_NULL)
        MPI_File_iwrite(file, buf, request)
        request[]
    end
    @inline function MPI_File_iwrite(file::Mpich.MPI_File, buf::Buffer{T}, request::Buffer{Mpich.MPI_Request}) where T
        bufptr = Ptr{Nothing}(⅋(buf))
        Mpich.MPI_File_iwrite(file, bufptr, length(buf), Mpich.mpitype(T), ⅋(request))
    end
    export MPI_File_iwrite_at


end # module
