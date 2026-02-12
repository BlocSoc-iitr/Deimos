use dep::poseidon::poseidon::bn254::sponge;

fn main(input: [Field; 1]) -> pub Field {
    sponge(input)
}
