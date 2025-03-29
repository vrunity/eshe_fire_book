import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireExtinguishersPage extends StatefulWidget {
  @override
  _FireExtinguishersPageState createState() => _FireExtinguishersPageState();
}

class _FireExtinguishersPageState extends State<FireExtinguishersPage> {
  bool istopic_3_Completed = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FireExtinguishers"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "Water, Foam, Dry Powder, Carbon Dioxide (CO₂), and Wet Chemical",
    2: "CO₂ or Dry Powder extinguishers",
    3: "Foam or Dry Powder extinguishers",
    4: "Water can spread burning oil, making the fire worse",
    5: "Pull the pin, Aim at the base, Squeeze the handle, and Sweep side to side",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What are the different types of fire extinguishers?",
      "options": [
        "Water, Foam, Dry Powder, Carbon Dioxide (CO₂), and Wet Chemical",
        "Only Water and Foam",
        "Only Carbon Dioxide",
        "None of the above"
      ]
    },
    {
      "question": "Which extinguisher should be used for electrical fires?",
      "options": [
        "Water extinguisher",
        "CO₂ or Dry Powder extinguishers",
        "Foam extinguisher",
        "Wet Chemical extinguisher"
      ]
    },
    {
      "question": "Which extinguisher is used for flammable liquid fires?",
      "options": [
        "Water extinguisher",
        "Foam or Dry Powder extinguishers",
        "CO₂ extinguisher",
        "None of the above"
      ]
    },
    {
      "question": "Why is it dangerous to use a water extinguisher on oil fires?",
      "options": [
        "Water cools the oil faster",
        "Water can spread burning oil, making the fire worse",
        "Water will extinguish the fire safely",
        "None of the above"
      ]
    },
    {
      "question": "What is the PASS method in using an extinguisher?",
      "options": [
        "Pull the pin, Aim at the base, Squeeze the handle, and Sweep side to side",
        "Push the pin, Aim at the top, Sweep up and down",
        "Pull the pin, Aim at the flames, Spray continuously",
        "None of the above"
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
      istopic_3_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_3_Completed = value;
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
              title: Text("Fire Extinguishers Quiz"),
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
              Navigator.pop(context);
            },
          ),title: Text("Fire Extinguisher Types & Uses")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 What are the different types of fire extinguishers?", "Water, Foam, Dry Powder, Carbon Dioxide (CO₂), and Wet Chemical."),
                  _buildQuestionAnswer("🔥 Which extinguisher should be used for electrical fires?", "CO₂ or Dry Powder extinguishers."),
                  _buildQuestionAnswer("🔥 Which extinguisher is used for flammable liquid fires?", "Foam or Dry Powder extinguishers."),
                  _buildQuestionAnswer("🔥 Why is it dangerous to use a water extinguisher on oil fires?", "Water can spread burning oil, making the fire worse."),
                  _buildQuestionAnswer("🔥 What is the PASS method in using an extinguisher?", "Pull the pin, Aim at the base, Squeeze the handle, and Sweep side to side."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: istopic_3_Completed,
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
}


Widget _buildQuestionAnswer(String question, String answer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(answer, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

