# Honda ADV160 Parts Catalogue Maintenance Tools

These reusable maintenance tools parse and extract data from the official Honda ADV160 Parts Catalogue PDF (`assets/ADV160_18K0WP01_0.pdf`, Model: ADV160AP, Philippines).

## Tools

1. **`reextract_clean_pages.py`**
   - High-resolution (200 DPI) extractor for all 67 illustrated diagram pages (PDF pages 31 to 97, printed pages 28 to 94).
   - Generates WebP files into `assets/images/parts_catalog/adv160_2023/pages/page_0xx.webp` with zero collisions.

2. **`generate_verified_catalogue.py`**
   - Parses the official Part Number Index (PDF pages 98 to 101, printed 95 to 98) and diagram tables.
   - Outputs `assets/data/honda_adv160_parts_catalogue_18k0wp01.json`.

3. **`verify_all_pdf_diagrams.py`**
   - Audits all 54 diagram blocks and multi-page sequences directly against the PDF text and image assets.

