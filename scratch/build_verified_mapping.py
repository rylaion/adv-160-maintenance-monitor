import fitz
import re

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')

print("Mapping all 67 diagram pages from PDF:")
verified_pages = []

for p_idx in range(30, 97):
    p_no = p_idx + 1 # 1-based physical PDF page
    page = doc[p_idx]
    txt = page.get_text()
    lines = [l.strip() for l in txt.split('\n') if l.strip()]
    
    # 1. Block code
    blocks = [l for l in lines if re.match(r'^[EF]-[\d\-]+$', l)]
    block = blocks[0] if blocks else "UNKNOWN"
    
    # 2. Printed page number
    # The printed page number is always printed at the top-left or top-right
    pr_nums = [l for l in lines[:10] if l.isdigit() and 20 <= int(l) <= 100]
    pr_page = int(pr_nums[0]) if pr_nums else (p_no - 3)
    
    # 3. Group
    if p_no < 54:
        group = "ENGINE GROUP"
    else:
        group = "FRAME GROUP"
        
    # 4. Title
    # Let's find title
    title = "UNKNOWN"
    if block in lines:
        b_idx = lines.index(block)
        for offset in [1, -1, 2]:
            candidate_idx = b_idx + offset
            if 0 <= candidate_idx < len(lines):
                c = lines[candidate_idx]
                if not c.isdigit() and c not in ['Ref.', 'No.', 'ENGINEGROUP', 'FRAMEGROUP', '2', '3', 'E', '2022.08.20']:
                    title = c
                    break
                    
    verified_pages.append({
        'pdf_page': p_no,
        'printed_page': pr_page,
        'diagram_code': block,
        'group': group,
        'title': title
    })

print(f"Total verified pages: {len(verified_pages)}")

# Group by diagram code to identify multi-page diagrams
diagram_dict = {}
for vp in verified_pages:
    code = vp['diagram_code']
    if code not in diagram_dict:
        diagram_dict[code] = []
    diagram_dict[code].append(vp)

print(f"\nTotal unique diagram blocks: {len(diagram_dict)}")
for code, pages in diagram_dict.items():
    p_first = pages[0]
    page_str = ", ".join([f"Pr.{p['printed_page']} (PDF {p['pdf_page']})" for p in pages])
    multi = f" [MULTI-PAGE: {len(pages)} pages]" if len(pages) > 1 else ""
    print(f"{code:10s} | {p_first['group']:12s} | {p_first['title']:30s} | Pages: {page_str}{multi}")

