import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

class CertificatePage extends StatefulWidget {
  final String userName;
  final String bookId;
  final Map<String, dynamic> topicProgress;



  CertificatePage({
    required this.userName,
    required this.topicProgress,
    required this.bookId,
  });

  @override
  _CertificatePageState createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  String? _courseCompletedDate;
  Uint8List? _certificateBytes;
  String? _filePath;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  bool _showForm = true;

  String _getBookName(String id) {
    switch (id) {
      case "Fire Safety":
        return "Fire Safety";
      case "First Aid":
        return "First Aid";
      case "PPE":
        return "PPE";
      case "ElectricalSafety":
        return "Electrical Safety";
      case "Road Safety":
        return "Road Safety";
      case "Kids Safety":
        return "Kids Safety";
      case "Construction Safety":
        return "Construction Safety";
      case "Environmental Safety":
        return "Environmental Safety";
      case "Forklift Safety":
        return "Forklift Safety";
      case "BBS Safety":
        return "BBS Safety";
      case "Chemical Safety":
        return "Chemical Safety";
      case "Home Safety":
        return "Home Safety";
      case "Emergency Handling":
        return "Emergency Handling";
      default:
        return "Safety";
    }
  }
  @override
  void initState() {
    super.initState();
    nameController.text = widget.userName;
    _loadCourseCompletedDate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestStoragePermission(context);
    });
  }
  Future<void> _loadCourseCompletedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fetchedDate = prefs.getString('CourseCompletedOn_${widget.bookId}');
    print("📅 Fetched course completed date for ${widget.bookId}: $fetchedDate");
    setState(() {
      _courseCompletedDate = fetchedDate;
    });
  }


  String _getServerBookUrl(String bookId) {
    switch (bookId) {
      case "Fire Safety":
        return "https://esheapp.in/e_she_book/books/fire_safety.pdf";
      case "First Aid":
        return "https://esheapp.in/e_she_book/books/first_aid.pdf";
      case "PPE":
        return "https://esheapp.in/e_she_book/books/ppe.pdf";
      case "Electrical Safety":
        return "https://esheapp.in/e_she_book/books/electrical_safety.pdf";
      case "Road Safety":
        return "https://esheapp.in/e_she_book/books/road_safety.pdf";
      case "Kids Safety":
        return "https://esheapp.in/e_she_book/books/kids_safety.pdf";
      case "Construction Safety":
        return "https://esheapp.in/e_she_book/books/construction_safety.pdf";
      case "Environmental Safety":
        return "https://esheapp.in/e_she_book/books/environmental_safety.pdf";
      case "Forklift Safety":
        return "https://esheapp.in/e_she_book/books/forklift_safety.pdf";
      case "BBS Safety":
        return "https://esheapp.in/e_she_book/books/bbs_safety.pdf";
      case "Chemical Safety":
        return "https://esheapp.in/e_she_book/books/chemical_safety.pdf";
      case "Home Safety":
        return "https://esheapp.in/e_she_book/books/home_safety.pdf";
      case "Emergency Handling":
        return "https://esheapp.in/e_she_book/books/emergency_handling.pdf";
      default:
        return "https://esheapp.in/e_she_book/books/fire_safety.pdf";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Certificate of Completion")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_showForm)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Please enter your details:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextField(controller: nameController, decoration: InputDecoration(labelText: "Your Name")),
                  TextField(controller: companyController, decoration: InputDecoration(labelText: "Company Name")),
                  TextField(controller: departmentController, decoration: InputDecoration(labelText: "Department")),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty || companyController.text.isEmpty || departmentController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields.")));
                      } else {
                        setState(() {
                          _showForm = false;
                        });
                      }
                    },
                    child: Text("Continue to Preview"),
                  ),
                ],
              )
            else
              Expanded(
                child: Column(
                  children: [
                    Text("🎓 Certificate of Completion 🎓", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                    SizedBox(height: 10),
                    Text("This certifies that", style: TextStyle(fontSize: 18)),
                    Text(nameController.text, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("of ${companyController.text} - ${departmentController.text}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: widget.topicProgress.entries.map((entry) {
                          return ListTile(
                            title: Text(entry.key),
                            trailing: Text("Score: ${entry.value["score"]} / 5", style: TextStyle(fontWeight: FontWeight.bold)),
                          );
                        }).toList(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final path = await _generateCertificate();
                        final file = File(path);
                        final bytes = await file.readAsBytes();
                        setState(() {
                          _certificateBytes = bytes;
                          _filePath = path;
                        });
                      },
                      child: Text("Preview Certificate"),
                    ),
                    if (_certificateBytes != null) ...[
                      SizedBox(height: 20),
                      Text("Preview:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        height: 400,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                        child: SfPdfViewer.memory(_certificateBytes!),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.download),
                        label: Text("Download Certificate"),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Certificate saved at: $_filePath")),
                          );
                        },
                      ),
                      _isDownloading
                          ? Column(
                        children: [
                          Text("Downloading Book...", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          LinearProgressIndicator(value: _downloadProgress),
                        ],
                      )
                          : ElevatedButton.icon(
                        icon: Icon(Icons.picture_as_pdf),
                        label: Text("Download Book"),
                        onPressed: _downloadBookFromServer,
                      ),
                    ]
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadBookFromServer() async {
    try {
      final url = _getServerBookUrl(widget.bookId);
      final request = http.Request('GET', Uri.parse(url));
      final response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          _isDownloading = true;
          _downloadProgress = 0.0;
        });

        final contentLength = response.contentLength ?? 0;
        List<int> bytes = [];
        int received = 0;

        final stream = response.stream;
        await for (final chunk in stream) {
          bytes.addAll(chunk);
          received += chunk.length;
          setState(() {
            _downloadProgress = received / contentLength;
          });
        }

        Directory? directory;
        if (Platform.isAndroid) {
          if (await requestStoragePermission(context)) {
            directory = Directory("/storage/emulated/0/Download/e-SHE Books");
          } else {
            throw Exception("Storage permission denied.");
          }
        } else if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        }

        if (!await directory!.exists()) {
          await directory.create(recursive: true);
        }

        final fileName = "${widget.bookId.replaceAll(" ", "_").toLowerCase()}.pdf";
        final file = File("${directory.path}/$fileName");
        await file.writeAsBytes(bytes);

        setState(() {
          _isDownloading = false;
          _downloadProgress = 0.0;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("📘 Book downloaded: ${file.path}")));
      } else {
        throw Exception("Failed to download book.");
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Error: ${e.toString()}")));
    }
  }




  Future<String> _generateCertificate() async {
    final pdf = pw.Document();

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
              pw.Positioned.fill(child: pw.Image(pw.MemoryImage(bgImageBytes), fit: pw.BoxFit.cover)),
              pw.Center(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Image(pw.MemoryImage(logoImageBytes), width: 100, height: 100),
                    pw.SizedBox(height: 20),
                    pw.Text("Date: ${_courseCompletedDate ?? DateTime.now().toLocal().toString().split(' ')[0]}",style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 20),
                    pw.Text("This is to certify that", style: pw.TextStyle(fontSize: 18)),
                    pw.SizedBox(height: 10),
                    pw.Text(nameController.text, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
                    pw.SizedBox(height: 10),
                    pw.Text("of ${companyController.text} - ${departmentController.text}", style: pw.TextStyle(fontSize: 16)),
                    pw.SizedBox(height: 20),
                    pw.Text("has successfully completed the ${_getBookName(widget.bookId)} Training", style: pw.TextStyle(fontSize: 16)),
                    pw.SizedBox(height: 20),
                    pw.Text("in e-Learning", style: pw.TextStyle(fontSize: 16)),
                    pw.SizedBox(height: 20),
                    pw.Text("Issued by", style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic)),
                    pw.SizedBox(height: 4),
                    pw.Text("SEED FOR SAFETY", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
                    pw.SizedBox(height: 150),
                    pw.Text("*Note:- This is a computer generated certificate", style: pw.TextStyle(fontSize: 16,color: PdfColors.white)),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    Directory? directory;
    if (Platform.isAndroid) {
      if (await requestStoragePermission(context)) {
        directory = Directory("/storage/emulated/0/Download/e-SHE Certificates");
      } else {
        throw Exception("Storage permission denied.");
      }
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw Exception("Unsupported platform.");
    }

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final filePath = "${directory.path}/certificate_${widget.bookId}_${nameController.text}.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  Future<bool> requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();

      if (statuses[Permission.storage]!.isGranted || statuses[Permission.manageExternalStorage]!.isGranted) {
        return true;
      } else if (statuses[Permission.storage]!.isPermanentlyDenied || statuses[Permission.manageExternalStorage]!.isPermanentlyDenied) {
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
      }
    }
    return false;
  }
}
