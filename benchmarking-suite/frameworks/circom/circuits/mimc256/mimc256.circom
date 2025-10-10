pragma circom 2.1.2;

include "../circomlib/circuits/bitify.circom";

/**
 * Converts a 256-bit number to N bytes array
 * @input  in  The input 256-bit number
 * @output out The N bytes (little-endian)
 */
template HashToBytes(N) {
    signal input in;       // 256-bit number
    signal output out[N]; // N bytes array
    
    // Use Num2Bits to convert the entire number to N * 8 bits first
    component num2bits = Num2Bits(N * 8);
    num2bits.in <== in;    

    component bits_to_bytes[N];
    
    for (var i = 0; i < N; i++) {
    bits_to_bytes[i] = Bits2Num(8);

        for (var j = 0; j < 8; j++) {
            bits_to_bytes[i].in[j] <== num2bits.out[i*8 + j];
        }
        
        out[i] <== bits_to_bytes[i].out;
    }
}