import fitz
import json
import re

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')

with open('assets/data/honda_adv160_parts_catalogue_18k0wp01.json') as f:
    catalogue = json.load(f)

print(f"Total diagrams in json: {len(catalogue['diagrams'])}")
for d in catalogue['diagrams']:
    code = d['diagram_code']
    title = d['title']
    pdf_p = d['pdf_start_page']
    printed_p = d['printed_start_page']
    asset = d['image_asset_path']
    print(f"{code:10s} | PDF p.{pdf_p:2d} | Printed p.{printed_p:2d} | Title: {title:30s} | Asset: {asset}")

