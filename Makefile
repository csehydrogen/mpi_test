CXX=mpic++

# number of processes and hosts
MPIFLAGS=-np 2 -H tower,palace

# OpenMPI picks PML (point-to-point management layer) as follows:
# 1. If InfiniBand devices are available, use the UCX PML.
#   (UCX is a preferred way to use InfiniBand, even though other PMLs also support InfiniBand.)
# 2. If tag-matching-supporting Libfabric transport devices are available, use the "cm" PML
#    with a corresponding "mtl" module.
# 3. OPTherwise, use the ob1 PML and onr or more appropriate "btl" modules.

# ucx PML
MPIFLAGS+=--mca pml ucx

# cm PML + ofi MTL
#MPIFLAGS+=--mca pml cm --mca mtl ofi

# ob1 PML + openib BTL
#MPIFLAGS+=--mca pml ob1 --mca btl openib,self
# As of Open MPI v4.0.0, the use of InfiniBand over the openib BTL is deprecated.
# So the following line is needed to enable them.
#MPIFLAGS+=--mca btl_openib_allow_ib true

# Verbosity flags - useful for debugging
MPIFLAGS+=--mca orte_base_help_aggregate 0 
MPIFLAGS+=--mca pml_base_verbose 9
MPIFLAGS+=--mca mtl_base_verbose 9
MPIFLAGS+=--mca btl_base_verbose 9

# Useful command examples
# ompi_info
# : Display all the general parameters
# ompi_info --param btl tcp --level 9
# : Display specified parameters

all: main

run: main
	mpirun $(MPIFLAGS) ./main

clean:
	rm main
