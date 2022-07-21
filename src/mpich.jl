#=
   MPICH frontend
=#
module mpich
using StaticTools

# MPI_Status struct:
mutable struct MPI_Status
    count_lo::Int32
    count_hi_and_cancelled::Int32
    MPI_SOURCE::Int32
    MPI_TAG::Int32
    MPI_ERROR::Int32
end
@inline Base.pointer(x::MPI_Status) = Ptr{MPI_Status}(pointer_from_objref(x))

# Communicators:
struct MPI_Comm
   x::UInt32
end
const MPI_COMM_NULL  = MPI_Comm(0x04000000)
const MPI_COMM_WORLD = MPI_Comm(0x44000000)
const MPI_COMM_SELF  = MPI_Comm(0x44000001)

# Groups:
struct MPI_Group
   x::UInt32
end
const MPI_GROUP_NULL  = MPI_Group(0x08000000)
const MPI_GROUP_EMPTY = MPI_Group(0x48000000)

# RMA and Windows:
struct MPI_Win
   x::UInt32
end
const MPI_WIN_NULL = MPI_Win(0x20000000)

# File and IO:
struct MPI_File
   x::Ptr{UInt8}
end
const MPI_FILE_NULL = MPI_File(0)

# MPI request objects:
struct MPI_Request
   x::UInt32
end
const MPI_REQUEST_NULL   = MPI_Request(0x2c000000)

# MPI message objects for Mprobe and related functions:
struct MPI_Message
   x::UInt32
end
const MPI_MESSAGE_NULL    = MPI_Message(0x2c000000)
const MPI_MESSAGE_NO_PROC = MPI_Message(0x6c000000)

# Data types:
struct MPI_Datatype
   x::UInt32
end
const MPI_DATATYPE_NULL  = MPI_Datatype(0x0c000000)
const MPI_CHAR           = MPI_Datatype(0x4c000101)
const MPI_SIGNED_CHAR    = MPI_Datatype(0x4c000118)
const MPI_UNSIGNED_CHAR  = MPI_Datatype(0x4c000102)
const MPI_BYTE           = MPI_Datatype(0x4c00010d)
const MPI_WCHAR          = MPI_Datatype(0x4c00040e)
const MPI_SHORT          = MPI_Datatype(0x4c000203)
const MPI_UNSIGNED_SHORT = MPI_Datatype(0x4c000204)
const MPI_Int32            = MPI_Datatype(0x4c000405)
const MPI_UNSIGNED       = MPI_Datatype(0x4c000406)
const MPI_LONG           = MPI_Datatype(0x4c000807)
const MPI_UNSIGNED_LONG  = MPI_Datatype(0x4c000808)
const MPI_FLOAT          = MPI_Datatype(0x4c00040a)
const MPI_DOUBLE         = MPI_Datatype(0x4c00080b)
const MPI_LONG_DOUBLE    = MPI_Datatype(0x4c00100c)
const MPI_LONG_LONG_Int32  = MPI_Datatype(0x4c000809)
const MPI_UNSIGNED_LONG_LONG = MPI_Datatype(0x4c000819)
const MPI_LONG_LONG      = MPI_LONG_LONG_Int32
const MPI_PACKED         = MPI_Datatype(0x4c00010f)
const MPI_LB             = MPI_Datatype(0x4c000010)
const MPI_UB             = MPI_Datatype(0x4c000011)
const MPI_FLOAT_Int32         = MPI_Datatype(0x8c000000)
const MPI_DOUBLE_Int32        = MPI_Datatype(0x8c000001)
const MPI_LONG_Int32          = MPI_Datatype(0x8c000002)
const MPI_SHORT_Int32         = MPI_Datatype(0x8c000003)
const MPI_2Int32              = MPI_Datatype(0x4c000816)
const MPI_LONG_DOUBLE_Int32   = MPI_Datatype(0x8c000004)
# Size-specific types (see MPI-2, 10.2.5):
const MPI_REAL4             = MPI_Datatype(0x4c000427)
const MPI_REAL8             = MPI_Datatype(0x4c000829)
const MPI_REAL16            = MPI_Datatype(0x4c00102b)
const MPI_COMPLEX8          = MPI_Datatype(0x4c000828)
const MPI_COMPLEX16         = MPI_Datatype(0x4c00102a)
const MPI_COMPLEX32         = MPI_Datatype(0x4c00202c)
const MPI_INTEGER1          = MPI_Datatype(0x4c00012d)
const MPI_INTEGER2          = MPI_Datatype(0x4c00022f)
const MPI_INTEGER4          = MPI_Datatype(0x4c000430)
const MPI_INTEGER8          = MPI_Datatype(0x4c000831)
const MPI_INTEGER16         = MPI_Datatype(MPI_DATATYPE_NULL.x)
# C99 fixed-width datatypes:
const MPI_INT8_T            = MPI_Datatype(0x4c000137)
const MPI_INT16_T           = MPI_Datatype(0x4c000238)
const MPI_INT32_T           = MPI_Datatype(0x4c000439)
const MPI_INT64_T           = MPI_Datatype(0x4c00083a)
const MPI_UINT8_T           = MPI_Datatype(0x4c00013b)
const MPI_UINT16_T          = MPI_Datatype(0x4c00023c)
const MPI_UINT32_T          = MPI_Datatype(0x4c00043d)
const MPI_UINT64_T          = MPI_Datatype(0x4c00083e)
# other C99 types:
const MPI_C_BOOL                 = MPI_Datatype(0x4c00013f)
const MPI_C_FLOAT_COMPLEX        = MPI_Datatype(0x4c000840)
const MPI_C_COMPLEX              = MPI_C_FLOAT_COMPLEX
const MPI_C_DOUBLE_COMPLEX       = MPI_Datatype(0x4c001041)
const MPI_C_LONG_DOUBLE_COMPLEX  = MPI_Datatype(0x4c002042)
const MPIX_C_FLOAT16             = MPI_Datatype(0x4c000246)
# address/offset types:
const MPI_AINT          = MPI_Datatype(0x4c000843)
const MPI_OFFSET        = MPI_Datatype(0x4c000844)
const MPI_COUNT         = MPI_Datatype(0x4c000845)

