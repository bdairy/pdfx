import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:performance/performance.dart';

class PinchPage extends StatefulWidget {
  const PinchPage({Key? key}) : super(key: key);

  @override
  _PinchPageState createState() => _PinchPageState();
}

class _PinchPageState extends State<PinchPage> {
  static const int _initialPage = 2;
  bool _isSampleDoc = true;
  late PdfController _pdfControllerPinch;

  @override
  void initState() {
    _pdfControllerPinch = PdfController(
      document: PdfDocument.openAsset('assets/hello.pdf'),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfControllerPinch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PhotoViewGalleryPageOptions _pageBuilder(
      BuildContext context,
      Future<PdfPageImage> pageImage,
      int index,
      PdfDocument document,
    ) =>
        PhotoViewGalleryPageOptions(
          imageProvider: PdfPageImageProvider(
            pageImage,
            index,
            document.id,
          ),
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.contained * 3,
          initialScale: PhotoViewComputedScale.contained * 1.0,
          heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
        );

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Pdfx example'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              _pdfControllerPinch.previousPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          PdfPageNumber(
            controller: _pdfControllerPinch,
            builder: (_, loadingState, page, pagesCount) => Container(
              alignment: Alignment.center,
              child: Text(
                '$page/${pagesCount ?? 0}',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              _pdfControllerPinch.nextPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_isSampleDoc) {
                _pdfControllerPinch.loadDocument(
                    PdfDocument.openAsset('assets/flutter_tutorial.pdf'));
              } else {
                _pdfControllerPinch
                    .loadDocument(PdfDocument.openAsset('assets/hello.pdf'));
              }
              _isSampleDoc = !_isSampleDoc;
            },
          )
        ],
      ),
      // body:  PdfViewPinch(
      //     builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
      //       options: const DefaultBuilderOptions(),
      //       documentLoaderBuilder: (_) =>
      //           const Center(child: CircularProgressIndicator()),
      //       pageLoaderBuilder: (_) =>
      //           const Center(child: CircularProgressIndicator()),
      //       errorBuilder: (_, error) => Center(child: Text(error.toString())),
      //     ),
      //     controller: _pdfControllerPinch,
      //   ),

      body: PdfView(
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        controller: _pdfControllerPinch,
        renderer: (page) {
          // model.setPageSize(
          //     page.height.toDouble(),
          //     page.width.toDouble(),
          //     MediaQuery.of(context).size,
          //     Scaffold.of(context).appBarMaxHeight!.toDouble());

          return page.render(
            backgroundColor: '#FFFFFF',
            width: page.width * 2,
            height: page.height * 2,
          );
        },
        onDocumentLoaded: (document) {
          //  model.setLoaded(document);
        },
        onPageChanged: (page) {
          //  model.setPageIndex(page);
        },
        builders: PdfViewBuilders<DefaultBuilderOptions>(
          // All from `PdfViewPinch` and:
          pageBuilder: _pageBuilder,
          options: const DefaultBuilderOptions(
            loaderSwitchDuration: const Duration(seconds: 1),
          ),
        ),
      ),
    );
  }
}
