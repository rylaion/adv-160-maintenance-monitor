import fitz
from PIL import Image
import io
import os

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')
pages_dir = 'assets/images/parts_catalog/adv160_2023/pages'

# Check file sizes
print("Comparing file sizes:")
for p_idx in range(55, 65):
    # render p_idx
    page = doc[p_idx]
    pix = page.get_pixmap(dpi=200)
    buf = io.BytesIO()
    img = Image.open(io.BytesIO(pix.tobytes('png')))
    img.save(buf, 'WEBP', quality=92, method=6)
    size_rendered = buf.tell()
    
    # check if page_0xx exists
    fn_idx = f"page_{p_idx:03d}.webp"
    fn_printed = f"page_{p_idx+1-3:03d}.webp"
    
    size_on_disk_idx = os.path.getsize(os.path.join(pages_dir, fn_idx)) if os.path.exists(os.path.join(pages_dir, fn_idx)) else None
    size_on_disk_printed = os.path.getsize(os.path.join(pages_dir, fn_printed)) if os.path.exists(os.path.join(pages_dir, fn_printed)) else None
    
    # Get block on page
    txt = page.get_text()
    lines = [l.strip() for l in txt.split('\n') if l.strip()]
    block = [l for l in lines if l.startswith('F-')]
    
    print(f"PDF p.{p_idx+1} (idx {p_idx}, printed {p_idx+1-3}, block {block}): rendered={size_rendered} | disk({fn_idx})={size_on_disk_idx} | disk({fn_printed})={size_on_disk_printed}")

