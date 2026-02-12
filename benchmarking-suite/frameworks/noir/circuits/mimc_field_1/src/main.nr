use dep::mimc::mimc_bn254;

fn main(input: [Field; 1]) -> pub Field {
    mimc_bn254(input)
}
