import 'package:e_she_book/english/first_aid_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CPRForChildrenPage extends StatefulWidget {
  @override
  _CPRForChildrenPageState createState() => _CPRForChildrenPageState();
}

class _CPRForChildrenPageState extends State<CPRForChildrenPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "CPRForChildren";

  final Map<int, String> correctAnswers = {
    1: "Yes, but with adjusted force and technique",
    2: "Check response, breathing, and pulse",
    3: "30 compressions and 2 breaths",
    4: "One or two hands depending on child's size",
    5: "Start CPR immediately and call for help",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Can CPR be given to children?",
      "options": [
        "No",
        "Yes, but with adjusted force and technique",
        "Only by doctors",
        "Never needed"
      ]
    },
    {
      "question": "What is the first step before giving CPR to a child?",
      "options": [
        "Shake them violently",
        "Feed them water",
        "Check response, breathing, and pulse",
        "Take photo for help"
      ]
    },
    {
      "question": "What is the chest compression to breath ratio?",
      "options": [
        "10:2",
        "15:1",
        "30:2",
        "5:5"
      ]
    },
    {
      "question": "How many hands should be used for compressions?",
      "options": [
        "Two hands always",
        "One or two hands depending on child's size",
        "One finger",
        "Use foot"
      ]
    },
    {
      "question": "When should emergency help be called?",
      "options": [
        "After CPR only",
        "If you’re tired",
        "Start CPR immediately and call for help",
        "If parents arrive"
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
              title: Text("CPR for Children Quiz"),
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
                  Navigator.pushNamed(context, '/choking_firstaid_en'); // Navigate to next topic page
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
          ),title: Text("CPR for Children")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("👶 Is CPR safe for children?", "Yes, but pressure and technique must be adapted to their size."),
                  _buildQuestionAnswer("👶 How to check a child before CPR?", "Tap gently and call their name to check for responsiveness."),
                  _buildQuestionAnswer("👶 What is the compression to breath ratio?", "30 compressions and 2 rescue breaths."),
                  _buildQuestionAnswer("👶 How deep should chest compressions be?", "About 2 inches or one-third the depth of the chest."),
                  _buildQuestionAnswer("👶 How many hands should be used?", "One or two hands depending on the size of the child."),
                  _buildQuestionAnswer("👶 Should you give rescue breaths?", "Yes, after 30 compressions, give 2 gentle breaths."),
                  _buildQuestionAnswer("👶 What should be done if the child does not respond?", "Continue CPR and call emergency services."),
                  _buildQuestionAnswer("👶 Can an AED be used on a child?", "Yes, use pediatric pads if available."),
                  _buildQuestionAnswer("👶 What should be avoided?", "Avoid excessive force during compressions or breaths."),
                  _buildQuestionAnswer("👶 What’s the goal of child CPR?", "To keep blood and oxygen flowing to vital organs until help arrives."),
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
