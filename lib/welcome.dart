import 'dart:convert';
import 'dart:io';
import 'package:e_she_book/title_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String statusMessage = "";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestStoragePermission(context);
    });
    checkUserSaved();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Request storage permission for Android devices
  Future<void> requestStoragePermission(BuildContext context) async {
    print("Requesting storage permission...");
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();

      if (statuses[Permission.storage]!.isGranted ||
          statuses[Permission.manageExternalStorage]!.isGranted) {
        print("Storage permission granted.");
      } else if (statuses[Permission.storage]!.isPermanentlyDenied ||
          statuses[Permission.manageExternalStorage]!.isPermanentlyDenied) {
        print("Storage permission permanently denied.");
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
        print("Storage permission denied.");
      }
    }
  }

  /// Check if user details are already saved locally
  Future<void> checkUserSaved() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedName = prefs.getString("user_name");
      String? savedPhone = prefs.getString("user_phone");

      if (savedName != null && savedPhone != null) {
        print("User exists. Fetching progress from server...");
        await fetchUserProgress(savedName, savedPhone);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookCoverPage()),
        );
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  /// Fetch user progress from the server and store locally
  Future<void> fetchUserProgress(String name, String phone) async {
    final String url = "https://esheapp.in/e_she_book/get_user_progress.php";
    print("Fetching user progress...");
    print("Name: $name");
    print("Phone: $phone");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "name": name,
          "phone": phone,
        },
      );

      print("Server Response Received");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData["status"] == "success") {
          String progressData = responseData["progress"];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("user_progress", progressData);
          print("User progress saved locally: $progressData");
        } else {
          print("No progress found for this user.");
        }
      } else {
        print("Error retrieving progress: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  /// Save user details locally
  Future<void> saveUserLocally(String name, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", name);
    await prefs.setString("user_phone", phone);
    print("User details saved locally: Name=$name, Phone=$phone");
  }

  /// Register or retrieve user from server and navigate to main page
  Future<void> sendDataToServer() async {
    final String url = "https://esheapp.in/e_she_book/insert_user.php";
    print("Sending user data to server...");
    print("Name: ${nameController.text.trim()}");
    print("Phone: ${phoneController.text.trim()}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
        },
      );

      print("Server Response Received");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["status"] == "exists") {
          setState(() {
            statusMessage = "✅ User already exists! Fetching progress...";
          });
          await fetchUserProgress(nameController.text.trim(), phoneController.text.trim());
        } else if (responseData["status"] == "success") {
          setState(() {
            statusMessage = "✅ User added successfully!";
          });
        } else {
          setState(() {
            statusMessage = "❌ Server Error: ${responseData["message"]}";
          });
          return;
        }

        await saveUserLocally(nameController.text.trim(), phoneController.text.trim());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookCoverPage()),
        );
      } else {
        setState(() {
          statusMessage = "❌ Server Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "❌ Failed: $e";
      });
      print("Exception occurred: $e");
    }
  }

  void _submitDetails() {
    if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
      sendDataToServer();
    } else {
      setState(() {
        statusMessage = "❌ Please enter both name and phone number!";
      });
    }
  }

  // Reusable input field widget matching the login style
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black54),
        ),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Color(0xFFE00800)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black54, width: 2),
              ),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black45),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FBFF), // Matching light background
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              // Logo Section
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ClipOval(
                    child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                'SEED FOR SAFETY',
                style: TextStyle(
                  fontFamily: 'aAtomicMd',
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1),
              Text(
                'ISO 9001:2015 and ISO 21001:2018 Certified Company',
                style: TextStyle(
                  fontFamily: 'aAtomicMd',
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 80),
              // Title Section
              Text(
                'Fire Safety',
                style: TextStyle(
                  fontFamily: 'Typo',
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              // Input Fields
              _buildInputField(
                label: 'Enter Your Name',
                controller: nameController,
                icon: Icons.person,
                hint: 'Your Name',
              ),
              SizedBox(height: 16),
              _buildInputField(
                label: 'Enter Your Phone Number',
                controller: phoneController,
                icon: Icons.phone,
                hint: 'Your Phone Number',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 30),
              // Submit Button
              ElevatedButton(
                onPressed: _submitDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE00800),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Status Message
              Text(
                statusMessage,
                style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 180),
              // Footer
              Text(
                'Powered by Lee Safezone',
                style: TextStyle(fontSize: 14, color: Colors.black38),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
