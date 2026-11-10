import fitz
import json
import re

doc = fitz.open('assets/ADV160_18K0WP01_0.pdf')

# 1. Official Part Number Index (PDF pages 98 to 101, printed 95 to 98)
part_number_index = {}
for p_idx in range(97, 101):
    page = doc[p_idx]
    text = page.get_text()
    for line in text.split('\n'):
        line = line.strip()
        m = re.match(r'^(\d{5}-[A-Z0-9]{3}-[A-Z0-9]{3,4})\s+([A-Z0-9\.\-]+)\s+(\d+)\s+([EF]-[\d\-]+)\s+(\d+)$', line)
        if m:
            p_no = m.group(1)
            f_code = m.group(2)
            pr_page = int(m.group(3))
            d_code = m.group(4)
            ref_no = int(m.group(5))
            part_number_index[p_no] = {
                'part_number': p_no,
                'part_code': f_code,
                'printed_page': pr_page,
                'diagram_code': d_code,
                'ref_no': ref_no
            }

print(f"Total verified part numbers in Index: {len(part_number_index)}")

# 2. Verified diagram blocks metadata
verified_blocks = {
    'E-2': {'title': 'CYLINDER HEAD COVER', 'group': 'ENGINE GROUP', 'start_pr': 28, 'start_pdf': 31, 'pages': 1},
    'E-3': {'title': 'CYLINDER HEAD', 'group': 'ENGINE GROUP', 'start_pr': 29, 'start_pdf': 32, 'pages': 2},
    'E-4': {'title': 'CAMSHAFT/VALVE', 'group': 'ENGINE GROUP', 'start_pr': 31, 'start_pdf': 34, 'pages': 2},
    'E-5': {'title': 'CAM CHAIN/TENSIONER', 'group': 'ENGINE GROUP', 'start_pr': 33, 'start_pdf': 36, 'pages': 1},
    'E-6': {'title': 'CYLINDER', 'group': 'ENGINE GROUP', 'start_pr': 34, 'start_pdf': 37, 'pages': 1},
    'E-9': {'title': 'WATER PUMP', 'group': 'ENGINE GROUP', 'start_pr': 35, 'start_pdf': 38, 'pages': 1},
    'E-10': {'title': 'A.C.G. STARTER', 'group': 'ENGINE GROUP', 'start_pr': 36, 'start_pdf': 39, 'pages': 1},
    'E-11': {'title': 'OIL PUMP', 'group': 'ENGINE GROUP', 'start_pr': 37, 'start_pdf': 40, 'pages': 1},
    'E-13': {'title': 'LEFT SIDE COVER', 'group': 'ENGINE GROUP', 'start_pr': 38, 'start_pdf': 41, 'pages': 1},
    'E-14': {'title': 'RADIATOR', 'group': 'ENGINE GROUP', 'start_pr': 39, 'start_pdf': 42, 'pages': 1},
    'E-16': {'title': 'DRIVE FACE', 'group': 'ENGINE GROUP', 'start_pr': 40, 'start_pdf': 43, 'pages': 1},
    'E-17': {'title': 'DRIVEN FACE', 'group': 'ENGINE GROUP', 'start_pr': 41, 'start_pdf': 44, 'pages': 2},
    'E-17-10': {'title': 'TRANSMISSION', 'group': 'ENGINE GROUP', 'start_pr': 43, 'start_pdf': 46, 'pages': 1},
    'E-19-10': {'title': 'RIGHT CRANKCASE', 'group': 'ENGINE GROUP', 'start_pr': 44, 'start_pdf': 47, 'pages': 2},
    'E-19-20': {'title': 'LEFT CRANKCASE', 'group': 'ENGINE GROUP', 'start_pr': 46, 'start_pdf': 49, 'pages': 3},
    'E-20': {'title': 'CRANKSHAFT/PISTON', 'group': 'ENGINE GROUP', 'start_pr': 49, 'start_pdf': 52, 'pages': 1},
    'E-22': {'title': 'THROTTLE BODY/FUEL INJECTOR', 'group': 'ENGINE GROUP', 'start_pr': 50, 'start_pdf': 53, 'pages': 1},
    
    'F-1': {'title': 'HEADLIGHT', 'group': 'FRAME GROUP', 'start_pr': 51, 'start_pdf': 54, 'pages': 1},
    'F-2': {'title': 'METER', 'group': 'FRAME GROUP', 'start_pr': 52, 'start_pdf': 55, 'pages': 1},
    'F-3': {'title': 'MIRROR', 'group': 'FRAME GROUP', 'start_pr': 53, 'start_pdf': 56, 'pages': 1},
    'F-4': {'title': 'HANDLE SWITCH/CABLE', 'group': 'FRAME GROUP', 'start_pr': 54, 'start_pdf': 57, 'pages': 1},
    'F-5-20': {'title': 'FRONT BRAKE MASTER CYLINDER', 'group': 'FRAME GROUP', 'start_pr': 55, 'start_pdf': 58, 'pages': 1},
    'F-6': {'title': 'REAR BRAKE MASTER CYLINDER', 'group': 'FRAME GROUP', 'start_pr': 56, 'start_pdf': 59, 'pages': 1},
    'F-7-10': {'title': 'REAR BRAKE PIPE', 'group': 'FRAME GROUP', 'start_pr': 57, 'start_pdf': 60, 'pages': 1},
    'F-9': {'title': 'HANDLE PIPE/HANDLE COVER', 'group': 'FRAME GROUP', 'start_pr': 58, 'start_pdf': 61, 'pages': 1},
    'F-10': {'title': 'STEERING STEM', 'group': 'FRAME GROUP', 'start_pr': 59, 'start_pdf': 62, 'pages': 1},
    'F-11': {'title': 'FRONT FENDER', 'group': 'FRAME GROUP', 'start_pr': 60, 'start_pdf': 63, 'pages': 1},
    'F-12': {'title': 'FRONT COVER', 'group': 'FRAME GROUP', 'start_pr': 61, 'start_pdf': 64, 'pages': 2},
    'F-13': {'title': 'INNER COVER', 'group': 'FRAME GROUP', 'start_pr': 63, 'start_pdf': 66, 'pages': 2},
    'F-14': {'title': 'FLOOR STEP', 'group': 'FRAME GROUP', 'start_pr': 65, 'start_pdf': 68, 'pages': 2},
    'F-14-10': {'title': 'PILLION STEP', 'group': 'FRAME GROUP', 'start_pr': 67, 'start_pdf': 70, 'pages': 1},
    'F-15': {'title': 'BODY COVER', 'group': 'FRAME GROUP', 'start_pr': 68, 'start_pdf': 71, 'pages': 2},
    'F-16': {'title': 'LUGGAGE BOX', 'group': 'FRAME GROUP', 'start_pr': 70, 'start_pdf': 73, 'pages': 1},
    'F-17': {'title': 'FRONT FORK', 'group': 'FRAME GROUP', 'start_pr': 71, 'start_pdf': 74, 'pages': 1},
    'F-18': {'title': 'FRONT BRAKE CALIPER', 'group': 'FRAME GROUP', 'start_pr': 72, 'start_pdf': 75, 'pages': 1},
    'F-20-40': {'title': 'FRONT WHEEL', 'group': 'FRAME GROUP', 'start_pr': 73, 'start_pdf': 76, 'pages': 1},
    'F-21': {'title': 'REAR BRAKE CALIPER', 'group': 'FRAME GROUP', 'start_pr': 74, 'start_pdf': 77, 'pages': 1},
    'F-22-40': {'title': 'REAR WHEEL/SWINGARM', 'group': 'FRAME GROUP', 'start_pr': 75, 'start_pdf': 78, 'pages': 2},
    'F-24': {'title': 'SEAT', 'group': 'FRAME GROUP', 'start_pr': 77, 'start_pdf': 80, 'pages': 2},
    'F-26': {'title': 'FUEL TANK', 'group': 'FRAME GROUP', 'start_pr': 79, 'start_pdf': 82, 'pages': 1},
    'F-28': {'title': 'AIR CLEANER', 'group': 'FRAME GROUP', 'start_pr': 80, 'start_pdf': 83, 'pages': 1},
    'F-30': {'title': 'EXHAUST MUFFLER', 'group': 'FRAME GROUP', 'start_pr': 81, 'start_pdf': 84, 'pages': 1},
    'F-35': {'title': 'STAND', 'group': 'FRAME GROUP', 'start_pr': 82, 'start_pdf': 85, 'pages': 1},
    'F-36': {'title': 'REAR CUSHION', 'group': 'FRAME GROUP', 'start_pr': 83, 'start_pdf': 86, 'pages': 1},
    'F-37': {'title': 'WINKER', 'group': 'FRAME GROUP', 'start_pr': 84, 'start_pdf': 87, 'pages': 1},
    'F-38': {'title': 'TAILLIGHT', 'group': 'FRAME GROUP', 'start_pr': 85, 'start_pdf': 88, 'pages': 1},
    'F-39': {'title': 'REAR FENDER', 'group': 'FRAME GROUP', 'start_pr': 86, 'start_pdf': 89, 'pages': 1},
    'F-40': {'title': 'BATTERY', 'group': 'FRAME GROUP', 'start_pr': 87, 'start_pdf': 90, 'pages': 1},
    'F-41': {'title': 'WIRE HARNESS/FOB KEY', 'group': 'FRAME GROUP', 'start_pr': 88, 'start_pdf': 91, 'pages': 2},
    'F-42': {'title': 'FRAME BODY', 'group': 'FRAME GROUP', 'start_pr': 90, 'start_pdf': 93, 'pages': 1},
    'F-43': {'title': 'RESERVE TANK', 'group': 'FRAME GROUP', 'start_pr': 91, 'start_pdf': 94, 'pages': 1},
    'F-46': {'title': 'TOOLS', 'group': 'FRAME GROUP', 'start_pr': 92, 'start_pdf': 95, 'pages': 1},
    'F-47': {'title': 'CAUTION LABEL', 'group': 'FRAME GROUP', 'start_pr': 93, 'start_pdf': 96, 'pages': 1},
    'F-48': {'title': 'MARK/EMBLEM', 'group': 'FRAME GROUP', 'start_pr': 94, 'start_pdf': 97, 'pages': 1},
}

