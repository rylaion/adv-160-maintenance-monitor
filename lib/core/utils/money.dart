/// Money helpers. Amounts are stored as integer centavos to avoid
/// floating-point currency errors.
class Money {
  Money._();

  /// Parses a peso amount typed by the user ("1,250.50", "85", "₱ 99.9") into
  /// centavos. Returns null if it is not a valid non-negative amount with at
  /// most two decimals. Empty input is not valid; callers decide about blanks.
  static int? tryParsePesos(String? input) {
    if (input == null) return null;
    var s = input.trim().replaceAll(',', '').replaceAll('₱', '').trim();
    if (s.isEmpty) return null;
    final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(s);
    if (match == null) return null;
    final whole = int.parse(match.group(1)!);
    final frac = (match.group(2) ?? '').padRight(2, '0');
    return whole * 100 + int.parse(frac.isEmpty ? '0' : frac);
  }

  /// Formats centavos for a text field, e.g. 125050 -> "1250.50".
  static String toInput(int centavos) =>
      '${centavos ~/ 100}.${(centavos % 100).toString().padLeft(2, '0')}';
}