# Collective operations:
struct MPI_Op
   x::UInt32
end
const MPI_OP_NULL = MPI_Op(0x18000000)
const MPI_MAX     = MPI_Op(0x58000001)
const MPI_MIN     = MPI_Op(0x58000002)
const MPI_SUM     = MPI_Op(0x58000003)
const MPI_PROD    = MPI_Op(0x58000004)
const MPI_LAND    = MPI_Op(0x58000005)
const MPI_BAND    = MPI_Op(0x58000006)
const MPI_LOR     = MPI_Op(0x58000007)
const MPI_BOR     = MPI_Op(0x58000008)
const MPI_LXOR    = MPI_Op(0x58000009)
const MPI_BXOR    = MPI_Op(0x5800000a)
const MPI_MINLOC  = MPI_Op(0x5800000b)
const MPI_MAXLOC  = MPI_Op(0x5800000c)
const MPI_REPLACE = MPI_Op(0x5800000d)
const MPI_NO_OP   = MPI_Op(0x5800000e)

# Built-in error handler objects:
struct MPI_Errhandler
   x::UInt32
end
const MPI_ERRHANDLER_NULL = MPI_Errhandler(0x14000000)
const MPI_ERRORS_ARE_FATAL = MPI_Errhandler(0x54000000)
const MPI_ERRORS_RETURN    = MPI_Errhandler(0x54000001)
const MPIR_ERRORS_THROW_EXCEPTIONS = MPI_Errhandler(0x54000002)

# Info
struct MPI_Info
   x::UInt32
end
const MPI_INFO_NULL        = MPI_Info(0x1c000000)
const MPI_INFO_ENV         = MPI_Info(0x5c000001)
const MPI_MAX_INFO_KEY     =  255
const MPI_MAX_INFO_VAL     = 1024

# Other types
struct MPI_Aint
   x::UInt32
end
struct MPI_Fint
   x::UInt32
end
struct MPI_Count
   x::Int64
end


# Various constants:
const MPI_TAG_UB           = 0x64400001
const MPI_HOST             = 0x64400003
const MPI_IO               = 0x64400005
const MPI_WTIME_IS_GLOBAL  = 0x64400007
const MPI_UNIVERSE_SIZE    = 0x64400009
const MPI_LASTUSEDCODE     = 0x6440000b
const MPI_APPNUM           = 0x6440000d
const MPI_UNDEFINED        = (-32766)
const MPI_KEYVAL_INVALID   = 0x24000000
# Window attributes:
const MPI_WIN_BASE          = 0x66000001
const MPI_WIN_SIZE          = 0x66000003
const MPI_WIN_DISP_UNIT     = 0x66000005
const MPI_WIN_CREATE_FLAVOR = 0x66000007
const MPI_WIN_MODEL         = 0x66000009

