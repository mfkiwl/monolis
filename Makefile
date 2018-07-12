
FLAG_MPI   = -DWITH_MPI
FLAG_METIS = -DWITH_METIS
FLAG_DDM   = -DOVER_DDM
#FLAG_TEST  = -DTEST_ALL
CPP        = -cpp $(FLAG_MPI) $(FLAG_METIS)

FC         = mpif90
FFLAGS     = -O2 -fbounds-check -fbacktrace -ffpe-trap=invalid
CC         = mpicc
CFLAGS     =

METIS_DIR  = /Users/morita
METIS_INC  = -I $(METIS_DIR)/include
METIS_LIB  = -L$(METIS_DIR)/lib -lmetis

INCLUDE    = -I ./include
MOD_DIR    = -J ./include
LIBRARY    = $(METIS_LIB)
BIN_DIR    = ./bin
SRC_DIR    = ./src
SMP_DIR    = ./sample
OBJ_DIR    = ./obj
LIB_DIR    = ./lib
BIN_LIST   = monolis
LIB_LIST   = libmonolis.a
SMP1_LIST  = hash_table/monolis_sample
SMP2_LIST  = matrix_market/monolis_sample
SMP3_LIST  = matrix_market_c/monolis_sample
RM         = rm -r
AR         = - ar ruv

TARGET     = $(addprefix $(BIN_DIR)/, $(BIN_LIST))
LIBTARGET  = $(addprefix $(LIB_DIR)/, $(LIB_LIST))
SMP1TARGET  = $(addprefix $(SMP_DIR)/, $(SMP1_LIST))
SMP2TARGET  = $(addprefix $(SMP_DIR)/, $(SMP2_LIST))
SMP3TARGET  = $(addprefix $(SMP_DIR)/, $(SMP3_LIST))

SRC_LIST_UTIL = def_prm.f90 def_mat.f90 def_com.f90 util.f90 fillin.f90 transpose.f90 hash.f90
SRC_LIST_CONV = convert.f90
SRC_LIST_ALGO = linalg_com.f90 linalg_util.f90 linalg.f90 matvec.f90 converge.f90 scaling.f90 restruct.f90 reorder.f90
SRC_LIST_FACT = 33/fact_LU_33.f90 fact_LU.f90
SRC_LIST_PREC = 33/diag_33.f90 33/sor_33.f90 nn/diag_nn.f90 nn/sor_nn.f90 diag.f90 ilu.f90 sor.f90 Jacobi.f90 precond.f90
SRC_LIST_DIRC = LU.f90
SRC_LIST_ITER = IR.f90 SOR.f90 CG.f90 GropCG.f90 PipeCR.f90 PipeCG.f90 BiCGSTAB.f90 BiCGSTAB_noprec.f90 CABiCGSTAB_noprec.f90 PipeBiCGSTAB.f90 PipeBiCGSTAB_noprec.f90
SRC_LIST_LIB  = monolis_solve.f90 monolis.f90
SRC_LIST_MAIN = main.f90
SRC_LIST_SMP1 = hash_table/main.f90
SRC_LIST_SMP2 = matrix_market/main.f90
SRC_LIST_SMP3 = matrix_market_c/main.c

SRC_ALL_LIST    = $(addprefix util/, $(SRC_LIST_UTIL)) $(addprefix convert/, $(SRC_LIST_CONV)) $(addprefix linalg/, $(SRC_LIST_ALGO)) $(addprefix factorize/, $(SRC_LIST_FACT)) $(addprefix precond/, $(SRC_LIST_PREC)) $(addprefix direct/, $(SRC_LIST_DIRC)) $(addprefix iterative/, $(SRC_LIST_ITER)) $(addprefix main/, $(SRC_LIST_LIB)) $(addprefix main/, $(SRC_LIST_MAIN))
SRC_ALL_LIST_AR = $(addprefix util/, $(SRC_LIST_UTIL)) $(addprefix convert/, $(SRC_LIST_CONV)) $(addprefix linalg/, $(SRC_LIST_ALGO)) $(addprefix factorize/, $(SRC_LIST_FACT)) $(addprefix precond/, $(SRC_LIST_PREC)) $(addprefix direct/, $(SRC_LIST_DIRC)) $(addprefix iterative/, $(SRC_LIST_ITER)) $(addprefix main/, $(SRC_LIST_LIB))

SOURCES    = $(addprefix $(SRC_DIR)/, $(SRC_ALL_LIST))
SOURCES_AR = $(addprefix $(SRC_DIR)/, $(SRC_ALL_LIST_AR))
SAMPLE1    = $(addprefix $(SMP_DIR)/, $(SRC_LIST_SMP1))
SAMPLE2    = $(addprefix $(SMP_DIR)/, $(SRC_LIST_SMP2))
SAMPLE3    = $(addprefix $(SMP_DIR)/, $(SRC_LIST_SMP3))

OBJS    = $(subst $(SRC_DIR), $(OBJ_DIR), $(SOURCES:.f90=.o))
OBJS_AR = $(subst $(SRC_DIR), $(OBJ_DIR), $(SOURCES_AR:.f90=.o))
SMP1    = $(SAMPLE1:.f90=.o)
SMP2    = $(SAMPLE2:.f90=.o)
SMP3    = $(SAMPLE3:.c=.o)

all: $(TARGET) $(LIBTARGET) $(SMP1TARGET) $(SMP2TARGET) $(SMP3TARGET)

$(TARGET): $(OBJS)
	$(FC) -o $@ $(OBJS) $(LIBRARY)

$(LIBTARGET): $(OBJS_AR)
	$(AR) $@ $(OBJS_AR)

$(SMP1TARGET): $(SMP1)
	$(FC) -o $@ $(SMP1) $(LIBRARY) -L$(LIB_DIR) -lmonolis

$(SMP2TARGET): $(SMP2)
	$(FC) -o $@ $(SMP2) $(LIBRARY) -L$(LIB_DIR) -lmonolis

$(SMP3TARGET): $(SMP3)
	$(FC) -o $@ $(SMP3) $(LIBRARY) -L$(LIB_DIR) -lmonolis

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.f90
	$(FC) $(FFLAGS) $(CPP) $(INCLUDE) $(MOD_DIR) -o $@ -c $<

$(SMP_DIR)/%.o: $(SMP_DIR)/%.f90
	$(FC) $(FFLAGS) $(CPP) $(INCLUDE) -o $@ -c $<

$(SMP_DIR)/%.o: $(SMP_DIR)/%.c
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $<

clean:
	$(RM) $(OBJS) $(SMP1) $(SMP2) $(TARGET) $(LIBTARGET) $(SMP1TARGET) $(SMP2TARGET) $(SMP3TARGET) ./include/*.mod

distclean:
	$(RM) $(OBJS) $(SMP1) $(SMP2) $(TARGET) $(LIBTARGET) $(SMP1TARGET) $(SMP2TARGET) $(SMP3TARGET)  ./include/*.mod

sampleclean:
	$(RM) $(SMP1) $(SMP2) $(SMP1TARGET) $(SMP2TARGET) $(SMP3TARGET)

.PHONY: clean
