# py-vecblas - VE accelerated CBLAS in Python

This tiny module uses [py-veo](https://github.com/SX-Aurora/py-veo),
[VEO](https://github.com/veos-sxarr/veoffload) and the NEC accelerated
library collection NLC, which is part of the SX-Aurora TSUBASA SDK. It
enables Python programs to use the accelerated CBLAS libraries running
on the vector engine and reach performances of up to 3.8TFLOPS on
SGEMM from the python command line with only one VE card.


## Prerequisites

A new version of *veoffload* and *veoffload-veorun* (preferably from the features-all branch of http://github.com/SX-Aurora/veoffload).

The *py-veo* Python module from https://github.com/SX-Aurora/py-veo.

The SX-Aurora TSUBASA SDK installed in the default location /opt/nec/ve/nlc/.


## Building

Clone repository from github and type *make*.
```
git clone http://github.com/SX-Aurora/py-vecblas
cd py-vecblas
make
```
