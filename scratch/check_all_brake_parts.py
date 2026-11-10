import re

with open('lib/core/database/seed/honda_adv160_catalogue_data.dart') as f:
    text = f.read()

part_blocks = re.findall(r"OfficialPartData\((.*?)\),", text, re.DOTALL)
print(f"Total parts: {len(part_blocks)}")

for p in part_blocks:
    if "BRAKE" in p.upper():
        num = re.search(r"partNumber:\s*'([^']+)'", p).group(1)
        name = re.search(r"officialName:\s*'([^']+)'", p).group(1)
        diag = re.search(r"diagramNumber:\s*'([^']+)'", p).group(1)
        page = re.search(r"page:\s*(\d+)", p).group(1)
        assem = re.search(r"assemblyName:\s*'([^']+)'", p).group(1)
        print(f"Part: {num:18s} | Diag: {diag:8s} | Page: {page:2s} | Assem: {assem:28s} | Name: {name}")

