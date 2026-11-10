import fitz
import os

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')
pages_dir = 'assets/images/parts_catalog/adv160_2023/pages'

files = sorted([f for f in os.listdir(pages_dir) if f.endswith('.webp')])
print(f"Total webp files in {pages_dir}: {len(files)}")
print(files)