# Thread levels:
const MPI_THREAD_SINGLE     = 0
const MPI_THREAD_FUNNELED   = 1
const MPI_THREAD_SERIALIZED = 2
const MPI_THREAD_MULTIPLE   = 3

# Results of the compare operations:
const MPI_IDENT     = 0
const MPI_CONGRUENT = 1
const MPI_SIMILAR   = 2
const MPI_UNEQUAL   = 3

# Success and error codes:
const MPI_SUCCESS         =  0      #= Successful return code =#
const MPI_ERR_BUFFER      =  1      #= Invalid buffer pointer =#
const MPI_ERR_COUNT       =  2      #= Invalid count argument =#
const MPI_ERR_TYPE        =  3      #= Invalid datatype argument =#
const MPI_ERR_TAG         =  4      #= Invalid tag argument =#
const MPI_ERR_COMM        =  5      #= Invalid communicator =#
const MPI_ERR_RANK        =  6      #= Invalid rank =#
const MPI_ERR_ROOT        =  7      #= Invalid root =#
const MPI_ERR_GROUP       =  8      #= Invalid group =#
const MPI_ERR_OP          =  9      #= Invalid operation =#
const MPI_ERR_TOPOLOGY    = 10      #= Invalid topology =#
const MPI_ERR_DIMS        = 11      #= Invalid dimension argument =#
const MPI_ERR_ARG         = 12      #= Invalid argument =#
const MPI_ERR_UNKNOWN     = 13      #= Unknown error =#
const MPI_ERR_TRUNCATE    = 14      #= Message truncated on receive =#
const MPI_ERR_OTHER       = 15      #= Other error; use Error_string =#
const MPI_ERR_INTERN      = 16      #= internal error code    =#
const MPI_ERR_IN_STATUS   = 17      #= Look in status for error value =#
const MPI_ERR_PENDING     = 18      #= Pending request =#
const MPI_ERR_REQUEST     = 19      #= Invalid mpi_request handle =#


# Functions
@inline MPI_Init(argc::Ptr{Int32}, argv::Ptr{Ptr{Ptr{UInt8}}}) = @symbolcall MPI_Init(argc::Ptr{Int32}, argv::Ptr{Ptr{Ptr{UInt8}}})::Int32
@inline MPI_Finalize() = @symbolcall MPI_Finalize()::Int32
@inline MPI_Initialized(flag::Ptr{Int32}) = @symbolcall MPI_Initialized(flag::Ptr{Int32})::Int32
@inline MPI_Abort(comm::MPI_Comm, errorcode::Int32) = @symbolcall MPI_Abort(comm.x::UInt32, errorcode::Int32)::Int32

