import fitz
import re

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')

# Let's inspect the Dart file honda_adv160_catalogue_data.dart
with open('lib/core/database/seed/honda_adv160_catalogue_data.dart') as f:
    text = f.read()

# Parse officialHondaDiagrams
pattern = re.compile(r"OfficialDiagramData\(\s*diagramCode:\s*'([^']+)',\s*title:\s*'([^']+)',\s*assemblyName:\s*'([^']+)',\s*description:\s*'([^']+)',\s*imageAssetPath:\s*'([^']+)',\s*pdfPage:\s*(\d+),\s*printedPage:\s*(\d+),", re.DOTALL)

diagrams = pattern.findall(text)
print(f"Total parsed diagrams: {len(diagrams)}")

print("\n--- DIAGRAM TO ASSET AND ACTUAL PDF CONTENT ---")
for code, title, asm, desc, asset, pdf_p, pr_p in diagrams:
    p_idx = int(pdf_p) - 1
    # Get actual text of page at p_idx in PDF
    page = doc[p_idx]
    ptxt = page.get_text()
    plines = [l.strip() for l in ptxt.split('\n') if l.strip()]
    
    # Check block on actual page
    actual_blocks = [l for l in plines if re.match(r'^[EF]-[\d\-]+$', l)]
    actual_block = actual_blocks[0] if actual_blocks else "NONE"
    
    # Check printed page number on actual page
    actual_printed = [l for l in plines[:10] if l.isdigit() and 20 <= int(l) <= 100]
    actual_pr = actual_printed[0] if actual_printed else "??"
    
    match_status = "OK" if actual_block == code and actual_pr == str(pr_p) else "MISMATCH"
    if match_status == "MISMATCH":
        print(f"[{match_status}] Code: {code} | Expected PDF p.{pdf_p} (pr.{pr_p}) | ACTUAL PDF p.{pdf_p} has block: {actual_block} (pr.{actual_pr}) | Asset: {asset}")
    else:
        print(f"[{match_status}] Code: {code:8s} | Title: {title:30s} | PDF p.{pdf_p} | Pr.{pr_p} | Asset: {asset}")

