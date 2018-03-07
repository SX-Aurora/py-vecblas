from __future__ import print_function
import numpy as np
import veo as v
import vecblas as vb
import time

#Select a problem size
M = 10000
K = 1000
N = 5000
total_flops = M*K*(2*N+3)

# start VE process
p = v.VeoProc(0)
lib = p.lib["__static__"]

# open a context (worker thread)
ctx = p.open_context()

# Generate input data as numpy arrays
a_np = np.random.rand(M*K).astype(np.float32).reshape(M,K)
b_np = np.random.rand(K*N).astype(np.float32).reshape(K,N)
res_np = np.zeros((M,N)).astype(np.float32)
exp_np = np.copy(res_np)

# Copy memory to VE
a_v = p.alloc_mem(a_np.nbytes)
b_v = p.alloc_mem(b_np.nbytes)
res_v = p.alloc_mem(res_np.nbytes)
p.write_mem(a_v, a_np, a_np.nbytes)
p.write_mem(b_v, b_np, b_np.nbytes)

start_time = time.time()

req = lib.func["cblas_sgemm"](
    ctx,
    vb.CblasRowMajor, vb.CblasNoTrans, vb.CblasNoTrans,
    M, N, K, 1.0, a_v, K, b_v, N, 0.0, res_v, N)

# Wait for the request's completion
req.wait_result()

end_time = time.time()

# Copy result from VE
p.read_mem(res_np, res_v, res_np.nbytes)

print("VEO time (1 core): %f" % (end_time - start_time))
print("VEO GFLOPS (1 core): %f" % (total_flops / (end_time - start_time) / (1024 ** 3)))

# Check result with Numpy:
np_start_time = time.time()
np.dot(a_np, b_np, out=exp_np)
np_end_time = time.time()
print("Numpy time: %f" % (np_end_time - np_start_time))
print("Numpy GFLOPS: %f" % (total_flops / (np_end_time - np_start_time) / (1024 ** 3)))

# Results
print("Total speedup: %5.5gx" % ((np_end_time - np_start_time)/(end_time - start_time)))
print("L2 Norm of (observed - expected):", np.linalg.norm(res_np - exp_np))
