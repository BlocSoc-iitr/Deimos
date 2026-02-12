use dep::poseidon::poseidon::bn254::sponge;

fn main(input: [Field; 3]) -> pub Field {
    sponge(input)
}
