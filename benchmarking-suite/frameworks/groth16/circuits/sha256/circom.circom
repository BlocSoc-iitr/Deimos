pragma circom 2.0.3;

include "./sha256.circom";

template Sha256Bench(N) {
    signal input in[N];
    signal output out[32];

    component sha256 = Sha256Bytes(N);
    sha256.in <== in;
    out <== sha256.out;
}

component main {public[in]} = Sha256Bench(32);