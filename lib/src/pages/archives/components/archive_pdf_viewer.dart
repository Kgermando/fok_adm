import 'package:flutter/material.dart';
import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ArchivePdfViewer extends StatefulWidget {
  const ArchivePdfViewer({Key? key, required this.archiveModel}) : super(key: key);
  final ArchiveModel archiveModel;

  @override
  State<ArchivePdfViewer> createState() => _ArchivePdfViewerState();
}

class _ArchivePdfViewerState extends State<ArchivePdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.network(
          widget.archiveModel.fichier,
          enableDocumentLinkAnnotation: false
        )
        );
  }
}
