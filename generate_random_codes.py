import json
import itertools
import random
import string


# Generate all possible 4-letter combinations
def generate_all_codes():
    letters = string.ascii_lowercase
    return ["".join(code) for code in itertools.product(letters, repeat=5)]


# Read the schema file
with open("nextflow_schema.json", "r") as f:
    schema = json.load(f)

# Generate and shuffle codes
all_codes = generate_all_codes()
random.shuffle(all_codes)

# Take the first N codes (where N is the length of the current enum)
n_codes = 1000
selected_codes = all_codes[:n_codes]

# Update the enum in the schema
schema["$defs"]["inputs"]["properties"]["choice"]["enum"] = selected_codes

# Write back to file
with open("nextflow_schema.json", "w") as f:
    json.dump(schema, f, indent=4)
