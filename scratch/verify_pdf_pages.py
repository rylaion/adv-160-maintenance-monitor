import fitz
import re

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')
print(f"Total pages: {len(doc)}")

print("\n--- ALL PAGES WITH DIAGRAM BLOCKS ---")
diagram_pages = []

for p_no in range(1, len(doc) + 1):
    page = doc[p_no - 1]
    text = page.get_text()
    lines = [l.strip() for l in text.split('\n') if l.strip()]
    
    # Check if page has block code
    blocks = []
    for l in lines:
        m = re.match(r'^([EF]-[\d\-]+)$', l)
        if m:
            blocks.append(m.group(1))
            
    if blocks:
        # Find printed page number
        # Look at the top or bottom of page
        printed_nums = [l for l in lines[:10] if l.isdigit() and 20 <= int(l) <= 100]
        # Title is usually near block code
        block_code = blocks[0]
        b_idx = lines.index(block_code)
        nearby = lines[max(0, b_idx-2):min(len(lines), b_idx+5)]
        
        # Check group
        group = "UNKNOWN"
        for l in lines[:10]:
            if "ENGINE" in l.upper():
                group = "ENGINE GROUP"
            elif "FRAME" in l.upper():
                group = "FRAME GROUP"
                
        diagram_pages.append({
            'pdf_page': p_no,
            'pdf_index': p_no - 1,
            'printed_num': printed_nums[0] if printed_nums else "??",
            'block': block_code,
            'group': group,
            'lines_top': lines[:8]
        })

print(f"Total diagram pages found: {len(diagram_pages)}")
for dp in diagram_pages:
    print(f"PDF p.{dp['pdf_page']:2d} (idx {dp['pdf_index']:2d}) | Printed p.{dp['printed_num']:2s} | Block: {dp['block']:10s} | Group: {dp['group']:12s} | Top: {dp['lines_top']}")

