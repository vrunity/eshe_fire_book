import 'dart:convert';
import 'dart:io';
import 'package:e_she_book/book_selection_page.dart';
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
  String bookType = 'fire'; // or 'fire' for the fire safety book

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
          MaterialPageRoute(builder: (context) => BookSelectionPage()),
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
          'book_type': 'fire',
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
          "book_type": "fire", // 👈 REQUIRED to prevent cross-access
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
            statusMessage = "${responseData["message"]}";
          });
          return;
        }

        await saveUserLocally(nameController.text.trim(), phoneController.text.trim());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookSelectionPage()),
        );
      } else {
        setState(() {
          statusMessage = "${response.statusCode}";
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
      backgroundColor: Color(0xFFF8FBFF),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              // Logo & Title
              Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.1),
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ClipOval(
                    child: Image.asset('assets/logo.png', height: 100, width: 100),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'SEED FOR SAFETY',
                style: TextStyle(
                  fontFamily: 'aAtomicMd',
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.red.shade700,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.red.withOpacity(0.15),
                      offset: Offset(1, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2),
              Text(
                'ISO 9001:2015 and ISO 21001:2018 Certified Company',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 35),
              // Decorative Divider
              Container(
                height: 6,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 35),
              // Card for Form
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title Section
                      Text(
                        'e-SHE App',
                        style: TextStyle(
                          fontFamily: 'Typo',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'E-learning',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '(Safety, Health, Environment)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.0,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      // Input Fields
                      _buildInputField(
                        label: 'Your Name',
                        controller: nameController,
                        icon: Icons.person,
                        hint: 'Type your name',
                      ),
                      SizedBox(height: 16),
                      _buildInputField(
                        label: 'Phone Number',
                        controller: phoneController,
                        icon: Icons.phone,
                        hint: 'Type your phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 24),
                      // Submit Button
                      ElevatedButton.icon(
                        onPressed: _submitDetails,
                        icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 22),
                        label: Text(
                          'Submit',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE00800),
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 8,
                          shadowColor: Colors.red.withOpacity(0.3),
                        ),
                      ),
                      SizedBox(height: 18),
                      // Status Message
                      if (statusMessage.isNotEmpty)
                        AnimatedOpacity(
                          opacity: 1,
                          duration: Duration(milliseconds: 500),
                          child: Text(
                            statusMessage,
                            style: TextStyle(
                              fontSize: 16,
                              color: statusMessage.contains('❌')
                                  ? Colors.red
                                  : Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 36),
              // Footer
              Opacity(
                opacity: 0.7,
                child: Text(
                  'Powered by Lee Safezone',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.7,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
