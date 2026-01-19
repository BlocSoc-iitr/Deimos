#ifndef pedersen_H
#define pedersen_H

#ifdef __cplusplus
extern "C" {
#endif

#include "w2c2_base.h"

typedef struct pedersenInstance {
wasmModuleInstance common;
wasmMemory* m0;
wasmTable t0;
} pedersenInstance;

void runtime__exceptionHandler(void*,U32);

void runtime__printErrorMessage(void*);

void runtime__writeBufferMessage(void*);

void runtime__showSharedRWMemory(void*);

void f4(pedersenInstance*,U32,U32);

void f5(pedersenInstance*,U32);

U32 f6(pedersenInstance*,U32);

void f7(pedersenInstance*,U32);

U32 f8(pedersenInstance*,U32,U32);

U32 f9(pedersenInstance*,U32,U32);

U32 f10(pedersenInstance*,U32,U32);

U32 f11(pedersenInstance*,U32,U32,U32);

U32 f12(pedersenInstance*,U32,U32,U32);

void f13(pedersenInstance*,U32,U32,U32);

void f14(pedersenInstance*,U32,U32);

void f15(pedersenInstance*,U32,U32);

void f16(pedersenInstance*,U32,U64,U32);

void f17(pedersenInstance*,U32,U64);

void f18(pedersenInstance*,U32,U32,U32,U32);

void f19(pedersenInstance*,U32,U32,U32);

void f20(pedersenInstance*,U32,U32,U32);

void f21(pedersenInstance*,U32,U32,U32);

void f22(pedersenInstance*,U32,U32);

void f23(pedersenInstance*,U32,U32);

void f24(pedersenInstance*,U32,U32,U32);

void f25(pedersenInstance*,U32,U32);

void f26(pedersenInstance*,U32,U32);

void f27(pedersenInstance*,U32,U32);

void f28(pedersenInstance*,U32,U32);

U32 f29(pedersenInstance*,U32);

void f30(pedersenInstance*,U32,U32);

void f31(pedersenInstance*,U32);

void f32(pedersenInstance*,U32,U32,U32);

void f33(pedersenInstance*,U32,U32,U32,U32);

void f34(pedersenInstance*,U32,U32,U32,U32);

void f35(pedersenInstance*,U32,U32);

U32 f36(pedersenInstance*,U32);

void f37(pedersenInstance*,U32,U32);

void f38(pedersenInstance*,U32,U32,U32);

U32 f39(pedersenInstance*,U32);

void f40(pedersenInstance*,U32,U64);

void f41(pedersenInstance*,U32);

void f42(pedersenInstance*,U32);

void f43(pedersenInstance*,U32);

U32 f44(pedersenInstance*,U32);

void f45(pedersenInstance*,U32,U32);

U32 f46(pedersenInstance*,U32);

U32 f47(pedersenInstance*,U32);

void f48(pedersenInstance*,U32,U32,U32);

void f49(pedersenInstance*,U32,U32,U32);

U32 f50(pedersenInstance*,U32,U32);

U32 f51(pedersenInstance*,U32,U32);

void f52(pedersenInstance*,U32,U32,U32);

void f53(pedersenInstance*,U32,U32,U32);

void f54(pedersenInstance*,U32,U32,U32);

void f55(pedersenInstance*,U32,U32,U32);

void f56(pedersenInstance*,U32,U32,U32);

void f57(pedersenInstance*,U32,U32,U32);

void f58(pedersenInstance*,U32,U32,U32);

void f59(pedersenInstance*,U32,U32,U32);

void f60(pedersenInstance*,U32,U32,U32);

void f61(pedersenInstance*,U32,U32);

void f62(pedersenInstance*,U32,U32,U32);

void f63(pedersenInstance*,U32,U32,U32);

U64 f64(pedersenInstance*,U64,U64);

U64 f65(pedersenInstance*,U64,U64);

U64 f66(pedersenInstance*,U32,U32);

void f67(pedersenInstance*,U32,U32,U32);

void f68(pedersenInstance*,U32,U32,U32);

void f69(pedersenInstance*,U32);

void f70(pedersenInstance*,U32,U32,U32);

void f71(pedersenInstance*,U32,U32,U32);

void f72(pedersenInstance*,U32,U32,U32);

void f73(pedersenInstance*,U32,U32,U32);

void f74(pedersenInstance*,U32,U32,U32);

void f75(pedersenInstance*,U32,U32,U32);

void f76(pedersenInstance*,U32,U32,U32);

void f77(pedersenInstance*,U32,U32,U32);

void f78(pedersenInstance*,U32,U32,U32);

void f79(pedersenInstance*,U32,U32,U32);

void f80(pedersenInstance*,U32,U32);

void f81(pedersenInstance*,U32,U32);

void f82(pedersenInstance*,U32,U32,U32);

void f83(pedersenInstance*,U32,U32,U32);

void f84(pedersenInstance*,U32,U32);

U32 f85(pedersenInstance*,U32,U32);

U32 f86(pedersenInstance*);

U32 f87(pedersenInstance*);

U32 f88(pedersenInstance*);

U32 f89(pedersenInstance*);

U32 f90(pedersenInstance*,U32);

void f91(pedersenInstance*,U32,U32);

U32 f92(pedersenInstance*,U32);

void f93(pedersenInstance*,U32);

U32 f94(pedersenInstance*,U64);

U32 f95(pedersenInstance*,U32);

void f96(pedersenInstance*,U32,U32,U32);

U32 f97(pedersenInstance*,U32,U32);

void f98(pedersenInstance*);

U32 f99(pedersenInstance*);

U32 f100(pedersenInstance*);

U32 f101(pedersenInstance*);

void f102(pedersenInstance*,U32);

void f103(pedersenInstance*,U32);

void f104(pedersenInstance*,U32);

U32 f105(pedersenInstance*);

void f106(pedersenInstance*,U32,U32);

void f107(pedersenInstance*,U32);

U32 f108(pedersenInstance*,U32);

U32 f109(pedersenInstance*,U32);

U32 f110(pedersenInstance*,U32);

U32 f111(pedersenInstance*,U32);

U32 f112(pedersenInstance*,U32);

U32 f113(pedersenInstance*,U32);

U32 f114(pedersenInstance*,U32);

U32 f115(pedersenInstance*,U32);

U32 f116(pedersenInstance*,U32);

U32 f117(pedersenInstance*,U32);

U32 f118(pedersenInstance*,U32);

U32 f119(pedersenInstance*,U32);

U32 f120(pedersenInstance*,U32);

U32 f121(pedersenInstance*,U32);

U32 f122(pedersenInstance*,U32);

U32 f123(pedersenInstance*,U32);

U32 f124(pedersenInstance*,U32);

U32 f125(pedersenInstance*,U32);

wasmMemory*pedersen_memory(pedersenInstance* i);

U32 pedersen_getVersion(pedersenInstance*i);

U32 pedersen_getMinorVersion(pedersenInstance*i);

U32 pedersen_getPatchVersion(pedersenInstance*i);

U32 pedersen_getSharedRWMemoryStart(pedersenInstance*i);

U32 pedersen_readSharedRWMemory(pedersenInstance*i,U32 l0);

void pedersen_writeSharedRWMemory(pedersenInstance*i,U32 l0,U32 l1);

void pedersen_init(pedersenInstance*i,U32 l0);

void pedersen_setInputSignal(pedersenInstance*i,U32 l0,U32 l1,U32 l2);

U32 pedersen_getInputSignalSize(pedersenInstance*i,U32 l0,U32 l1);

void pedersen_getRawPrime(pedersenInstance*i);

U32 pedersen_getFieldNumLen32(pedersenInstance*i);

U32 pedersen_getWitnessSize(pedersenInstance*i);

U32 pedersen_getInputSize(pedersenInstance*i);

void pedersen_getWitness(pedersenInstance*i,U32 l0);

U32 pedersen_getMessageChar(pedersenInstance*i);

void pedersenInstantiate(pedersenInstance* instance, void* resolve(const char* module, const char* name));

void pedersenFreeInstance(pedersenInstance* instance);

#ifdef __cplusplus
}
#endif

#endif /* pedersen_H */

