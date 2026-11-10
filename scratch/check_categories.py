import re

with open('lib/core/database/seed/honda_adv160_catalogue_data.dart') as f:
    text = f.read()

categories = set(re.findall(r"category:\s*'([^']+)'", text))
print("Categories in seed data:")
for c in sorted(categories):
    print(f" - {c}")

assembly_names = set(re.findall(r"assemblyName:\s*'([^']+)'", text))
print("\nAssembly names matching 'Brake' or 'Shock' or 'Stem':")
for a in sorted(assembly_names):
    if any(k in a.upper() for k in ['BRAKE', 'SHOCK', 'STEM', 'FORK']):
        print(f" - {a}")

