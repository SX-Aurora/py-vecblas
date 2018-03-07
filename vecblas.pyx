#
# VE offloaded CBLAS
#
# This module only registers an init hook to the VeoProc
# class. The init hook will be executed each time a VeoProc()
# instance is created, locates and registers the cblas
# functions and their prototypes with the "__static__" library
# of the VeoProc. Of course, VeoProc MUST run the specially
# linked veorun-cblas instead of the default veorun.
#
# (C)opyright 2018 Erich Focht <efocht@hpce.nec.com>
#

CblasRowMajor=101
CblasColMajor=102
CblasNoTrans=111
CblasTrans=112
CblasConjTrans=113
CblasUpper=121
CblasLower=122
CblasNonUnit=131
CblasUnit=132
CblasLeft=141
CblasRight=142

    
# included file contains _cblas_proto
include "cblas_proto.pxi"

from veo import set_proc_init_hook

def _init_cblas_funcs(p):
    lib = p.static_library()
    for k, v in _cblas_proto.items():
        f = lib.find_function(k)
        if f is not None:
            fargs = v["args"]
            f.args_type(*fargs)
            f.ret_type(v["ret"])

set_proc_init_hook(_init_cblas_funcs)
