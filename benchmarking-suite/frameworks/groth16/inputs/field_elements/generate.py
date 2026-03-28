import json
import random

# BN-254 scalar field order
P = 21888242871839275222246405745257275088548364400416034343698204186575808495617

def generate_json_for_size(size):
    # generate random field elements
    elements = [str(random.randint(0, P - 1)) for _ in range(size)]
    data = {"in": elements}
    
    filename = f"input{size}f.json"
    with open(filename, "w") as f:
        json.dump(data, f, indent=4)
        f.write("\n")
    print(f"Generated {filename}")

if __name__ == "__main__":
    sizes = [5, 9, 17, 34]
    for s in sizes:
        generate_json_for_size(s)
