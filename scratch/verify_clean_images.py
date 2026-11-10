import fitz
import os

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')
pages_dir = 'assets/images/parts_catalog/adv160_2023/pages'

files = sorted(os.listdir(pages_dir))
print(f"Total files on disk: {len(files)}")
assert len(files) == 67

test_pages = [
    (56, 59, 'F-6', 'REAR BRAKE MASTER CYLINDER'),
    (57, 60, 'F-7-10', 'REAR BRAKE PIPE'),
    (59, 62, 'F-10', 'STEERING STEM'),
    (71, 74, 'F-17', 'FRONT FORK'),
    (72, 75, 'F-18', 'FRONT BRAKE CALIPER'),
    (73, 76, 'F-20-40', 'FRONT WHEEL'),
    (74, 77, 'F-21', 'REAR BRAKE CALIPER'),
    (75, 78, 'F-22-40', 'REAR WHEEL/SWINGARM'),
]

for pr_p, pdf_p, exp_code, exp_title in test_pages:
    fn = f"page_{pr_p:03d}.webp"
    full_path = os.path.join(pages_dir, fn)
    assert os.path.exists(full_path), f"Missing {fn}"
    
    # check text on PDF page
    txt = doc[pdf_p - 1].get_text()
    assert exp_code in txt, f"Expected {exp_code} in PDF p.{pdf_p}"
    print(f"VERIFIED: {fn} -> Printed p.{pr_p} (PDF p.{pdf_p}) -> {exp_code}: {exp_title}")

print("\nAll critical test pages verified!")

