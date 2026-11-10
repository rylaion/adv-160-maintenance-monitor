import fitz
from PIL import Image
import io
import os
import shutil

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')
out_dir = 'assets/images/parts_catalog/adv160_2023/pages'

# Clean existing directory
if os.path.exists(out_dir):
    shutil.rmtree(out_dir)
os.makedirs(out_dir, exist_ok=True)

print(f"Re-extracting 67 pages (PDF pages 31 to 97, Printed pages 28 to 94)...")

extracted = []
for p_idx in range(30, 97):
    pdf_p = p_idx + 1
    printed_p = pdf_p - 3
    
    page = doc[p_idx]
    pix = page.get_pixmap(dpi=200)
    img = Image.open(io.BytesIO(pix.tobytes('png')))
    
    filename = f"page_{printed_p:03d}.webp"
    file_path = os.path.join(out_dir, filename)
    img.save(file_path, 'WEBP', quality=92, method=6)
    
    extracted.append({
        'filename': filename,
        'printed_page': printed_p,
        'pdf_page': pdf_p,
        'size': os.path.getsize(file_path)
    })

print(f"Extracted {len(extracted)} files cleanly without collisions!")
print(f"First file: {extracted[0]}")
print(f"Last file: {extracted[-1]}")

