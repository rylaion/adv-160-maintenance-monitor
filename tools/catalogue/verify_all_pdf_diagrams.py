import fitz, re, os

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')

# Let's inspect pages from physical PDF page 31 to 97
pdf_pages = []
for p_idx in range(30, 97):
    p_no = p_idx + 1
    page = doc[p_idx]
    text = page.get_text()
    lines = [l.strip() for l in text.split('\n') if l.strip()]
    d_codes = [l for l in lines if re.match(r'^[EF]-[\d\-]+$', l)]
    code = d_codes[0] if d_codes else None
    
    # Printed page
    pr_candidates = [l for l in lines if re.match(r'^\d{1,3}$', l) and int(l) >= 28 and int(l) <= 94]
    pr_num = int(pr_candidates[0]) if pr_candidates else None
    
    # Title
    title = ''
    if code:
        idx = lines.index(code)
        if idx + 1 < len(lines):
            title = lines[idx + 1]
            
    pdf_pages.append({
        'pdf_page': p_no,
        'printed_page': pr_num,
        'code': code,
        'title': title
    })

# Group consecutive pages of the same diagram
diagram_blocks = []
curr = None
for p in pdf_pages:
    if curr is None or (p['code'] is not None and p['code'] != curr['code']):
        if curr is not None:
            diagram_blocks.append(curr)
        curr = {
            'code': p['code'],
            'title': p['title'],
            'start_pdf': p['pdf_page'],
            'start_pr': p['printed_page'],
            'pages': 1,
            'pdf_pages': [p['pdf_page']],
            'pr_pages': [p['printed_page']]
        }
    else:
        curr['pages'] += 1
        curr['pdf_pages'].append(p['pdf_page'])
        curr['pr_pages'].append(p['printed_page'])

if curr is not None:
    diagram_blocks.append(curr)

print(f"Total diagram blocks found: {len(diagram_blocks)}")
for b in diagram_blocks:
    files_exist = []
    for pr in b['pr_pages']:
        fn = f"assets/images/parts_catalog/adv160_2023/pages/page_{pr:03d}.webp"
        files_exist.append(os.path.exists(fn))
    all_exist = all(files_exist)
    print(f"{b['code']:<10} | {b['title']:<30} | Pages: {b['pages']} | PDF: {b['pdf_pages']} | Pr: {b['pr_pages']} | WebP files exist: {all_exist}")

