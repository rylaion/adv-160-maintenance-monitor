import json

with open('assets/data/honda_adv160_parts_catalogue_18k0wp01.json') as f:
    catalogue = json.load(f)

print(f"Total parts in json: {len(catalogue['parts'])}")

# Check parts with BRAKE
brake_parts = [p for p in catalogue['parts'] if 'BRAKE' in p['official_name'].upper() or 'BRAKE' in p['category'].upper()]
print(f"Total brake parts: {len(brake_parts)}")

for p in brake_parts[:20]:
    print(f"Part: {p['part_number']} | Ref #{p['ref_no']} | Diagram: {p['diagram_number']} | Assembly: {p['assembly_name']} | Name: {p['official_name']}")

