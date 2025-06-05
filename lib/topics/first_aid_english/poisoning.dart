import 'package:e_she_book/english/first_aid_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoisoningFirstAidPage extends StatefulWidget {
  @override
  _PoisoningFirstAidPageState createState() => _PoisoningFirstAidPageState();
}

class _PoisoningFirstAidPageState extends State<PoisoningFirstAidPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "PoisoningFirstAid";

  final Map<int, String> correctAnswers = {
    1: "Exposure to harmful substances via swallowing, inhaling, or skin contact",
    2: "Check responsiveness and call emergency services",
    3: "No, not unless advised",
    4: "Yes, if possible, to assist treatment",
    5: "Move to fresh air immediately and seek help",
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is poisoning?",
      "options": [
        "Food allergy",
        "Exposure to harmful substances via swallowing, inhaling, or skin contact",
        "Coughing",
        "Fatigue"
      ]
    },
    {
      "question": "What should be the first step?",
      "options": [
        "Give milk",
        "Wait and watch",
        "Check responsiveness and call emergency services",
        "Ignore it"
      ]
    },
    {
      "question": "Should vomiting be induced in all poisoning cases?",
      "options": [
        "Yes",
        "Only if conscious",
        "No, not unless advised",
        "Always"
      ]
    },
    {
      "question": "Is it important to identify the poison?",
      "options": [
        "No",
        "Yes, if possible, to assist treatment",
        "Sometimes",
        "Only at hospital"
      ]
    },
    {
      "question": "What should be done for inhaled poison?",
      "options": [
        "Stay inside",
        "Drink water",
        "Move to fresh air immediately and seek help",
        "Lie down"
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
              title: Text("Poisoning First Aid Quiz"),
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
          content: Text("You scored $score out of ${quizQuestions.length}"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
            TextButton(onPressed: _showQuizDialog, child: Text("Retest"))
          ],
        );
      },
    );
  }

  Widget _buildQuestionAnswer(String q, String a) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(a, style: TextStyle(fontSize: 16)),
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
          ),title: Text("Poisoning First Aid")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("☠️ What is poisoning?", "When a harmful substance is swallowed, inhaled, injected, or absorbed into the body."),
                  _buildQuestionAnswer("☠️ What is the first action to take?", "Check the person’s responsiveness and call emergency services."),
                  _buildQuestionAnswer("☠️ Should vomiting be induced?", "No, not unless directed by a poison control center or medical personnel."),
                  _buildQuestionAnswer("☠️ Is identifying the poison important?", "Yes, it helps guide emergency treatment."),
                  _buildQuestionAnswer("☠️ What to do in inhaled poisoning?", "Move the person to fresh air immediately and avoid breathing fumes yourself."),
                  _buildQuestionAnswer("☠️ What symptoms can indicate poisoning?", "Nausea, vomiting, confusion, burns around the mouth, or seizures."),
                  _buildQuestionAnswer("☠️ Should you give food or drink?", "No, not unless advised by professionals."),
                  _buildQuestionAnswer("☠️ What to do with skin-contact poison?", "Remove contaminated clothing and rinse skin thoroughly with water."),
                  _buildQuestionAnswer("☠️ Can household items be poisonous?", "Yes – like cleaning agents, medicines, or cosmetics if misused."),
                  _buildQuestionAnswer("☠️ When to call poison control?", "Immediately if poisoning is suspected – do not wait for symptoms."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
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