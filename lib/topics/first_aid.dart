import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstAidPage extends StatefulWidget {
  @override
  _FirstAidPageState createState() => _FirstAidPageState();
}

class _FirstAidPageState extends State<FirstAidPage> {
  bool istopic_8_Completed = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FirstAidForFireInjuries"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "Cool the burn under running water for at least 10 minutes",
    2: "It can cause further tissue damage",
    3: "Use the stop, drop, and roll method or cover with a heavy cloth",
    4: "Apply an antiseptic and cover with a sterile dressing",
    5: "Seek immediate medical attention and avoid touching the burned area",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is the first step in treating burns?",
      "options": [
        "Cool the burn under running water for at least 10 minutes",
        "Apply ice directly",
        "Wrap it tightly with cloth",
        "Ignore it"
      ]
    },
    {
      "question": "Why should ice not be used on burns?",
      "options": [
        "It can cause further tissue damage",
        "It helps in healing",
        "It provides instant relief",
        "It is better than cold water"
      ]
    },
    {
      "question": "What should be done if someone’s clothes are on fire?",
      "options": [
        "Use the stop, drop, and roll method or cover with a heavy cloth",
        "Spray perfume",
        "Run faster",
        "Shake off the flames"
      ]
    },
    {
      "question": "How should a minor burn be treated?",
      "options": [
        "Apply an antiseptic and cover with a sterile dressing",
        "Ignore it",
        "Apply toothpaste",
        "Use a bandage without antiseptic"
      ]
    },
    {
      "question": "What should be done for severe burns?",
      "options": [
        "Seek immediate medical attention and avoid touching the burned area",
        "Wash with soap",
        "Apply home remedies",
        "Cover it with plastic"
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
      istopic_8_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_8_Completed = value;
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
              title: Text("First Aid Quiz"),
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
      appBar: AppBar(title: Text("First Aid for Fire Injuries")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 What is the first step in treating burns?", "Cool the burn under running water for at least 10 minutes."),
                  _buildQuestionAnswer("🔥 Why should ice not be used on burns?", "It can cause further tissue damage."),
                  _buildQuestionAnswer("🔥 What should be done if someone’s clothes are on fire?", "Use the stop, drop, and roll method or cover with a heavy cloth."),
                  _buildQuestionAnswer("🔥 How should a minor burn be treated?", "Apply an antiseptic and cover with a sterile dressing."),
                  _buildQuestionAnswer("🔥 What should be done for severe burns?", "Seek immediate medical attention and avoid touching the burned area."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: istopic_8_Completed,
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
}
