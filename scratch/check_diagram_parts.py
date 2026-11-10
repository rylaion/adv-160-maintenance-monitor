import json

with open('assets/data/honda_adv160_parts_catalogue_18k0wp01.json') as f:
    data = json.load(f)

parts = data['parts']
for dcode in ['E-16', 'F-17', 'F-18', 'F-20-40', 'F-22-40', 'F-26']:
    dparts = [p for p in parts if p['diagram_number'] == dcode]
    print(f'=== Diagram {dcode}: {len(dparts)} parts ===')
    for p in dparts[:5]:
        print(f"  {p['part_number']} | Ref #{p['ref_no']} | {p['official_name']}")

