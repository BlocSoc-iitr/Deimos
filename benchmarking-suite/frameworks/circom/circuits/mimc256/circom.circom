pragma circom 2.0.0;

include "../circomlib/circuits/mimc.circom";
include "./mimc256.circom";

template MultiMIMC256(N) {
    signal input in[N];
    signal output out[32];

    component mimc = MultiMiMC7(N, 91);
    for (var i = 0; i < N; i++) {
        mimc.in[i] <== in[i];
    }
    mimc.k <== 0;

    component hashToBytes = HashToBytes();

    hashToBytes.in <== mimc.out;

    for (var i = 0; i < N; i++) {
        out[i] <== hashToBytes.out[i];
    }
}

component main = MultiMIMC256(32);