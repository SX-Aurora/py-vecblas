#
# required packages
#   veoffload
#   protobuf-c
#   log4c
#

VEPREFIX=/opt/nec/ve
BLASPATH=${VEPREFIX}/nlc/1.0.0/lib

all: veorun_vecblas veorun_vecblas_par vecblas.so

vecblas.so: vecblas.pyx cblas_proto.pxi
	CFLAGS="-I/opt/nec/ve/veos/include -pthread" \
	LDFLAGS="-L/opt/nec/ve/veos/lib64 -Wl,-rpath=/opt/nec/ve/veos/lib64" \
	python setup.py build_ext -i

veorun_vecblas:
	${VEPREFIX}/libexec/mk_veorun_static veorun_vecblas \
	  ${BLASPATH}/libcblas.a ${BLASPATH}/libblas_sequential.a

veorun_vecblas_par:
	env CFLAGS="-fopenmp" ${VEPREFIX}/libexec/mk_veorun_static veorun_vecblas_par \
	  ${BLASPATH}/libcblas.a ${BLASPATH}/libblas_openmp.a

test:
	env VEORUN_BIN=`pwd`/veorun_vecblas PYTHONPATH=.:../py-veo python test-sgemm.py

test_par:
	env OMP_NUM_THREADS=2 VEORUN_BIN=`pwd`/veorun_vecblas_par PYTHONPATH=.:../py-veo python test-sgemm.py
	env OMP_NUM_THREADS=4 VEORUN_BIN=`pwd`/veorun_vecblas_par PYTHONPATH=.:../py-veo python test-sgemm.py
	env OMP_NUM_THREADS=8 VEORUN_BIN=`pwd`/veorun_vecblas_par PYTHONPATH=.:../py-veo python test-sgemm.py

clean:
	rm -f *.so veorun_vecblas; rm -rf build

.PHONY: all clean test
