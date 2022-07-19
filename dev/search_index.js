var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = StaticMPI","category":"page"},{"location":"#StaticMPI","page":"Home","title":"StaticMPI","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for StaticMPI.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [StaticMPI]","category":"page"},{"location":"#StaticMPI.MPI_Comm_rank-Tuple{Ptr{Ptr{UInt8}}}","page":"Home","title":"StaticMPI.MPI_Comm_rank","text":"MPI_Comm_size(comm)\n\nObtain the rank of the calling MPI task within the specified MPI communicator COMM\n\n\n\n\n\n","category":"method"},{"location":"#StaticMPI.MPI_Comm_size-Tuple{Ptr{Ptr{UInt8}}}","page":"Home","title":"StaticMPI.MPI_Comm_size","text":"MPI_Comm_size(comm)\n\nObtain the number of tasks in the specified MPI communicator comm.\n\n\n\n\n\n","category":"method"},{"location":"#StaticMPI.MPI_Finalize-Tuple{}","page":"Home","title":"StaticMPI.MPI_Finalize","text":"MPI_Finalize()\n\nConclude the execution of the calling mpi task.\n\n\n\n\n\n","category":"method"},{"location":"#StaticMPI.MPI_Init","page":"Home","title":"StaticMPI.MPI_Init","text":"MPI_Init()\nMPI_Init(argc::Int, argv::Ptr{Ptr{UInt8}})\n\nInitialize the execution environment of the calling MPI task for single- threaded execution. The optional arguments argc and argv are the traditional argument count and argument value pointer variables passed to a compiled executable by the operating system.\n\nReturns MPI_SUCCESS on success\n\n\n\n\n\n","category":"function"},{"location":"#StaticMPI.mpi_comm_world-Tuple{}","page":"Home","title":"StaticMPI.mpi_comm_world","text":"mpi_comm_world(implementation=OpenMPI())\n\nObtain an MPI communicator that includes all available MPI tasks. Since the format of MPI communicators is implementation-dependent, you should specify which MPI implementation you are using (either MPICH() or OpenMPI())\n\n\n\n\n\n","category":"method"}]
}
