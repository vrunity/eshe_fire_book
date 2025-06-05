// forklift_intro.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/forklift_safety_english.dart';

class ForkliftIntroPage extends StatefulWidget {
  @override
  _ForkliftIntroPageState createState() => _ForkliftIntroPageState();
}

class _ForkliftIntroPageState extends State<ForkliftIntroPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ForkliftIntro";

  final Map<int, String> correctAnswers = {
    1: "Forklifts are used to lift and move materials safely.",
    2: "Because they are heavy and powerful equipment.",
    3: "It can cause serious injury or damage.",
    4: "Read manuals, take training, and follow rules.",
    5: "Yes, especially in crowded or busy environments."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is the main purpose of a forklift?",
      "options": [
        "Playground fun",
        "Cooking food",
        "Forklifts are used to lift and move materials safely.",
        "Transport people"
      ]
    },
    {
      "question": "Why is forklift safety important?",
      "options": [
        "Because they are light vehicles",
        "Because they are fun",
        "Because they are heavy and powerful equipment.",
        "Because they make noise"
      ]
    },
    {
      "question": "What can happen if forklifts are misused?",
      "options": [
        "It will fly",
        "It can cause serious injury or damage.",
        "It makes you faster",
        "It will stop working"
      ]
    },
    {
      "question": "How can we operate forklifts safely?",
      "options": [
        "Just drive fast",
        "Ignore training",
        "Read manuals, take training, and follow rules.",
        "Press all buttons"
      ]
    },
    {
      "question": "Is forklift safety relevant in the workplace?",
      "options": [
        "No, it’s only for racing",
        "Yes, especially in crowded or busy environments.",
        "Only at home",
        "Not necessary"
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
              title: Text("Quiz: Forklift Introduction"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int questionIndex = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question["question"], style: TextStyle(fontWeight: FontWeight.bold)),
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
            if (score >= 3)
              TextButton(
                child: Text("Next Topic"),
                onPressed: () {
                  Navigator.pushNamed(context, '/center_of_gravity_en');
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
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imagePath, fit: BoxFit.cover, height: 180, width: double.infinity),
              ),
            if (imagePath != null) SizedBox(height: 10),
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 6),
            Text(answer, style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Introduction to Forklift Safety"),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ForkliftSafetyEnglish()),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🚜 What is a forklift?", "A forklift is a vehicle with a pronged device in front to lift and move materials.", imagePath: 'assets/forklift_1.0.png'),
                  _buildQuestionAnswer("⚠ Why is forklift safety important?", "Because misuse can lead to serious injuries and workplace accidents."),
                  _buildQuestionAnswer("❌ What happens if forklifts are used improperly?", "It can result in tipping, crushing, or collision with people or objects.", imagePath: 'assets/forklift_1.1.png'),
                  _buildQuestionAnswer("📘 How can you stay safe?", "By following training, understanding controls, and wearing PPE."),
                  _buildQuestionAnswer("🏭 Is forklift safety relevant at all sites?", "Yes, especially in warehouses, factories, and construction zones.", imagePath: 'assets/forklift_1.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: isCompleted,
              onChanged: (value) {
                _saveCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("Last Quiz Score: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("Retest")),
          ],
        ),
      ),
    );
  }
}
