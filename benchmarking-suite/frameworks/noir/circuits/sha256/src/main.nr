use dep::sha256::digest;

fn main(input: [u8; 32]) -> pub [u8; 32] {
    // Hash the full 32-byte input using sha256
    digest(input)
}
