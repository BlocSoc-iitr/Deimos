use dep::std::hash::blake2s;

fn main(input: [u8; 256]) -> pub [u8; 32] {
    blake2s(input)
}
