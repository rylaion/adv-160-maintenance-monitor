import subprocess, re, json

out = subprocess.check_output(['git', 'show', '261d117:lib/core/database/seed/honda_adv160_catalogue_data.dart'], text=True, encoding='utf-8')

# parse 261d117 parts
old_parts = {}
# Find each OfficialPartData block
pattern = re.compile(r'OfficialPartData\(\s*partNumber:\s*\'([^\']+)\'[\s\S]*?assemblyName:\s*\'([^\']+)\'[\s\S]*?diagramNumber:\s*\'([^\']+)\'', re.MULTILINE)
for m in pattern.finditer(out):
    old_parts[m.group(1)] = {
        'assembly': m.group(2),
        'diagram': m.group(3)
    }

print(f'Old parts parsed: {len(old_parts)}')

with open('assets/data/honda_adv160_parts_catalogue_18k0wp01.json') as f:
    new_data = json.load(f)

new_parts = {p['part_number']: p for p in new_data['parts']}

diffs = []
for pn, op in old_parts.items():
    np = new_parts.get(pn)
    if not np:
        diffs.append((pn, 'MISSING IN NEW', op))
    elif op['diagram'] != np['diagram_number']:
        diffs.append((pn, f"DIAGRAM MISMATCH: old {op['diagram']} vs new {np['diagram_number']}", op))

print(f'Total mismatches between old seed and new seed: {len(diffs)}')
for d in diffs[:20]:
    print(d)

