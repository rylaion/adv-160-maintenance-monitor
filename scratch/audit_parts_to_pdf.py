import fitz
import json
import re

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')

with open('assets/data/honda_adv160_parts_catalogue_18k0wp01.json') as f:
    cat = json.load(f)

parts = cat['parts']
print(f"Auditing {len(parts)} parts...")

# For each part, verify if its part_number exists on the PDF page of its diagram_number
diagram_pages = {}
for p_idx in range(30, 97):
    page = doc[p_idx]
    txt = page.get_text()
    lines = [l.strip() for l in txt.split('\n') if l.strip()]
    blocks = [l for l in lines if re.match(r'^[EF]-[\d\-]+$', l)]
    if blocks:
        b = blocks[0]
        if b not in diagram_pages:
            diagram_pages[b] = []
        diagram_pages[b].append(p_idx)

print(f"Unique diagram blocks in PDF: {len(diagram_pages)}")

mismatches = []
verified_count = 0

for p in parts:
    p_no = p['part_number']
    d_no = p['diagram_number']
    ref = p['ref_no']
    
    if d_no not in diagram_pages:
        mismatches.append(f"Diagram {d_no} not found for part {p_no}")
        continue
        
    pages = diagram_pages[d_no]
    # Check if part_number appears in text of any of these pages
    found_on_page = False
    for p_idx in pages:
        txt = doc[p_idx].get_text()
        if p_no in txt:
            found_on_page = True
            break
            
    if found_on_page:
        verified_count += 1
    else:
        mismatches.append(f"Part {p_no} (Ref #{ref}) not found on pages for {d_no} (pages: {[p+1 for p in pages]})")

print(f"Verified parts found on actual PDF pages: {verified_count}/{len(parts)}")
print(f"Mismatches: {len(mismatches)}")
if mismatches:
    for m in mismatches[:20]:
        print(" -", m)

