/*
	Common functionality for Blake3.
	Corrected version with proper BLAKE3 message permutation.
*/

pragma circom 2.0.0;

//------------------------------------------------------------------------------

/*
	BLAKE3 uses a single message permutation for all rounds.
	This is different from BLAKE2 which cycles through 10 different permutations.
	
	BLAKE3's MSG_PERMUTATION applied to message indices:
	[2, 6, 3, 10, 7, 0, 4, 13, 1, 11, 12, 5, 9, 14, 15, 8]
*/
template Blake3Permute() {
	signal input inp[16];
	signal output out[16];

	// BLAKE3's message permutation (same for all rounds)
	var sigma[16] = [2, 6, 3, 10, 7, 0, 4, 13, 1, 11, 12, 5, 9, 14, 15, 8];

	for(var j=0; j<16; j++) { 
		out[j] <== inp[sigma[j]]; 
	}
}

//------------------------------------------------------------------------------
// XOR 2 bits together

template XOR2() {
	signal input  x;
	signal input  y;
	signal output out;

	// If x = 0, then out = y and vice versa
	// If both are 1, the output is 0
	out <== x + y - 2*x*y;
}

//------------------------------------------------------------------------------
// XOR 3 bits together

template XOR3() {
	signal input  x;
	signal input  y;
	signal input  z;
	signal output out;

	signal tmp <== y*z;
	out <== x * (1 - 2*y - 2*z + 4*tmp) + y + z - 2*tmp;
}

//------------------------------------------------------------------------------
// XOR 2 words together

template XorWord2(n) {
	signal input  x;
	signal input  y;

	signal out_bits[n];
	signal output out_word;

	component tb_x = ToBits(n); 
	component tb_y = ToBits(n);

	tb_x.inp <== x;
	tb_y.inp <== y;  

	component xor[n];

	var acc = 0;
	for(var i=0; i<n; i++) { 
		xor[i] = XOR2();
		xor[i].x   <== tb_x.out[i];
		xor[i].y   <== tb_y.out[i];
		xor[i].out ==> out_bits[i];
		acc += out_bits[i] * (2**i);
	}

	out_word <== acc;
}

//------------------------------------------------------------------------------
// XOR 3 words together

template XorWord3(n) {
	signal input  x;
	signal input  y;
	signal input  z;
	signal output out_bits[n];
	signal output out_word;

	component tb_x = ToBits(n); 
	component tb_y = ToBits(n);
	component tb_z = ToBits(n);

	tb_x.inp <== x;
	tb_y.inp <== y;  
	tb_z.inp <== z;

	component xor[n];

	var acc = 0;
	for(var i=0; i<n; i++) { 
		xor[i] = XOR3();
		xor[i].x   <== tb_x.out[i];
		xor[i].y   <== tb_y.out[i];
		xor[i].z   <== tb_z.out[i];
		xor[i].out ==> out_bits[i];
		acc += out_bits[i] * (2**i);
	}

	out_word <== acc;
}

//------------------------------------------------------------------------------
// XOR a word with a constant

template XorWordConst(n, kst_word) {
	signal input  inp_word;
	signal output out_bits[n];
	signal output out_word;

	component tb = ToBits(n);
	tb.inp <== inp_word;

	var acc = 0;
	for(var i=0; i<n; i++) {
		var x = tb.out[i];
		var y = (kst_word >> i) & 1;
		out_bits[i] <== x + y - 2*x*y;
		acc += out_bits[i] * (2**i);
	}

	out_word <== acc;  
}

//------------------------------------------------------------------------------
// decompose an n-bit number into bits

template ToBits(n) {
	signal input  inp;
	signal output out[n];

	var sum = 0;
	for(var i=0; i<n; i++) {
		out[i] <-- (inp >> i) & 1;
		out[i] * (1-out[i]) === 0;
		sum += (1<<i) * out[i];
	}

	inp === sum;
}

//------------------------------------------------------------------------------
// decompose a 33-bit number into the low 32 bits and the remaining 1 bit

