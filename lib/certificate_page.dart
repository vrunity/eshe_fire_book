import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

class CertificatePage extends StatefulWidget {
  final String userName;
  final Map<String, dynamic> topicProgress;

  CertificatePage({required this.userName, required this.topicProgress});

  @override
  _CertificatePageState createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestStoragePermission(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Certificate of Completion")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "🎓 Certificate of Completion 🎓",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 20),
            Text("This certifies that", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
              widget.userName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 10),
            Text(
              "has successfully completed the Fire Safety Training with the following scores:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: widget.topicProgress.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key.replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1 $2')),
                    trailing: Text("Score: ${entry.value["score"]} / 5", style: TextStyle(fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pdfPath = await _generateCertificate();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Certificate saved at: $pdfPath")),
                );
              },
              child: Text("Download Certificate"),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ **Generate PDF with Background Image and Logo**
  Future<String> _generateCertificate() async {
    final pdf = pw.Document();

    // Load images from assets
    final ByteData bgImageData = await rootBundle.load("assets/certificate_bg.jpg");
    final Uint8List bgImageBytes = bgImageData.buffer.asUint8List();

    final ByteData logoImageData = await rootBundle.load("assets/logo.png");
    final Uint8List logoImageBytes = logoImageData.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Background Image
              pw.Positioned.fill(
                child: pw.Image(pw.MemoryImage(bgImageBytes), fit: pw.BoxFit.cover),
              ),

              // Certificate Content
              pw.Center(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    // Logo at the Bottom
                    pw.Image(pw.MemoryImage(logoImageBytes), width: 100, height: 100),
                    pw.SizedBox(height: 20),
                    pw.Text("Certificate of Completion",
                        style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),

                    pw.SizedBox(height: 20),
                    pw.Text("This is to certify that", style: pw.TextStyle(fontSize: 18)),

                    pw.SizedBox(height: 10),
                    pw.Text(widget.userName, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.red)),

                    pw.SizedBox(height: 10),
                    pw.Text("has successfully completed the Fire Safety Training.", style: pw.TextStyle(fontSize: 16)),

                    pw.SizedBox(height: 20),
                    // pw.Text("Quiz Scores:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    // pw.SizedBox(height: 10),

                    // // Display Scores
                    // ...widget.topicProgress.entries.map(
                    //       (entry) => pw.Text("${entry.key}: ${entry.value["score"]} / 5", style: pw.TextStyle(fontSize: 14)),
                    // ),
                    //
                    // pw.SizedBox(height: 30),
                    pw.Text("Date: ${DateTime.now().toLocal().toString().split(' ')[0]}"),
                    pw.SizedBox(height: 30),

                    // Signature Line
                    pw.Text("SEED FOR SAFETY", style: pw.TextStyle(fontSize: 16)),

                    pw.SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // ✅ Save Certificate to Downloads/e-SHE Certificates
    Directory? directory;
    if (Platform.isAndroid) {
      if (await requestStoragePermission(context)) {
        directory = Directory("/storage/emulated/0/Download/e-SHE Certificates");
      } else {
        throw Exception("ERROR: Storage permission denied.");
      }
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw Exception("Unsupported platform.");
    }

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final filePath = "${directory.path}/certificate_${widget.userName}.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print("✅ Certificate saved successfully at: $filePath");
    return filePath;
  }

  /// ✅ **Request Storage Permission (for Android)**
  Future<bool> requestStoragePermission(BuildContext context) async {
    print("Requesting storage permission...");

    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();

      if (statuses[Permission.storage]!.isGranted ||
          statuses[Permission.manageExternalStorage]!.isGranted) {
        print("✅ Storage permission granted.");
        return true;
      } else if (statuses[Permission.storage]!.isPermanentlyDenied ||
          statuses[Permission.manageExternalStorage]!.isPermanentlyDenied) {
        print("❌ Storage permission permanently denied.");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Storage permission is required. Please enable it in app settings.'),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () {
                  openAppSettings();
                },
              ),
            ),
          );
        }
      } else {
        print("❌ Storage permission denied.");
      }
    }
    return false;
  }
}
