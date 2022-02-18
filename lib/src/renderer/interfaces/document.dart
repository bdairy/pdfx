import 'dart:async';
import 'dart:typed_data' show Uint8List;

import 'package:pdfx/src/renderer/interfaces/platform.dart';
import 'page.dart';

/// PDF page image renderer
abstract class PdfDocument {
  PdfDocument({
    required this.sourceName,
    required this.id,
    required this.pagesCount,
  });

  /// Needed for toString method
  /// Contains a method for opening a document (file, data or asset)
  final String sourceName;

  /// Document unique id.
  /// Generated when opening document.
  final String id;

  /// All pages count in document.
  /// Starts from 1.
  final int pagesCount;

  /// Is the document closed
  bool isClosed = false;

  Future<void> close();

  /// Opening the specified file.
  /// For Web, [filePath] can be relative path from `index.html` or any
  /// arbitrary URL but it may be restricted by CORS.
  static Future<PdfDocument> openFile(String filePath) =>
      PdfxPlatform.instance.openFile(filePath);

  /// Opening the specified asset.
  static Future<PdfDocument> openAsset(String name) =>
      PdfxPlatform.instance.openAsset(name);

  /// Opening the PDF on memory.
  static Future<PdfDocument> openData(FutureOr<Uint8List> data) =>
      PdfxPlatform.instance.openData(data);

  /// Get page object. The first page is 1.
  Future<PdfPage> getPage(
    int pageNumber, {
    bool autoCloseAndroid = false,
  });

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  @override
  String toString() =>
      '$runtimeType{document: $sourceName, id: $id, pagesCount: $pagesCount}';
}

class PdfDocumentAlreadyClosedException implements Exception {
  @override
  String toString() => '$runtimeType: Document already closed';
}

class PlatformNotSupportedException implements Exception {
  @override
  String toString() => '$runtimeType: Actual platform not supported by '
      'it method, try use another';
}
