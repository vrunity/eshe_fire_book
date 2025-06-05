import 'package:e_she_book/english/fire_safety_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirePreventionPage extends StatefulWidget {
  @override
  _FirePreventionPageState createState() => _FirePreventionPageState();
}

class _FirePreventionPageState extends State<FirePreventionPage> {
  bool istopic_4_Completed = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FirePrevention"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "Regular inspections, proper storage of flammable materials, and safety training",
    2: "Do not turn on electrical switches; open windows and leave immediately",
    3: "Fire alarms should be tested monthly and serviced annually",
    4: "Removing waste and clutter prevents fire hazards from accumulating",
    5: "Keep flammable objects away from stoves, and never leave cooking unattended",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "How can fires be prevented in industrial areas?",
      "options": [
        "Regular inspections, proper storage of flammable materials, and safety training",
        "Allowing flammable liquids to be stored anywhere",
        "Ignoring fire drills",
        "None of the above"
      ]
    },
    {
      "question": "What should you do if you smell gas in a closed room?",
      "options": [
        "Turn on all lights to see clearly",
        "Do not turn on electrical switches; open windows and leave immediately",
        "Close all windows and wait",
        "Ignore it, as the smell will go away"
      ]
    },
    {
      "question": "How often should fire alarms be checked?",
      "options": [
        "Once every 5 years",
        "Fire alarms should be tested monthly and serviced annually",
        "Whenever they make noise",
        "Only after a fire incident"
      ]
    },
    {
      "question": "Why is housekeeping important in fire prevention?",
      "options": [
        "Removing waste and clutter prevents fire hazards from accumulating",
        "It is only necessary for appearance",
        "It slows down emergency response",
        "It helps in spreading the fire"
      ]
    },
    {
      "question": "What safety measures should be taken in kitchens?",
      "options": [
        "Keep flammable objects away from stoves, and never leave cooking unattended",
        "Use plastic utensils near open flames",
        "Store gas cylinders near high heat",
        "Ignore fire safety precautions in the kitchen"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadTopicCompletionStatus();
  }

  Future<void> _loadTopicCompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      istopic_4_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_4_Completed = value;
    });

    if (value) {
      Future.delayed(Duration(milliseconds: 300), () {
        _showQuizDialog();
      });
    }
  }

  Future<void> _saveQuizScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('QuizScore_$topicName', score);
    await prefs.setBool('QuizTaken_$topicName', true);
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
    });
  }

  void _showQuizDialog() {
    userAnswers.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Fire Prevention Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int questionIndex = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question["question"],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[questionIndex],
                            onChanged: (String? value) {
                              setState(() {
                                userAnswers[questionIndex] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Submit"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please answer all questions")),
                      );
                    } else {
                      Navigator.pop(dialogContext);
                      _evaluateQuiz();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _evaluateQuiz() {
    int score = 0;
    userAnswers.forEach((key, value) {
      if (correctAnswers[key] == value) {
        score++;
      }
    });
    _saveQuizScore(score);
    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quiz Result"),
          content: Text("You scored $score out of ${quizQuestions.length}."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score > 3) // ✅ Show Next Topic only if score > 3
              TextButton(
                child: Text("Next Topic"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/fire_emergency_en'); // Navigate to next topic page
                },
              ),
            TextButton(
              child: Text("Retest"),
              onPressed: () {
                Navigator.pop(context);
                _showQuizDialog();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove shadow for clean UI
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF4500), Color(0xFF5B0000)], // Red to Dark Maroon
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28), // Back Arrow
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => fire_safety_english()),
              );
            },
          ),title: Text("Fire Prevention Techniques")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 How can fires be prevented in industrial areas?", "Regular inspections, proper storage of flammable materials, and safety training.",imagePath: 'assets/banner_4.1.jpeg'),
                  _buildQuestionAnswer("🔥 What should you do if you smell gas in a closed room?", "Do not turn on electrical switches; open windows and leave immediately."),
                  _buildQuestionAnswer("🔥 How often should fire alarms be checked?", "Fire alarms should be tested monthly and serviced annually.",imagePath: 'assets/banner_4.2.jpg'),
                  _buildQuestionAnswer("🔥 Why is housekeeping important in fire prevention?", "Removing waste and clutter prevents fire hazards from accumulating."),
                  _buildQuestionAnswer("🔥 What safety measures should be taken in kitchens?", "Keep flammable objects away from stoves, and never leave cooking unattended.",imagePath: 'assets/banner_4.3.jpg'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Take Quiz Now"),
              value: istopic_4_Completed,
              onChanged: (value) {
                _saveTopicCompletionStatus(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("Last Quiz Score: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("Retest"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionAnswer(String question, String answer, {String? imagePath}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // If image is provided, show it at the top full-width
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                ),
              ),
            if (imagePath != null)
              SizedBox(height: 12),
            // Question
            Text(
              question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 6),
            // Answer
            Text(
              answer,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

