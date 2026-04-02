use dep::poseidon::poseidon2::Poseidon2::hash;

fn main(input: [Field; 3]) -> pub Field {
    hash(input, 3)
}