diagrams_output = []
for code, b in verified_blocks.items():
    filename = f"page_{b['start_pr']:03d}.webp"
    diagrams_output.append({
        'diagram_code': code,
        'title': b['title'],
        'assembly_name': b['group'],
        'description': f"Official Honda Parts Catalogue 18K0WP01 (ADV160AP, PH) | PDF p. {b['start_pdf']} | Printed p. {b['start_pr']}",
        'image_asset_path': f"assets/images/parts_catalog/adv160_2023/pages/{filename}",
        'pdf_start_page': b['start_pdf'],
        'printed_start_page': b['start_pr'],
        'page_count': b['pages'],
        'catalogue_revision': '18K0WP01 (2022.08.20)'
    })

# 3. Parse individual parts from pages 31 to 97 (p_idx 30 to 96)
catalogue_parts = []
current_block = None

for p_idx in range(30, 97):
    pdf_p = p_idx + 1
    page = doc[p_idx]
    text = page.get_text()
    lines = [l.strip() for l in text.split('\n') if l.strip()]
    
    # Detect block
    for l in lines:
        if re.match(r'^[EF]-[\d\-]+$', l) and l in verified_blocks:
            current_block = l
            break
            
    b_info = verified_blocks[current_block]
    
    i = 0
    last_desc = ''
    last_ref = 1
    while i < len(lines):
        line = lines[i]
        m1 = re.match(r'^\(?(\d+)\)?\s+(\d{5}-[A-Z0-9]{3}-[A-Z0-9]{3,4})$', line)
        m2 = re.match(r'^(\d{5}-[A-Z0-9]{3}-[A-Z0-9]{3,4})$', line)
        
        if m1 or m2:
            if m1:
                current_ref = int(m1.group(1))
                part_no = m1.group(2)
            else:
                part_no = m2.group(1)
                current_ref = last_ref
                
            desc_lines = []
            qty = 1
            i += 1
            while i < len(lines):
                next_l = lines[i]
                if re.match(r'^\(?(\d+)\)?\s+(\d{5}-[A-Z0-9]{3}-[A-Z0-9]{3,4})$', next_l) or re.match(r'^(\d{5}-[A-Z0-9]{3}-[A-Z0-9]{3,4})$', next_l):
                    break
                if next_l in ['Ref.', 'No.', 'Part No.', 'Description', 'Reqd. QTY', 'Serial No.', 'Parts catalogue code', 'ADV', '160A', 'P']:
                    i += 1
                    continue
                if re.match(r'^\d+$', next_l) and int(next_l) in range(1, 50):
                    qty = int(next_l)
                    i += 1
                    break
                else:
                    cleaned = re.sub(r'[∙•\.]+', '', next_l).strip()
                    if cleaned:
                        desc_lines.append(cleaned)
                    i += 1
                    
            official_desc = ' '.join(desc_lines).strip()
            if not official_desc and last_desc:
                official_desc = last_desc
                current_ref = last_ref
            else:
                last_desc = official_desc
                last_ref = current_ref
            
            # Map Category
            cat = 'Frame & Chassis'
            if b_info['group'] == 'ENGINE GROUP':
                if current_block in ['E-16', 'E-17', 'E-17-10']:
                    cat = 'CVT / Transmission'
                elif current_block in ['E-14']:
                    cat = 'Cooling System'
                elif current_block in ['E-22']:
                    cat = 'Fuel System'
                else:
                    cat = 'Engine'
            else:
                if current_block in ['F-5-20', 'F-6', 'F-7-10', 'F-18', 'F-21']:
                    cat = 'Braking System'
                elif current_block in ['F-20-40', 'F-22-40']:
                    cat = 'Tires / Wheels'
                elif current_block in ['F-1', 'F-2', 'F-4', 'F-37', 'F-38', 'F-40', 'F-41']:
                    cat = 'Electrical System'
                elif current_block in ['F-26', 'F-28']:
                    cat = 'Fuel System'
                elif current_block in ['F-43']:
                    cat = 'Cooling System'
                elif current_block in ['F-30']:
                    cat = 'Exhaust System'
                else:
                    cat = 'Frame & Chassis'
                    
            # Maintenance item
            maint_item = None
            if part_no in ['23100-K1Z-N21', '23100-K0W-N01']:
                maint_item = 'Drive Belt'
            elif part_no in ['31916-K0W-N01', '31917-K0W-N01']:
                maint_item = 'Spark Plug'
            elif part_no in ['17220-K2S-N00', '17210-K0W-N00']:
                maint_item = 'Air Cleaner'
            elif part_no == '15421-KPL-900':
                maint_item = 'Engine Oil Strainer Screen'
            elif part_no in ['06455-K84-902', '06455-KRE-G02', '06435-K97-N01']:
                maint_item = 'Brake Pads Wear'
            elif part_no in ['45351-K0W-N01', '43251-K0W-N01']:
                maint_item = 'Brake System'
                
            catalogue_parts.append({
                'part_number': part_no,
                'official_name': official_desc,
                'ref_no': current_ref,
                'standard_quantity': qty,
                'category': cat,
                'assembly_name': b_info['title'],
                'diagram_number': current_block,
                'page': pdf_p,
                'suggested_maintenance_item': maint_item,
                'remarks': f"Genuine Honda OEM Part ({part_no}) for ADV160AP. Diagram {current_block} Ref #{current_ref}."
            })
        else:
            i += 1

print(f"Total parsed parts: {len(catalogue_parts)}")

# Save to JSON
with open('assets/data/honda_adv160_parts_catalogue_18k0wp01.json', 'w', encoding='utf-8') as f:
    json.dump({
        'catalogue_info': {
            'model': 'Honda ADV 160 (ADV160AP)',
            'market': 'Philippines (2PH)',
            'catalogue_code': '18K0WP01',
            'issue_date': '2022-08-20',
            'total_diagrams': len(diagrams_output),
            'total_parts': len(catalogue_parts)
        },
        'diagrams': diagrams_output,
        'parts': catalogue_parts
    }, f, indent=2)

print("Saved assets/data/honda_adv160_parts_catalogue_18k0wp01.json successfully!")