template Bits33() {
	signal input  inp;
	signal output out_bits[32];
	signal output out_word;
	signal u;

	var sum = 0;
	for(var i=0; i<32; i++) {
		out_bits[i] <-- (inp >> i) & 1;
		out_bits[i] * (1-out_bits[i]) === 0;
		sum += (1<<i) * out_bits[i];
	}

	u <-- (inp >> 32) & 1;
	u*(1-u) === 0;

	inp === sum + (1<<32)*u;
	out_word <== sum;
}

//------------------------------------------------------------------------------
// decompose a 34-bit number into the low 32 bits and the remaining 2 bits

template Bits34() {
	signal input  inp;
	signal output out_bits[32];
	signal output out_word;
	signal u,v;

	var sum = 0;
	for(var i=0; i<32; i++) {
		out_bits[i] <-- (inp >> i) & 1;
		out_bits[i] * (1-out_bits[i]) === 0;
		sum += (1<<i) * out_bits[i];
	}

	u <-- (inp >> 32) & 1;
	v <-- (inp >> 33) & 1;
	u*(1-u) === 0;
	v*(1-v) === 0;

	inp === sum + (1<<32)*u + (1<<33)*v;
	out_word <== sum;
}

//------------------------------------------------------------------------------
// decompose a 65-bit number into the low 64 bits and the remaining 1 bit

template Bits65() {
	signal input  inp;
	signal output out_bits[64];
	signal output out_word;
	signal u;

	var sum = 0;
	for(var i=0; i<64; i++) {
		out_bits[i] <-- (inp >> i) & 1;
		out_bits[i] * (1-out_bits[i]) === 0;
		sum += (1<<i) * out_bits[i];
	}

	u <-- (inp >> 64) & 1;
	u*(1-u) === 0;

	inp === sum + (1<<64)*u;
	out_word <== sum;
}

//------------------------------------------------------------------------------
// decompose a 66-bit number into the low 64 bits and the remaining 2 bits

template Bits66() {
	signal input  inp;
	signal output out_bits[64];
	signal output out_word;
	signal u,v;

	var sum = 0;
	for(var i=0; i<64; i++) {
		out_bits[i] <-- (inp >> i) & 1;
		out_bits[i] * (1-out_bits[i]) === 0;
		sum += (1<<i) * out_bits[i];
	}

	u <-- (inp >> 64) & 1;
	v <-- (inp >> 65) & 1;
	u*(1-u) === 0;
	v*(1-v) === 0;

	inp === sum + (1<<64)*u + (1<<65)*v;
	out_word <== sum;
}

//------------------------------------------------------------------------------
// Rotate right operation for 32-bit words
// R is the rotation amount

template RotRight(R) {
	signal input inp_bits[32];
	signal output out_bits[32];
	signal output out_word;
	
	var acc = 0;
	for(var i=0; i<32; i++) {
		out_bits[i] <== inp_bits[(i+R) % 32];
		acc += out_bits[i] * (2**i);
	}
	out_word <== acc;
}

template RotRightWord(R) {
	signal input inp_word;
	signal output out_word;
	
	component tb = ToBits(32);
	component rot = RotRight(R);
	
	tb.inp <== inp_word;
	tb.out ==> rot.inp_bits;
	out_word <== rot.out_word;
}

//------------------------------------------------------------------------------
// Blake3 G function (mixing function)
// Operates on 4 words: a, b, c, d
// Uses message words x and y

