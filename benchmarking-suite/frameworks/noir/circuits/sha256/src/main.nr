use dep::sha256::sha256_var;

fn main(input: [u8; 32]) -> pub [u8; 32] {
    // Hash the full 32-byte input using sha256
    sha256_var(input, 32)
}
