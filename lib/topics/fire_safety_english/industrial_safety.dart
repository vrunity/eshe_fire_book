import 'package:e_she_book/english/fire_safety_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class IndustrialSafetyPage extends StatefulWidget {
  @override
  _IndustrialSafetyPageState createState() => _IndustrialSafetyPageState();
}

class _IndustrialSafetyPageState extends State<IndustrialSafetyPage> {
  bool istopic_7_Completed = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "IndustrialSafety"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "Machinery overheating, chemical storage, and electrical faults",
    2: "Regular equipment maintenance, fire drills, and using safety gear",
    3: "To detect and control fires before they spread",
    4: "It provides a continuous water supply for firefighting",
    5: "It protects workers from burns and toxic fumes",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What are the main fire hazards in industries?",
      "options": [
        "Machinery overheating, chemical storage, and electrical faults",
        "Only electrical issues",
        "No risk in industrial areas",
        "Fire cannot happen in industries"
      ]
    },
    {
      "question": "How can factories prevent fire hazards?",
      "options": [
        "Regular equipment maintenance, fire drills, and using safety gear",
        "Ignoring safety training",
        "Only using fire alarms",
        "No need for precautions"
      ]
    },
    {
      "question": "Why should industries have fire detection systems?",
      "options": [
        "To detect and control fires before they spread",
        "For decoration purposes",
        "They are not necessary",
        "To increase expenses"
      ]
    },
    {
      "question": "What is the purpose of a fire hydrant system in industries?",
      "options": [
        "It provides a continuous water supply for firefighting",
        "It is used for decoration",
        "It is not useful",
        "Only for legal compliance"
      ]
    },
    {
      "question": "How does personal protective equipment (PPE) help in fire safety?",
      "options": [
        "It protects workers from burns and toxic fumes",
        "It is only for looks",
        "It is unnecessary",
        "Only firefighters should use PPE"
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
      istopic_7_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_7_Completed = value;
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
              title: Text("Industrial Fire Safety Quiz"),
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

  void _evaluateQuiz() async {
    int score = 0;
    userAnswers.forEach((key, value) {
      if (correctAnswers[key] == value) {
        score++;
      }
    });

    await _saveQuizScore(score);

    if (score >= 3) {
      final String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('CourseCompletedOn_Fire Safety', formattedDate);
      print("✅ Course completed date stored for Fire Safety: $formattedDate");
    }

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
              onPressed: () =>  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => fire_safety_english()),
              ),
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
          ),title: Text("Industrial Fire Safety")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 What are the main fire hazards in industries?", "Machinery overheating, chemical storage, and electrical faults.",imagePath: 'assets/banner_7.1.jpg'),
                  _buildQuestionAnswer("🔥 How can factories prevent fire hazards?", "Regular equipment maintenance, fire drills, and using safety gear."),
                  _buildQuestionAnswer("🔥 Why should industries have fire detection systems?", "To detect and control fires before they spread.",imagePath: 'assets/banner_7.2.jpg'),
                  _buildQuestionAnswer("🔥 What is the purpose of a fire hydrant system in industries?", "It provides a continuous water supply for firefighting."),
                  _buildQuestionAnswer("🔥 How does personal protective equipment (PPE) help in fire safety?", "It protects workers from burns and toxic fumes.",imagePath: 'assets/banner_7.3.jpg'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Take Quiz Now"),
              value: istopic_7_Completed,
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
