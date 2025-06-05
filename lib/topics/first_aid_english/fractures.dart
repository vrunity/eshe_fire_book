import 'package:e_she_book/english/first_aid_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FracturesAndSprainsPage extends StatefulWidget {
  @override
  _FracturesAndSprainsPageState createState() => _FracturesAndSprainsPageState();
}

class _FracturesAndSprainsPageState extends State<FracturesAndSprainsPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FracturesAndSprains";

  final Map<int, String> correctAnswers = {
    1: "A break or crack in a bone",
    2: "Swelling, pain, inability to move, bruising",
    3: "Apply a splint and immobilize the limb",
    4: "Do not move the injured person unnecessarily",
    5: "Yes, especially if the injury is severe or there's a risk of further harm",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is a fracture?",
      "options": [
        "A muscle tear",
        "A break or crack in a bone",
        "A skin wound",
        "None of the above"
      ]
    },
    {
      "question": "What are signs of a fracture?",
      "options": [
        "Swelling, pain, inability to move, bruising",
        "Only bleeding",
        "Sneezing",
        "Headache"
      ]
    },
    {
      "question": "How should a fracture be handled?",
      "options": [
        "Apply a splint and immobilize the limb",
        "Move the person quickly",
        "Rub the area",
        "Apply lotion"
      ]
    },
    {
      "question": "Should a fractured limb be moved?",
      "options": [
        "Yes, immediately",
        "No, unless absolutely necessary",
        "Yes, to check flexibility",
        "Move as much as possible"
      ]
    },
    {
      "question": "Is it necessary to call for medical help for fractures?",
      "options": [
        "No, not required",
        "Only if there’s bleeding",
        "Yes, especially if the injury is severe or there's a risk of further harm",
        "Only after one day"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCompleted = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      isCompleted = value;
    });
    if (value) _showQuizDialog();
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
              title: Text("Fractures and Sprains Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int index = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$index. ${question["question"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[index],
                            onChanged: (value) {
                              setState(() {
                                userAnswers[index] = value!;
                              });
                            },
                          );
                        }).toList(),
                        SizedBox(height: 10),
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
                        SnackBar(content: Text("Please answer all questions.")),
                      );
                    } else {
                      Navigator.pop(dialogContext);
                      _evaluateQuiz();
                    }
                  },
                )
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
      if (correctAnswers[key] == value) score++;
    });
    _saveQuizScore(score);
    _showResult(score);
  }

  void _showResult(int score) {
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
                  Navigator.pushNamed(context, '/electric_shock_en'); // Navigate to next topic page
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => firstaid_english()),
              );
            },
          ),title: Text("Fractures and Sprains")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🦴 What is a fracture?", "It is a break or crack in a bone caused by trauma or stress.",imagePath: 'assets/first_aid_4.0.png'),
                  _buildQuestionAnswer("🦴 What is a sprain?", "An injury to the ligaments around a joint, often caused by twisting."),
                  _buildQuestionAnswer("🦴 What are signs of a fracture?", "Swelling, bruising, pain, and inability to move the area.",imagePath: 'assets/first_aid_4.1.png'),
                  _buildQuestionAnswer("🦴 What is the first step in First Aid for fractures?", "Immobilize the area using a splint or sling."),
                  _buildQuestionAnswer("🦴 Should you move a person with suspected fracture?", "Only if absolutely necessary and with caution.",imagePath: 'assets/first_aid_4.2.png'),
                  _buildQuestionAnswer("🦴 Can you realign the bone?", "No. Leave that to medical professionals."),
                  _buildQuestionAnswer("🦴 What is RICE method for sprains?", "Rest, Ice, Compression, and Elevation.",imagePath: 'assets/first_aid_4.3.png'),
                  _buildQuestionAnswer("🦴 How long should ice be applied?", "15–20 minutes every 2–3 hours for the first 48 hours."),
                  _buildQuestionAnswer("🦴 When should you seek emergency help?", "If the bone is protruding or there is heavy bleeding.",imagePath: 'assets/first_aid_4.4.png'),
                  _buildQuestionAnswer("🦴 Should tight rings or watches be removed?", "Yes, to prevent constriction as swelling increases."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Take Quiz Now"),
              value: isCompleted,
              onChanged: (value) => _saveCompletion(value ?? false),
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
}
