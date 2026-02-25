import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class PdfViewerScreen extends StatelessWidget {
  final String pdfPath; // asset path or network URL

  const PdfViewerScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    bool isNetwork = pdfPath.startsWith('http');

    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: isNetwork
          ? SfPdfViewer.network(
        pdfPath,
        canShowScrollHead: true,
        canShowScrollStatus: true,
      )
          : SfPdfViewer.asset(
        pdfPath,
        canShowScrollHead: true,
        canShowScrollStatus: true,
      ),
    );
  }
}