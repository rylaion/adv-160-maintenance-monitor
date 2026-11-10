import json

with open('assets/data/honda_adv160_parts_catalogue_18k0wp01.json') as f:
    data = json.load(f)

parts = {p['part_number']: p for p in data['parts']}
diagrams = {d['diagram_code']: d for d in data['diagrams']}

queries = [
    ('Rear Brake Master Cylinder', ['43510-K1Z-J11', '35340-K1Z-J11']),
    ('Rear Brake Pipe', ['43312-K0W-NB0', '57110-K0W-NB1']),
    ('Rear Brake Caliper', ['43150-K0W-N01', '06435-K97-N01']),
    ('Front Shock / Fork', ['51400-K0W-N01', '51410-K1Z-J11']),
    ('Steering Stem / T-Post', ['53219-K0W-N00', '50301-GN5-901']),
    ('Front Brake Caliper', ['45150-K0W-N01', '06455-KRE-G01']),
    ('Air Cleaner', ['17220-K2S-N00', '17225-K1Z-N20']),
    ('Fuel Tank', ['17510-K0W-N00', '17506-K1Z-J10']),
    ('Front Wheel', ['44650-K0W-N10', '44711-K0W-N01']),
    ('Rear Wheel', ['42650-K0W-N10', '42711-K0W-N01']),
    ('Drive Face', ['22102-K0W-NA0', '22110-K0W-NA0']),
    ('Driven Face', ['23205-K0W-NA0', '23100-K1Z-N21']),
]

for label, pns in queries:
    print(f'=== {label} ===')
    for pn in pns:
        p = parts.get(pn)
        if not p:
            print(f'  {pn}: NOT FOUND')
            continue
        dc = p['diagram_number']
        d = diagrams.get(dc)
        print(f"  {pn} | {p['official_name']} | D: {dc} #{p['ref_no']} -> Title: {d['title']}, Pr p.{d['printed_start_page']}, PDF p.{d['pdf_start_page']}, Img: {d['image_asset_path']}")

