use dep::mimc::mimc_bn254;

fn main(input: [Field; 3]) -> pub Field {
    mimc_bn254(input)
}
