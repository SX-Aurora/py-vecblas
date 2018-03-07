from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

ext_modules=[
    Extension("vecblas",
              sources=["vecblas.pyx"],
              #libraries=["veo"], # Unix-like specific
    )
]

setup(
  name = "pyVecBlas",
  ext_modules = cythonize(ext_modules)
)
