import json

mapping = json.load(open('assets/data/honda_adv160_page_mapping.json'))

for m in mapping:
    code = m['diagram_code']
    title = m['title']
    pdf_p = m['pdf_page_number']
    pr_p = m['printed_page_number']
    img = m['image_asset_path']
    pr_img = m['printed_asset_path']
    if any(k in str(title).upper() or k in str(code).upper() for k in ['BRAKE', 'STEM', 'FORK', 'WHEEL']):
        print(f"Code: {code:8s} | Title: {title:30s} | PDF: {pdf_p:2d} | Pr: {pr_p:2d} | image_asset_path: {img} | printed_asset_path: {pr_img}")

