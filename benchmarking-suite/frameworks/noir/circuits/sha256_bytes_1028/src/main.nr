use dep::sha256::digest;

fn main(input: [u8; 1028]) -> pub [u8; 32] {
    digest(input)
}
