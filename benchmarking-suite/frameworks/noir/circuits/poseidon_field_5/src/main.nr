use dep::poseidon::poseidon::bn254::sponge;

fn main(input: [Field; 5]) -> pub Field {
    sponge(input)
}