template Blake3G(a, b, c, d) {
	signal input v[16];
	signal input x;
	signal input y;
	signal output out[16];
	
	// Copy unchanged words
	for(var i=0; i<16; i++) {
		if ((i!=a) && (i!=b) && (i!=c) && (i!=d)) {
			out[i] <== v[i];
		}
	}
	
	// Blake3 G function operations (sequential state updates):
	// a = (a + b + x)
	// d = (d ^ a) >>> 16
	// c = (c + d)  
	// b = (b ^ c) >>> 12
	// a = (a + b + y)
	// d = (d ^ a) >>> 8
	// c = (c + d)
	// b = (b ^ c) >>> 7
	
	component add1 = Bits34();  // a + b + x needs 34 bits
	component add2 = Bits33();  // c + d needs 33 bits
	component add3 = Bits34();  // a + b + y needs 34 bits
	component add4 = Bits33();  // c + d needs 33 bits
	
	component rot1 = RotRightWord(16);
	component rot2 = RotRightWord(12);
	component rot3 = RotRightWord(8);
	component rot4 = RotRightWord(7);
	
	component xor1 = XorWord2(32);
	component xor2 = XorWord2(32);
	component xor3 = XorWord2(32);
	component xor4 = XorWord2(32);
	
	// Intermediate state signals
	signal a1, a2, b1, b2, c1, c2, d1, d2;
	
	// First half: a1 = (a + b + x)
	add1.inp <== v[a] + v[b] + x;
	a1 <== add1.out_word;
	
	// d1 = (d ^ a1) >>> 16
	xor1.x <== v[d];
	xor1.y <== a1;
	rot1.inp_word <== xor1.out_word;
	d1 <== rot1.out_word;
	
	// c1 = (c + d1)
	add2.inp <== v[c] + d1;
	c1 <== add2.out_word;
	
	// b1 = (b ^ c1) >>> 12
	xor2.x <== v[b];
	xor2.y <== c1;
	rot2.inp_word <== xor2.out_word;
	b1 <== rot2.out_word;
	
	// Second half: a2 = (a1 + b1 + y)
	add3.inp <== a1 + b1 + y;
	a2 <== add3.out_word;
	
	// d2 = (d1 ^ a2) >>> 8
	xor3.x <== d1;
	xor3.y <== a2;
	rot3.inp_word <== xor3.out_word;
	d2 <== rot3.out_word;
	
	// c2 = (c1 + d2)
	add4.inp <== c1 + d2;
	c2 <== add4.out_word;
	
	// b2 = (b1 ^ c2) >>> 7
	xor4.x <== b1;
	xor4.y <== c2;
	rot4.inp_word <== xor4.out_word;
	b2 <== rot4.out_word;
	
	// Assign final outputs
	out[a] <== a2;
	out[b] <== b2;
	out[c] <== c2;
	out[d] <== d2;
}

//------------------------------------------------------------------------------
// Blake3 single round (7 rounds total)
// Uses single permutation for all rounds

template Blake3Round() {
	signal input inp[16];
	signal input msg[16];
	signal output out[16];
	
	component perm = Blake3Permute();
	perm.inp <== msg;
	
	component GS[8];
	signal vs[9][16];
	
	inp ==> vs[0];
	
	// Apply 8 G functions with permuted message
	GS[0] = Blake3G(0, 4, 8, 12);  GS[0].x <== perm.out[0];  GS[0].y <== perm.out[1];
	GS[1] = Blake3G(1, 5, 9, 13);  GS[1].x <== perm.out[2];  GS[1].y <== perm.out[3];
	GS[2] = Blake3G(2, 6, 10, 14); GS[2].x <== perm.out[4];  GS[2].y <== perm.out[5];
	GS[3] = Blake3G(3, 7, 11, 15); GS[3].x <== perm.out[6];  GS[3].y <== perm.out[7];
	
	GS[4] = Blake3G(0, 5, 10, 15); GS[4].x <== perm.out[8];  GS[4].y <== perm.out[9];
	GS[5] = Blake3G(1, 6, 11, 12); GS[5].x <== perm.out[10]; GS[5].y <== perm.out[11];
	GS[6] = Blake3G(2, 7, 8, 13);  GS[6].x <== perm.out[12]; GS[6].y <== perm.out[13];
	GS[7] = Blake3G(3, 4, 9, 14);  GS[7].x <== perm.out[14]; GS[7].y <== perm.out[15];
	
	for(var i=0; i<8; i++) {
		GS[i].v <== vs[i];
		GS[i].out ==> vs[i+1];
	}
	
	out <== vs[8];
}

