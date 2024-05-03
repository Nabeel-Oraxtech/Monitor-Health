// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late String _pdfPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPDF().then((path) {
      setState(() {
        _pdfPath = path;
        _isLoading = false;
      });
    }).catchError((error) {
      print('Error loading PDF: $error');
    });
  }

  Future<String> _loadPDF() async {
    try {
      final ByteData data = await rootBundle.load('assets/sample.pdf');
      final Uint8List bytes = data.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/sample.pdf';
      final file = File(tempPath);
      await file.writeAsBytes(bytes);
      return tempPath;
    } catch (e) {
      print('Error loading PDF: $e');
      return ''; // Return empty string or handle error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : PDFView(
                filePath: _pdfPath,
                onPageChanged: (int? page, int? total) {
                  print('page change: $page/$total');
                },
                onViewCreated: (PDFViewController controller) {},
              ),
      ),
    );
  }
}
