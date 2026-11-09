import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Minimal, standard-compliant ZIP (PKZIP 2.0) writer and reader supporting
/// Method 0 (STORED) and Method 8 (DEFLATE via `dart:io` ZLibCodec).
///
/// Used by `BackupService` to create and restore `.zip` archives bundling
/// `backup.json` and inspection photo attachments completely offline without
/// external dependencies.
class ZipEntry {
  const ZipEntry({required this.name, required this.bytes});
  final String name;
  final Uint8List bytes;
}

class ZipCodec {
  ZipCodec._();

  static const int _localHeaderSig = 0x04034b50;
  static const int _centralHeaderSig = 0x02014b50;
  static const int _eocdSig = 0x06054b50;

  /// Encodes [entries] into a standard ZIP byte array (STORED, method 0).
  static Uint8List encode(List<ZipEntry> entries) {
    final out = BytesBuilder(copy: false);
    final centralDir = BytesBuilder(copy: false);
    var offset = 0;

    for (final entry in entries) {
      final nameBytes = utf8.encode(entry.name.replaceAll('\\', '/'));
      final data = entry.bytes;
      final crc = _crc32(data);

      // Local file header (30 bytes + file name)
      final local = ByteData(30);
      local.setUint32(0, _localHeaderSig, Endian.little);
      local.setUint16(4, 20, Endian.little); // version needed
      local.setUint16(6, 0x0800, Endian.little); // UTF-8 flag
      local.setUint16(8, 0, Endian.little); // method 0 = STORED
      local.setUint16(10, 0, Endian.little); // mod time
      local.setUint16(12, 0, Endian.little); // mod date
      local.setUint32(14, crc, Endian.little);
      local.setUint32(18, data.length, Endian.little);
      local.setUint32(22, data.length, Endian.little);
      local.setUint16(26, nameBytes.length, Endian.little);
      local.setUint16(28, 0, Endian.little); // extra len

      out.add(local.buffer.asUint8List());
      out.add(nameBytes);
      out.add(data);

      // Central directory file header (46 bytes + file name)
      final central = ByteData(46);
      central.setUint32(0, _centralHeaderSig, Endian.little);
      central.setUint16(4, 20, Endian.little); // version made by
      central.setUint16(6, 20, Endian.little); // version needed
      central.setUint16(8, 0x0800, Endian.little); // UTF-8 flag
      central.setUint16(10, 0, Endian.little); // method 0 = STORED
      central.setUint16(12, 0, Endian.little); // mod time
      central.setUint16(14, 0, Endian.little); // mod date
      central.setUint32(16, crc, Endian.little);
      central.setUint32(20, data.length, Endian.little);
      central.setUint32(24, data.length, Endian.little);
      central.setUint16(28, nameBytes.length, Endian.little);
      central.setUint16(30, 0, Endian.little); // extra len
      central.setUint16(32, 0, Endian.little); // comment len
      central.setUint16(34, 0, Endian.little); // disk number
      central.setUint16(36, 0, Endian.little); // internal attr
      central.setUint32(38, 0, Endian.little); // external attr
      central.setUint32(42, offset, Endian.little);

      centralDir.add(central.buffer.asUint8List());
      centralDir.add(nameBytes);

      offset += 30 + nameBytes.length + data.length;
    }

    final cdBytes = centralDir.toBytes();
    final eocd = ByteData(22);
    eocd.setUint32(0, _eocdSig, Endian.little);
    eocd.setUint16(4, 0, Endian.little); // disk number
    eocd.setUint16(6, 0, Endian.little); // cd start disk
    eocd.setUint16(8, entries.length, Endian.little);
    eocd.setUint16(10, entries.length, Endian.little);
    eocd.setUint32(12, cdBytes.length, Endian.little);
    eocd.setUint32(16, offset, Endian.little);
    eocd.setUint16(20, 0, Endian.little); // comment len

    out.add(cdBytes);
    out.add(eocd.buffer.asUint8List());
    return out.toBytes();
  }

