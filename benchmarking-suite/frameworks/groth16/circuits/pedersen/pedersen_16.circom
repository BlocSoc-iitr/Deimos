pragma circom 2.0.0;

include "../circomlib/circuits/pedersen.circom";
include "../circomlib/circuits/bitify.circom";

template PedersenBytes(nBytes) {
    signal input in[nBytes];
    signal output out[2];

    component pedersen = Pedersen(nBytes * 8);
    component b2b[nBytes];

    for (var i = 0; i < nBytes; i++) {
        b2b[i] = Num2Bits(8);
        b2b[i].in <== in[i];
        for (var j = 0; j < 8; j++) {
            pedersen.in[i*8 + j] <== b2b[i].out[j];
        }
    }
    out <== pedersen.out;
}

component main {public[in]} = PedersenBytes(16);
