import 'package:e_she_book/welcome.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'classes.dart'; // Import your next page (e.g., ClassPage)
import 'package:shared_preferences/shared_preferences.dart';

class BookReadingPage extends StatefulWidget {
  const BookReadingPage({Key? key}) : super(key: key);

  @override
  _BookReadingPageState createState() => _BookReadingPageState();
}

class _BookReadingPageState extends State<BookReadingPage> {
  final PdfViewerController _pdfController = PdfViewerController();
  bool _isLastPage = false;
  bool _markComplete = false;
  int _totalPages = 0; // Store the total page count

  @override
  void initState() {
    super.initState();
    _checkBookCompleted();
  }

  // Check if user already marked the book as completed
  Future<void> _checkBookCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isCompleted = prefs.getBool("book_completed") ?? false;
    if (isCompleted) {
      // If the book has already been completed, immediately navigate to the ClassPage
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClassPage()),
        );
      });
    }
  }

  // Save the completed status so next time this page is skipped
  Future<void> _saveBookCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("book_completed", true);
  }

  // Navigates to the next page (ClassPage) with a page-turn effect.
  void _navigateToNextPage() async {
    // Save completion flag before navigation.
    await _saveBookCompleted();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => ClassPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              // Rotate the page around the Y axis from 90° to 0°.
              double angle = (1 - animation.value) * (3.1416 / 2);
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Add perspective
                  ..rotateY(angle),
                alignment: Alignment.centerRight,
                child: child,
              );
            },
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF4500), Color(0xFF5B0000)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        centerTitle: true,
        title: Text('Book Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Welcome()),
                  (Route<dynamic> route) => false,
            ),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.asset(
            'assets/firesafety.pdf', // Update with your PDF asset path
            controller: _pdfController,
            scrollDirection: PdfScrollDirection.horizontal,
            pageLayoutMode: PdfPageLayoutMode.single,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                _totalPages = details.document.pages.count;
              });
            },
            onPageChanged: (PdfPageChangedDetails details) {
              setState(() {
                if (details.newPageNumber == _totalPages) {
                  _isLastPage = true;
                } else {
                  _isLastPage = false;
                  _markComplete = false;
                }
              });
            },
          ),
          // Left arrow button for previous page
          Positioned(
            bottom: 80,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              iconSize: 40,
              color: Colors.black87,
              onPressed: () {
                _pdfController.previousPage();
              },
            ),
          ),
          // Right arrow button for next page
          Positioned(
            bottom: 80,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              iconSize: 40,
              color: Colors.black87,
              onPressed: () {
                _pdfController.nextPage();
              },
            ),
          ),
          // Display the "Mark as Completed" checkbox only when on the last page.
          if (_isLastPage)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white.withOpacity(0.8),
                child: CheckboxListTile(
                  title: Text("Mark as Completed"),
                  value: _markComplete,
                  onChanged: (bool? value) {
                    setState(() {
                      _markComplete = value ?? false;
                      if (_markComplete) {
                        _navigateToNextPage();
                      }
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