  /// Decodes a ZIP byte array into its entries, verifying CRC-32 checksums.
  static List<ZipEntry> decode(Uint8List archive) {
    if (archive.length < 22) {
      throw const FormatException('Invalid ZIP archive: too short.');
    }
    final bd = ByteData.sublistView(archive);

    // Find End of Central Directory (EOCD) record from the end.
    var eocdOffset = -1;
    final minSearch = archive.length - 65557 < 0 ? 0 : archive.length - 65557;
    for (var i = archive.length - 22; i >= minSearch; i--) {
      if (bd.getUint32(i, Endian.little) == _eocdSig) {
        eocdOffset = i;
        break;
      }
    }
    if (eocdOffset < 0) {
      throw const FormatException('Invalid ZIP archive: EOCD not found.');
    }

    final entryCount = bd.getUint16(eocdOffset + 10, Endian.little);
    var cdPos = bd.getUint32(eocdOffset + 16, Endian.little);
    final entries = <ZipEntry>[];

    for (var i = 0; i < entryCount; i++) {
      if (cdPos + 46 > archive.length ||
          bd.getUint32(cdPos, Endian.little) != _centralHeaderSig) {
        throw const FormatException('Invalid ZIP central directory header.');
      }
      final method = bd.getUint16(cdPos + 10, Endian.little);
      final expectedCrc = bd.getUint32(cdPos + 16, Endian.little);
      final compSize = bd.getUint32(cdPos + 20, Endian.little);
      final uncompSize = bd.getUint32(cdPos + 24, Endian.little);
      final nameLen = bd.getUint16(cdPos + 28, Endian.little);
      final extraLen = bd.getUint16(cdPos + 30, Endian.little);
      final commentLen = bd.getUint16(cdPos + 32, Endian.little);
      final localOffset = bd.getUint32(cdPos + 42, Endian.little);

      final name = utf8.decode(
          archive.sublist(cdPos + 46, cdPos + 46 + nameLen),
          allowMalformed: true);
      cdPos += 46 + nameLen + extraLen + commentLen;

      if (localOffset + 30 > archive.length ||
          bd.getUint32(localOffset, Endian.little) != _localHeaderSig) {
        throw const FormatException('Invalid ZIP local file header.');
      }
      final localNameLen = bd.getUint16(localOffset + 26, Endian.little);
      final localExtraLen = bd.getUint16(localOffset + 28, Endian.little);
      final dataStart = localOffset + 30 + localNameLen + localExtraLen;
      final dataEnd = dataStart + compSize;
      if (dataEnd > archive.length) {
        throw const FormatException('Truncated ZIP entry payload.');
      }

      final rawSlice = archive.sublist(dataStart, dataEnd);
      Uint8List decoded;
      if (method == 0) {
        decoded = Uint8List.fromList(rawSlice);
      } else if (method == 8) {
        decoded = Uint8List.fromList(ZLibCodec(raw: true).decode(rawSlice));
      } else {
        throw FormatException('Unsupported ZIP compression method: $method');
      }

      if (decoded.length != uncompSize) {
        throw FormatException('Size mismatch in ZIP entry "$name".');
      }
      final actualCrc = _crc32(decoded);
      if (actualCrc != expectedCrc) {
        throw FormatException('CRC-32 checksum mismatch in ZIP entry "$name".');
      }
      entries.add(ZipEntry(name: name, bytes: decoded));
    }

    return entries;
  }

  static final List<int> _crcTable = _buildCrcTable();

  static List<int> _buildCrcTable() {
    final table = List<int>.filled(256, 0);
    for (var n = 0; n < 256; n++) {
      var c = n;
      for (var k = 0; k < 8; k++) {
        if ((c & 1) != 0) {
          c = 0xedb88320 ^ (c >>> 1);
        } else {
          c = c >>> 1;
        }
      }
      table[n] = c;
    }
    return table;
  }

  static int _crc32(Uint8List bytes) {
    var c = 0xffffffff;
    for (final b in bytes) {
      c = _crcTable[(c ^ b) & 0xff] ^ (c >>> 8);
    }
    return (c ^ 0xffffffff) & 0xffffffff;
  }
}
