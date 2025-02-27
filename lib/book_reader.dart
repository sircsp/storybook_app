import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';



class FlipBookPage extends StatefulWidget {
  final String title; // Book title
  final String pdfPath; // PDF path

  const FlipBookPage({super.key, required this.title, required this.pdfPath});

  @override
  State<FlipBookPage> createState() => _FlipBookPageState();
}

class _FlipBookPageState extends State<FlipBookPage> {
  late PdfViewerController _pdfViewerController;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    print("Loading PDF: ${widget.pdfPath}"); // Debugging

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isError
          ? const Center(child: Text("⚠️ Error loading PDF! Check assets path."))
          : SfPdfViewer.asset(
              widget.pdfPath,
              pageLayoutMode: PdfPageLayoutMode.single,
              controller: _pdfViewerController,
              onDocumentLoadFailed: (details) {
                print("ERROR: ${details.description}");
                setState(() {
                  _isError = true;
                });
              },
            ),
    );
  }
}