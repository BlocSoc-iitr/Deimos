use dep::std::hash::blake3;

fn main(input: [u8; 256]) -> pub [u8; 32] {
    blake3(input)
}
