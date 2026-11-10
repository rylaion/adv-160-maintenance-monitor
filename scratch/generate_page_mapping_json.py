import fitz
import json
import os
import re

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')
pages_dir = 'assets/images/parts_catalog/adv160_2023/pages'

mapping = []

# Exact mapping for every page from PDF page 31 (0-indexed 30) to 97 (0-indexed 96)
for p_idx in range(30, 97):
    pdf_p = p_idx + 1
    printed_p = pdf_p - 3
    
    page = doc[p_idx]
    txt = page.get_text()
    lines = [l.strip() for l in txt.split('\n') if l.strip()]
    
    # Block code
    blocks = [l for l in lines if re.match(r'^[EF]-[\d\-]+$', l)]
    block = blocks[0] if blocks else None
    
    # Title
    title = None
    if block in lines:
        b_idx = lines.index(block)
        for offset in [1, -1, 2]:
            candidate_idx = b_idx + offset
            if 0 <= candidate_idx < len(lines):
                c = lines[candidate_idx]
                if not c.isdigit() and c not in ['Ref.', 'No.', 'ENGINEGROUP', 'FRAMEGROUP', '2', '3', 'E', '2022.08.20']:
                    title = c
                    break
                    
    group = "ENGINE GROUP" if pdf_p < 54 else "FRAME GROUP"
    filename = f"page_{printed_p:03d}.webp"
    file_path = os.path.join(pages_dir, filename)
    
    mapping.append({
        'pdf_page_number': pdf_p,
        'pdf_page_index': p_idx,
        'printed_page_number': printed_p,
        'diagram_code': block,
        'title': title,
        'assembly_group': group,
        'image_asset_path': f'assets/images/parts_catalog/adv160_2023/pages/{filename}',
        'printed_asset_path': f'assets/images/parts_catalog/adv160_2023/pages/{filename}',
        'catalogue_code': '18K0WP01',
        'catalogue_revision': '2022-08-20',
        'model': 'ADV160AP',
        'market': 'Philippines (2PH)',
        'width': 2339,
        'height': 1653,
        'size_bytes': os.path.getsize(file_path)
    })

with open('assets/data/honda_adv160_page_mapping.json', 'w', encoding='utf-8') as f:
    json.dump(mapping, f, indent=2)

print(f"Generated assets/data/honda_adv160_page_mapping.json with {len(mapping)} pages.")