@inline MPI_Recv( buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, source::Int32, tag::Int32, comm::MPI_Comm, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Recv(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, source::Int32, tag::Int32, comm.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_Irecv(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, source::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Irecv(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, source::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32

@inline MPI_Get_count(status::Ptr{MPI_Status}, datatype::MPI_Datatype, count::Ptr{Int32}) =
   @symbolcall MPI_Get_count(status::Ptr{MPI_Status}, datatype.x::UInt32, count::Ptr{Int32})::Int32

@inline MPI_Send( buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm) =
    @symbolcall MPI_Send( buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32)::Int32
@inline MPI_Bsend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Bsend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32)::Int32
@inline MPI_Ssend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Ssend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32)::Int32
@inline MPI_Rsend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Rsend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32)::Int32
@inline MPI_Isend( buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Isend( buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ibsend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ibsend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Issend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Issend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Irsend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Irsend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32

@inline MPI_Sendrecv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype, dest::Int32,
   sendtag::Int32, recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, source::Int32,
   recvtag::Int32, comm::MPI_Comm, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Sendrecv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32, dest::Int32,
      sendtag::Int32, recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, source::Int32,
      recvtag::Int32, comm.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_Sendrecv_replace(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype,
   dest::Int32, sendtag::Int32, source::Int32, recvtag::Int32, comm::MPI_Comm,
   status::Ptr{MPI_Status}) =
   @symbolcall MPI_Sendrecv_replace(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32,
      dest::Int32, sendtag::Int32, source::Int32, recvtag::Int32, comm.x::UInt32,
      status::Ptr{MPI_Status})::Int32

@inline MPI_Barrier(comm::MPI_Comm) = @symbolcall MPI_Barrier(comm.x::UInt32)::Int32
@inline MPI_Wait(request::Ptr{MPI_Request}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Wait(request::Ptr{MPI_Request}, status::Ptr{MPI_Status})::Int32
@inline MPI_Waitany(count::Int32, array_of_requests::Ptr{MPI_Request}, index::Ptr{Int32}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Waitany(count::Int32, array_of_requests::Ptr{MPI_Request}, index::Ptr{Int32}, status::Ptr{MPI_Status})::Int32
@inline MPI_Waitall(count::Int32, array_of_requests::Ptr{MPI_Request}, array_of_statuses::Ptr{MPI_Status}) =
   @symbolcall MPI_Waitall(count::Int32, array_of_requests::Ptr{MPI_Request}, array_of_statuses::Ptr{MPI_Status})::Int32
@inline MPI_Waitsome(incount::Int32, array_of_requests::Ptr{MPI_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status}) =
   @symbolcall MPI_Waitsome(incount::Int32, array_of_requests::Ptr{MPI_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status})::Int32

@inline MPI_Test(request::Ptr{MPI_Request}, flag::Ptr{Int32}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Test(request::Ptr{MPI_Request}, flag::Ptr{Int32}, status::Ptr{MPI_Status})::Int32
@inline MPI_Testany(count::Int32, array_of_requests::Ptr{MPI_Request}, index::Ptr{Int32}, flag::Ptr{Int32}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Testany(count::Int32, array_of_requests::Ptr{MPI_Request}, index::Ptr{Int32}, flag::Ptr{Int32}, status::Ptr{MPI_Status})::Int32
@inline MPI_Testall(count::Int32, array_of_requests::Ptr{MPI_Request}, flag::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status}) =
   @symbolcall MPI_Testall(count::Int32, array_of_requests::Ptr{MPI_Request}, flag::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status})::Int32
@inline MPI_Testsome(incount::Int32, array_of_requests::Ptr{MPI_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status}) =
   @symbolcall MPI_Testsome(incount::Int32, array_of_requests::Ptr{MPI_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status})::Int32
@inline MPI_Test_cancelled(status::Ptr{MPI_Status}, flag::Ptr{Int32}) =
   @symbolcall MPI_Test_cancelled(status::Ptr{MPI_Status}, flag::Ptr{Int32})::Int32

@inline MPI_Cancel(request::Ptr{MPI_Request}) =
   @symbolcall MPI_Cancel(request::Ptr{MPI_Request})::Int32
@inline MPI_Request_free(request::Ptr{MPI_Request}) =
   @symbolcall MPI_Request_free(request::Ptr{MPI_Request})::Int32
@inline MPI_Buffer_attach(buffer::Ptr{Nothing}, size::Int32) =
   @symbolcall MPI_Buffer_attach(buffer::Ptr{Nothing}, size::Int32)::Int32
@inline MPI_Buffer_detach(buffer_addr::Ptr{Nothing}, size::Ptr{Int32}) =
   @symbolcall MPI_Buffer_attach(buffer::Ptr{Nothing}, size::Int32)::Int32

@inline MPI_Probe(source::Int32, tag::Int32, comm::MPI_Comm, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Probe(source::Int32, tag::Int32, comm.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_Iprobe(source::Int32, tag::Int32, comm::MPI_Comm, flag::Ptr{Int32}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Iprobe(source::Int32, tag::Int32, comm.x::UInt32, flag::Ptr{Int32}, status::Ptr{MPI_Status})::Int32

@inline MPI_Send_init(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Send_init(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Bsend_init(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Bsend_init(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ssend_init(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ssend_init(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Rsend_init(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Rsend_init(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Recv_init(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, source::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Recv_init(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, source::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32

@inline MPI_Start(request::Ptr{MPI_Request}) =
   @symbolcall MPI_Start(request::Ptr{MPI_Request})::Int32
@inline MPI_Startall(count::Int32, array_of_requests::Ptr{MPI_Request}) =
   @symbolcall MPI_Startall(count::Int32, array_of_requests::Ptr{MPI_Request})::Int32

@inline MPI_Scan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm) =
   @symbolcall MPI_Scan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, op.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Exscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm) =
   @symbolcall MPI_Exscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, op.x::UInt32, comm.x::UInt32)::Int32

@inline MPI_Reduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, op::MPI_Op, root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Reduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, op.x::UInt32, root::Int32, comm.x::UInt32)::Int32
@inline MPI_Allreduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm) =
   @symbolcall MPI_Allreduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, op.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Reduce_scatter(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm) =
   @symbolcall MPI_Reduce_scatter(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, datatype.x::UInt32, op.x::UInt32, comm.x::UInt32)::Int32

@inline MPI_Bcast(buffer::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Bcast(buffer::Ptr{Nothing}, count::Int32, datatype.x::UInt32, root::Int32, comm.x::UInt32)::Int32

@inline MPI_Gather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Gather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32)::Int32
@inline MPI_Gatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype,
   root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Gatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32,
      root::Int32, comm.x::UInt32)::Int32

@inline MPI_Scatter(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Scatter(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32)::Int32
@inline MPI_Scatterv(sendbuf::Ptr{Nothing}, sendcounts::Ptr{Int32}, displs::Ptr{Int32}, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Scatterv(sendbuf::Ptr{Nothing}, sendcounts::Ptr{Int32}, displs::Ptr{Int32},sendtype.x::UInt32,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32)::Int32

@inline MPI_Allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32)::Int32

@inline MPI_Alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing},recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing},recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Alltoallv(sendbuf::Ptr{Nothing}, sendcounts::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Alltoallv(sendbuf::Ptr{Nothing}, sendcounts::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtypes::Ptr{MPI_Datatype},
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtypes::Ptr{MPI_Datatype}, comm::MPI_Comm) =
   @symbolcall MPI_Alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtypes::Ptr{MPI_Datatype},
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtypes::Ptr{MPI_Datatype}, comm.x::UInt32)::Int32

@inline MPI_Comm_size(comm::MPI_Comm, size::Ptr{Int32}) = @symbolcall MPI_Comm_size(comm.x::UInt32, size::Ptr{Int32})::Int32
@inline MPI_Comm_rank(comm::MPI_Comm, size::Ptr{Int32}) = @symbolcall MPI_Comm_rank(comm.x::UInt32, size::Ptr{Int32})::Int32
@inline MPI_Comm_compare(comm1::MPI_Comm, comm2::MPI_Comm, result::Ptr{Int32}) = @symbolcall MPI_Comm_compare(comm1.x::UInt32, comm2.x::UInt32, result::Ptr{Int32})::Int32
@inline MPI_Comm_dup(comm::MPI_Comm, newcomm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_dup(comm.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_dup_with_info(comm::MPI_Comm, info::MPI_Info, newcomm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_dup_with_info(comm.x::UInt32, info.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_create(comm::MPI_Comm, group::MPI_Group, newcomm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_create(comm.x::UInt32, group.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_split(comm::MPI_Comm, color::Int32, key::Int32, newcomm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_split(comm.x::UInt32, color::Int32, key::Int32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_free(comm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_free(comm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_test_inter(comm::MPI_Comm, flag::Ptr{Int32}) = @symbolcall MPI_Comm_test_inter(comm.x::UInt32, flag::Ptr{Int32})::Int32
@inline MPI_Comm_remote_size(comm::MPI_Comm, size::Ptr{Int32}) = @symbolcall MPI_Comm_remote_size(comm.x::UInt32, size::Ptr{Int32})::Int32
@inline MPI_Comm_remote_group(comm::MPI_Comm, group::Ptr{MPI_Group}) = @symbolcall MPI_Comm_remote_group(comm.x::UInt32, group::Ptr{MPI_Group})::Int32
@inline MPI_Intercomm_create(local_comm::MPI_Comm, local_leader::Int32, peer_comm::MPI_Comm, remote_leader::Int32, tag::Int32, newintercomm::Ptr{MPI_Comm}) =
   @symbolcall MPI_Intercomm_create(local_comm.x::UInt32, local_leader::Int32, peer_comm.x::UInt32, remote_leader::Int32, tag::Int32, newintercomm::Ptr{MPI_Comm})::Int32
@inline MPI_Intercomm_merge(intercomm::MPI_Comm, high::Int32, newintracomm::Ptr{MPI_Comm}) = @symbolcall MPI_Intercomm_merge(intercomm.x::UInt32, high::Int32, newintracomm::Ptr{MPI_Comm})::Int32

@inline MPI_Group_size(group::MPI_Group, size::Ptr{Int32}) = @symbolcall MPI_Group_size(group.x::UInt32, size::Ptr{Int32})::Int32
@inline MPI_Group_rank(group::MPI_Group, rank::Ptr{Int32}) = @symbolcall MPI_Group_rank(group.x::UInt32, rank::Ptr{Int32})::Int32
@inline MPI_Group_translate_ranks(group1::MPI_Group, n::Int32, ranks1::Ptr{Int32}, group2::MPI_Group, ranks2::Ptr{Int32}) =
   @symbolcall MPI_Group_translate_ranks(group1.x::UInt32, n::Int32, ranks1::Ptr{Int32}, group2.x::UInt32, ranks2::Ptr{Int32})::Int32
@inline MPI_Group_compare(group1::MPI_Group, group2::MPI_Group, result::Ptr{Int32}) = @symbolcall MPI_Group_compare(group1.x::UInt32, group2.x::UInt32, result::Ptr{Int32})::Int32
@inline MPI_Comm_group(comm::MPI_Comm, group::Ptr{MPI_Group}) = @symbolcall MPI_Group_compare(group1.x::UInt32, group2.x::UInt32, result::Ptr{Int32})::Int32
@inline MPI_Group_union(group1::MPI_Group, group2::MPI_Group, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_union(group1.x::UInt32, group2.x::UInt32, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_intersection(group1::MPI_Group, group2::MPI_Group, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_intersection(group1.x::UInt32, group2.x::UInt32, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_difference(group1::MPI_Group, group2::MPI_Group, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_difference(group1.x::UInt32, group2.x::UInt32, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_incl(group::MPI_Group, n::Int32, ranks::Ptr{Int32}, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_incl(group.x::UInt32, n::Int32, ranks::Ptr{Int32}, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_excl(group::MPI_Group, n::Int32, ranks::Ptr{Int32}, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_excl(group.x::UInt32, n::Int32, ranks::Ptr{Int32}, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_range_incl(group::MPI_Group, n::Int32, ranges::Ptr{Int32}, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_range_incl(group.x::UInt32, n::Int32, ranges::Ptr{Int32}, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_range_excl(group::MPI_Group, n::Int32, ranges::Ptr{Int32}, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_range_excl(group.x::UInt32, n::Int32, ranges::Ptr{Int32}, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_free(group::Ptr{MPI_Group}) = @symbolcall MPI_Group_free(group::Ptr{MPI_Group})::Int32

@inline MPI_Reduce_local(inbuf::Ptr{Nothing}, inoutbuf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, op::MPI_Op) =
   @symbolcall  MPI_Reduce_local(inbuf::Ptr{Nothing}, inoutbuf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, op.x::UInt32)::Int32
@inline MPI_Op_commutative(op::MPI_Op, commute::Ptr{Int32}) = @symbolcall MPI_Op_commutative(op.x::UInt32, commute::Ptr{Int32})::Int32
@inline MPI_Reduce_scatter_block(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Int32, datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm) =
   @symbolcall MPI_Reduce_scatter_block(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Int32, datatype.x::UInt32, op.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Dist_graph_create_adjacent(comm_old::MPI_Comm, indegree::Int32, sources::Ptr{Int32}, sourceweights::Ptr{Int32},
   outdegree::Int32, destinations::Ptr{Int32}, destweights::Ptr{Int32}, info::MPI_Info, reorder::Int32, comm_dist_graph::Ptr{MPI_Comm}) =
   @symbolcall  MPI_Dist_graph_create_adjacent(comm_old.x::UInt32, indegree::Int32, sources::Ptr{Int32}, sourceweights::Ptr{Int32},
      outdegree::Int32, destinations::Ptr{Int32}, destweights::Ptr{Int32}, info.x::UInt32, reorder::Int32, comm_dist_graph::Ptr{MPI_Comm})::Int32
@inline MPI_Dist_graph_create(comm_old::MPI_Comm, n::Int32, sources::Ptr{Int32}, degrees::Ptr{Int32},
   destinations::Ptr{Int32}, weights::Ptr{Int32}, info::MPI_Info, reorder::Int32, comm_dist_graph::Ptr{MPI_Comm}) =
   @symbolcall  MPI_Dist_graph_create(comm_old.x::UInt32, n::Int32, sources::Ptr{Int32}, degrees::Ptr{Int32},
      destinations::Ptr{Int32}, weights::Ptr{Int32}, info.x::UInt32, reorder::Int32, comm_dist_graph::Ptr{MPI_Comm})::Int32
@inline MPI_Dist_graph_neighbors_count(comm::MPI_Comm, indegree::Ptr{Int32}, outdegree::Ptr{Int32}, weighted::Ptr{Int32}) =
   @symbolcall MPI_Dist_graph_neighbors_count(comm.x::UInt32, indegree::Ptr{Int32}, outdegree::Ptr{Int32}, weighted::Ptr{Int32})::Int32
@inline MPI_Dist_graph_neighbors(comm::MPI_Comm, maxindegree::Int32, sources::Ptr{Int32},
   sourceweights::Ptr{Int32}, maxoutdegree::Int32, destinations::Ptr{Int32}, destweights::Ptr{Int32}) =
   @symbolcall @inline MPI_Dist_graph_neighbors(comm::MPI_Comm, maxindegree::Int32, sources::Ptr{Int32},
      sourceweights::Ptr{Int32}, maxoutdegree::Int32, destinations::Ptr{Int32}, destweights::Ptr{Int32})::Int32

# Matched probes:
@inline MPI_Improbe(source::Int32, tag::Int32, comm::MPI_Comm, flag::Ptr{Int32}, message::Ptr{MPI_Message}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Improbe(source::Int32, tag::Int32, comm.x::UInt32, flag::Ptr{Int32}, message::Ptr{MPI_Message}, status::Ptr{MPI_Status})::Int32
@inline MPI_Imrecv(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, message::Ptr{MPI_Message}, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Imrecv(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, message::Ptr{MPI_Message}, request::Ptr{MPI_Request})
@inline MPI_Mprobe(source::Int32, tag::Int32, comm::MPI_Comm, message::Ptr{MPI_Message}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Mprobe(source::Int32, tag::Int32, comm.x::UInt32, message::Ptr{MPI_Message}, status::Ptr{MPI_Status})::Int32
@inline MPI_Mrecv(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, message::Ptr{MPI_Message}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Mrecv(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, message::Ptr{MPI_Message}, status::Ptr{MPI_Status})::Int32

# Nonblocking collectives:
@inline MPI_Comm_idup(comm::MPI_Comm, newcomm::Ptr{MPI_Comm}, request::Ptr{MPI_Request}) = @symbolcall MPI_Comm_idup(comm.x::UInt32, newcomm::Ptr{MPI_Comm}, request::Ptr{MPI_Request})::Int32
@inline MPI_Ibarrier(comm::MPI_Comm, request::Ptr{MPI_Request}) = @symbolcall MPI_Ibarrier(comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ibcast(buffer::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ibcast(buffer::Ptr{Nothing}, count::Int32, datatype.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Igather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype, recvbuf::Ptr{Nothing},
   recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Igather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32, recvbuf::Ptr{Nothing},
      recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Igatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype, recvbuf::Ptr{Nothing},
   recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall  MPI_Igatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32, recvbuf::Ptr{Nothing},
      recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iscatter(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype, recvbuf::Ptr{Nothing},
   recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iscatter(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32, recvbuf::Ptr{Nothing},
      recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iscatterv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, displs::Ptr{Int32}, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iscatterv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, displs::Ptr{Int32}, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iallgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iallgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iallgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iallgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ialltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ialltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ialltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall  MPI_Ialltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ialltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtypes::Ptr{MPI_Datatype},
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtypes::Ptr{MPI_Datatype}, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ialltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtypes::Ptr{MPI_Datatype},
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtypes::Ptr{MPI_Datatype}, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ireduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
   datatype::MPI_Datatype, op::MPI_Op, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ireduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
      datatype.x::UInt32, op.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iallreduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
   datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iallreduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
      datatype.x::UInt32, op.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ireduce_scatter(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32},
   datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ireduce_scatter(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32},
      datatype.x::UInt32, op.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ireduce_scatter_block(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Int32,
   datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ireduce_scatter_block(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Int32,
      datatype.x::UInt32, op.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
   datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
      datatype.x::UInt32, op.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iexscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
   datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iexscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
      datatype.x::UInt32, op.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32


# Neighborhood collectives:
@inline MPI_Ineighbor_allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ineighbor_allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ineighbor_allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ineighbor_allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ineighbor_alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall  MPI_Ineighbor_alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ineighbor_alltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ineighbor_alltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ineighbor_alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{MPI_Aint}, sendtypes::Ptr{MPI_Datatype},
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{MPI_Aint}, recvtypes::Ptr{MPI_Datatype}, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ineighbor_alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{MPI_Aint}, sendtypes::Ptr{MPI_Datatype},
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{MPI_Aint}, recvtypes::Ptr{MPI_Datatype}, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Neighbor_allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Neighbor_allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Neighbor_allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Neighbor_allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Neighbor_alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Neighbor_alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Neighbor_alltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32},sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Neighbor_alltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Neighbor_alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{MPI_Aint},sendtypes::Ptr{MPI_Datatype},
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{MPI_Aint}, recvtypes::Ptr{MPI_Datatype}, comm::MPI_Comm) =
   @symbolcall MPI_Neighbor_alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{MPI_Aint},sendtypes::Ptr{MPI_Datatype},
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{MPI_Aint}, recvtypes::Ptr{MPI_Datatype}, comm.x::UInt32)::Int32

# Shared memory:
@inline MPI_Comm_split_type(comm::MPI_Comm, split_type::Int32, key::Int32, info::MPI_Info, newcomm::Ptr{MPI_Comm}) =
   @symbolcall MPI_Comm_split_type(comm.x::UInt32, split_type::Int32, key::Int32, info.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32

# MPI-3 "large count" routines:
@inline MPI_Get_elements_x(status::Ptr{MPI_Status}, datatype::MPI_Datatype, count::Ptr{MPI_Count}) =
   @symbolcall MPI_Get_elements_x(status::Ptr{MPI_Status}, datatype.x::UInt32, count::Ptr{MPI_Count})::Int32
@inline MPI_Status_set_elements_x(status::Ptr{MPI_Status}, datatype::MPI_Datatype, count::MPI_Count) =
   @symbolcall MPI_Status_set_elements_x(status::Ptr{MPI_Status}, datatype.x::UInt32, count.x::Int64)::Int32
@inline MPI_Type_get_extent_x(datatype::MPI_Datatype, lb::Ptr{MPI_Count}, extent::Ptr{MPI_Count}) =
   @symbolcall MPI_Type_get_extent_x(datatype.x::UInt32, lb::Ptr{MPI_Count}, extent::Ptr{MPI_Count})::Int32
@inline MPI_Type_get_true_extent_x(datatype::MPI_Datatype, lb::Ptr{MPI_Count}, extent::Ptr{MPI_Count}) =
   @symbolcall MPI_Type_get_true_extent_x(datatype.x::UInt32, lb::Ptr{MPI_Count}, extent::Ptr{MPI_Count})::Int32
@inline MPI_Type_size_x(datatype::MPI_Datatype, size::Ptr{MPI_Count}) =
   @symbolcall MPI_Type_size_x(datatype.x::UInt32, size::Ptr{MPI_Count})::Int32

# Noncollective communicator creation:
@inline MPI_Comm_create_group(comm::MPI_Comm, group::MPI_Group, tag::Int32, newcomm::Ptr{MPI_Comm}) =
   @symbolcall MPI_Comm_create_group(comm.x::UInt32, group.x::UInt32, tag::Int32, newcomm::Ptr{MPI_Comm})::Int32

# MPI_Aint addressing arithmetic:
@inline MPI_Aint_add(base::MPI_Aint, disp::MPI_Aint) = @symbolcall MPI_Aint_add(base.x::UInt32, disp.x::UInt32)::Int32
@inline MPI_Aint_diff(addr1::MPI_Aint, addr2::MPI_Aint) = @symbolcall MPI_Aint_diff(addr1.x::UInt32, addr2.x::UInt32)::Int32

# Non-standard but public extensions to MPI:
@inline MPIX_Comm_failure_ack(comm::MPI_Comm) = @symbolcall MPIX_Comm_failure_ack(comm.x::UInt32)::Int32
@inline MPIX_Comm_failure_get_acked(comm::MPI_Comm, failedgrp::Ptr{MPI_Count}) = @symbolcall MPIX_Comm_failure_get_acked(comm.x::UInt32, failedgrp::Ptr{MPI_Count})::Int32
@inline MPIX_Comm_revoke(comm::MPI_Comm) = @symbolcall MPIX_Comm_revoke(comm.x::UInt32)::Int32
@inline MPIX_Comm_shrink(comm::MPI_Comm, newcomm::Ptr{MPI_Comm}) = @symbolcall MPIX_Comm_shrink(comm.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPIX_Comm_agree(comm::MPI_Comm, flag::Ptr{Int32}) = @symbolcall MPIX_Comm_agree(comm.x::UInt32, flag::Ptr{Int32})::Int32

# GPU extensions:
const MPIX_GPU_SUPPORT_CUDA  = 0
const MPIX_GPU_SUPPORT_ZE    = 1
const MPIX_GPU_SUPPORT_HIP   = 2
@inline MPIX_GPU_query_support(gpu_type::Int32, is_supported::Ptr{Int32}) = MPIX_GPU_query_support(gpu_type::Int32, is_supported::Ptr{Int32})::Int32
@inline MPIX_Query_cuda_support() = @symbolcall MPIX_Query_cuda_support()::Int32

end # module
