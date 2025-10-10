pragma circom 2.0.0;

include "../circomlib/circuits/mimc.circom";


template MultiMIMC256(N) {
    signal input in[N];
    signal output out;

    component mimc = MultiMiMC7(N, 91);
    for (var i = 0; i < N; i++) {
        mimc.in[i] <== in[i];
    }
    mimc.k <== 0;

    out <== mimc.out;
}

component main = MultiMIMC256(32);