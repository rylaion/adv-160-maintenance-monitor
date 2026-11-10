import os
from PIL import Image, ImageDraw, ImageFont
import json

with open('assets/data/honda_adv160_parts_catalogue_18k0wp01.json') as f:
    data = json.load(f)

diagrams = {d['printed_start_page']: d for d in data['diagrams']}

# We have 67 pages (printed 28 to 94)
# Let's create an 8 column grid: 8 cols x 9 rows = 72 slots
cols = 8
rows = 9
thumb_w = 300
thumb_h = 240
header_h = 50

sheet_w = cols * thumb_w
sheet_h = rows * (thumb_h + header_h)

sheet = Image.new('RGB', (sheet_w, sheet_h), color=(240, 240, 240))
draw = ImageDraw.Draw(sheet)

font_size = 14
try:
    font = ImageFont.truetype("arial.ttf", font_size)
    bold_font = ImageFont.truetype("arialbd.ttf", 15)
except:
    font = ImageFont.load_default()
    bold_font = font

for idx, pr_p in enumerate(range(28, 95)):
    c = idx % cols
    r = idx // cols
    x = c * thumb_w
    y = r * (thumb_h + header_h)
    
    img_path = f"assets/images/parts_catalog/adv160_2023/pages/page_{pr_p:03d}.webp"
    pdf_p = pr_p + 3
    
    # Header box
    draw.rectangle([x, y, x + thumb_w - 2, y + header_h - 2], fill=(45, 30, 25))
    
    # Lookup diagram
    # Find which diagram block covers this page
    d_info = None
    for d in data['diagrams']:
        if d['printed_start_page'] <= pr_p < d['printed_start_page'] + d.get('page_count', 1):
            d_info = d
            break
            
    code = d_info['diagram_code'] if d_info else '?'
    title = d_info['title'] if d_info else '?'
    
    draw.text((x + 6, y + 6), f"Pr p.{pr_p} (PDF p.{pdf_p})", fill=(255, 200, 100), font=bold_font)
    draw.text((x + 6, y + 26), f"[{code}] {title[:20]}", fill=(255, 255, 255), font=font)
    
    # Thumbnail image
    if os.path.exists(img_path):
        try:
            im = Image.open(img_path)
            im.thumbnail((thumb_w - 4, thumb_h - 4))
            # paste centered in the cell area
            im_x = x + (thumb_w - im.width) // 2
            im_y = y + header_h + (thumb_h - im.height) // 2
            sheet.paste(im, (im_x, im_y))
        except Exception as e:
            draw.text((x + 10, y + header_h + 20), f"Error: {e}", fill=(200, 0, 0), font=font)
    else:
        draw.text((x + 10, y + header_h + 20), "FILE NOT FOUND", fill=(200, 0, 0), font=font)

out_path = 'assets/images/parts_catalog/adv160_2023/contact_sheet.png'
sheet.save(out_path)
print(f"Contact sheet saved to {out_path} ({sheet_w}x{sheet_h})")

