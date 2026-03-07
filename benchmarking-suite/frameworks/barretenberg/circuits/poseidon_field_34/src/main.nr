use dep::poseidon::poseidon::bn254::sponge;

fn main(input: [Field; 34]) -> pub Field {
    sponge(input)
}
