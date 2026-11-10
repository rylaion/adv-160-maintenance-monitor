import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('All 67 catalogue page images exist in AssetBundle', () async {
    for (int p = 28; p <= 94; p++) {
      final path =
          'assets/images/parts_catalog/adv160_2023/pages/page_${p.toString().padLeft(3, '0')}.webp';
      // Load bytes from rootBundle
      final data = await rootBundle.load(path);
      expect(data.lengthInBytes, greaterThan(1000),
          reason: 'Asset $path should be valid and non-empty');
    }
  });
}