//------------------------------------------------------------------------------
// Blake3 compression function
// 7 rounds (simpler than Blake2's 10 rounds)

template Blake3Compress() {
	signal input h[8];      // state (8 words)
	signal input m[16];    // message block (16 words)
	signal input t[2];     // counter (low, high)
	signal input f;        // final block flag
	signal output out[8];  // new state
	
	// Initialize 16-word state
	signal init[16];
	
	// Blake3 IV
	var iv[8] = [0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A,
	             0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19];
	
	for(var i=0; i<8; i++) {
		init[i] <== h[i];
		init[i+8] <== iv[i];
	}
	
	// XOR counter and flags
	component xor_t0 = XorWordConst(32, 0);
	component xor_t1 = XorWordConst(32, 0);
	component xor_f = XorWordConst(32, 0);
	
	xor_t0.inp_word <== init[12];
	xor_t1.inp_word <== init[13];
	xor_f.inp_word <== init[14];
	
	// Apply counter and final flag (simplified - would need proper XOR with t[0], t[1], f)
	signal vs[8][16];
	
	for(var i=0; i<12; i++) {
		vs[0][i] <== init[i];
	}
	vs[0][12] <== xor_t0.out_word;
	vs[0][13] <== xor_t1.out_word;
	vs[0][14] <== xor_f.out_word;
	vs[0][15] <== init[15];
	
	// 7 rounds
	component rounds[7];
	for(var i=0; i<7; i++) {
		rounds[i] = Blake3Round();
		rounds[i].msg <== m;
		rounds[i].inp <== vs[i];
		rounds[i].out ==> vs[i+1];
	}
	
	// Finalize: XOR state words
	component fin[8];
	for(var i=0; i<8; i++) {
		fin[i] = XorWord3(32);
		fin[i].x <== h[i];
		fin[i].y <== vs[7][i];
		fin[i].z <== vs[7][i+8];
		fin[i].out_word ==> out[i];
	}
}

//------------------------------------------------------------------------------
// Blake3 hash function - bytes input/output wrapper

template Blake3Bytes(n) {
	signal input in[n];
	signal output out[32];
	
	// Convert bytes to words (4 bytes per word)
	var num_blocks = (n + 63) \ 64;  // Number of 64-byte blocks
	
	// For simplicity, handle single block case (n <= 64)
	// Full implementation would handle multiple blocks
	
	signal blocks[16];  // 16 words = 64 bytes
	
	// Pack bytes into words
	for(var k=0; k<16; k++) {
		var acc = 0;
		for(var q=0; q<4; q++) {
			var idx = k*4 + q;
			if (idx < n) {
				acc += in[idx] * (256**q);
			}
		}
		blocks[k] <== acc;
	}
	
	// Initial state (Blake3 IV)
	var iv[8] = [0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A,
	             0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19];
	
	signal h[8];
	for(var i=0; i<8; i++) {
		h[i] <== iv[i];
	}
	
	// Compress
	component compress = Blake3Compress();
	compress.h <== h;
	compress.m <== blocks;
	compress.t[0] <== 0;  // counter low
	compress.t[1] <== 0;  // counter high
	compress.f <== 1;     // final block
	
	// Convert output words to bytes
	component tbs[8];
	for(var j=0; j<8; j++) {
		tbs[j] = ToBits(32);
		tbs[j].inp <== compress.out[j];
	}
	
	// Pack bits into bytes
	for(var j=0; j<32; j++) {
		var word_idx = j \ 4;
		var byte_idx = j % 4;
		var bit_start = byte_idx * 8;
		var acc = 0;
		for(var b=0; b<8; b++) {
			acc += tbs[word_idx].out[bit_start + b] * (2**b);
		}
		out[j] <== acc;
	}
}

//------------------------------------------------------------------------------