pragma circom 2.0.0;

include "../circomlib/circuits/pedersen.circom";

template Main(N) {
    signal input in[N];
    signal output out[2];

    component pedersen = Pedersen(N);
    pedersen.in <== in;

    out <== pedersen.out;
}

component main {public[in]} = Main(32);

