import json

with open('assets/data/honda_adv160_parts_catalogue_18k0wp01.json') as f:
    cat = json.load(f)

diagrams = cat['diagrams']
parts = cat['parts']

out_lines = [
    "// AUTO-GENERATED FROM OFFICIAL HONDA ADV160 PARTS CATALOGUE 18K0WP01 (2022.08.20).",
    "// DO NOT EDIT MANUALLY - RUN scratch/generate_catalogue_dart.py TO REGENERATE.",
    "",
    "class OfficialDiagramData {",
    "  const OfficialDiagramData({",
    "    required this.diagramCode,",
    "    required this.title,",
    "    required this.assemblyName,",
    "    required this.description,",
    "    required this.imageAssetPath,",
    "    required this.pdfPage,",
    "    required this.printedPage,",
    "    this.pageCount = 1,",
    "    required this.catalogueRevision,",
    "  });",
    "",
    "  final String diagramCode;",
    "  final String title;",
    "  final String assemblyName;",
    "  final String description;",
    "  final String imageAssetPath;",
    "  final int pdfPage;",
    "  final int printedPage;",
    "  final int pageCount;",
    "  final String catalogueRevision;",
    "}",
    "",
    "class OfficialPartData {",
    "  const OfficialPartData({",
    "    required this.partNumber,",
    "    required this.officialName,",
    "    required this.refNo,",
    "    required this.standardQuantity,",
    "    required this.category,",
    "    required this.assemblyName,",
    "    required this.diagramNumber,",
    "    required this.page,",
    "    this.maintenanceItemName,",
    "    required this.remarks,",
    "  });",
    "",
    "  final String partNumber;",
    "  final String officialName;",
    "  final int refNo;",
    "  final int standardQuantity;",
    "  final String category;",
    "  final String assemblyName;",
    "  final String diagramNumber;",
    "  final int page;",
    "  final String? maintenanceItemName;",
    "  final String remarks;",
    "}",
    "",
    "const officialHondaDiagrams = <OfficialDiagramData>[",
]

for d in diagrams:
    title_esc = d['title'].replace("'", "\\'")
    desc_esc = d['description'].replace("'", "\\'")
    p_count = d.get('page_count', 1)
    out_lines.append(f"  OfficialDiagramData(")
    out_lines.append(f"    diagramCode: '{d['diagram_code']}',")
    out_lines.append(f"    title: '{title_esc}',")
    out_lines.append(f"    assemblyName: '{d['assembly_name']}',")
    out_lines.append(f"    description: '{desc_esc}',")
    out_lines.append(f"    imageAssetPath: '{d['image_asset_path']}',")
    out_lines.append(f"    pdfPage: {d['pdf_start_page']},")
    out_lines.append(f"    printedPage: {d['printed_start_page']},")
    out_lines.append(f"    pageCount: {p_count},")
    out_lines.append(f"    catalogueRevision: '{d['catalogue_revision']}',")
    out_lines.append(f"  ),")

out_lines.append("];")
out_lines.append("")
out_lines.append("const officialHondaParts = <OfficialPartData>[")

for p in parts:
    name_esc = p['official_name'].replace("'", "\\'")
    cat_esc = p['category'].replace("'", "\\'")
    assem_esc = p['assembly_name'].replace("'", "\\'")
    rem_esc = p['remarks'].replace("'", "\\'")
    maint_item_val = f"'{p['suggested_maintenance_item']}'" if p['suggested_maintenance_item'] else "null"
    
    out_lines.append("  OfficialPartData(")
    out_lines.append(f"    partNumber: '{p['part_number']}',")
    out_lines.append(f"    officialName: '{name_esc}',")
    out_lines.append(f"    refNo: {p['ref_no']},")
    out_lines.append(f"    standardQuantity: {p['standard_quantity']},")
    out_lines.append(f"    category: '{cat_esc}',")
    out_lines.append(f"    assemblyName: '{assem_esc}',")
    out_lines.append(f"    diagramNumber: '{p['diagram_number']}',")
    out_lines.append(f"    page: {p['page']},")
    out_lines.append(f"    maintenanceItemName: {maint_item_val},")
    out_lines.append(f"    remarks: '{rem_esc}',")
    out_lines.append("  ),")

out_lines.append("];")
out_lines.append("")

out_content = "\n".join(out_lines)
with open('lib/core/database/seed/honda_adv160_catalogue_data.dart', 'w', encoding='utf-8') as f:
    f.write(out_content)

print(f"Written lib/core/database/seed/honda_adv160_catalogue_data.dart ({len(out_lines)} lines)")

