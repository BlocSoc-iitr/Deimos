pragma circom 2.0.0;

include "../circomlib/circuits/rescue-prime/rescue_prime.circom";

template RescuePrimeBench(nInputs) {
    signal input in[nInputs];
    signal output out[1];

    component rp = RescuePrimeHash(nInputs);
    rp.in <== in;
    out <== rp.out;
}

component main {public[in]} = RescuePrimeBench(8);
