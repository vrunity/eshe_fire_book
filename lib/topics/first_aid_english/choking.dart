import 'package:e_she_book/english/first_aid_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChokingFirstAidPage extends StatefulWidget {
  @override
  _ChokingFirstAidPageState createState() => _ChokingFirstAidPageState();
}

class _ChokingFirstAidPageState extends State<ChokingFirstAidPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ChokingFirstAid";

  final Map<int, String> correctAnswers = {
    1: "Obstruction in the airway",
    2: "Inability to speak, cough, or breathe",
    3: "Use back blows and abdominal thrusts",
    4: "Yes, but be more gentle",
    5: "Call emergency services if object doesn’t come out",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is choking?",
      "options": [
        "Heart pain",
        "Obstruction in the airway",
        "Back pain",
        "Mild cough"
      ]
    },
    {
      "question": "What are signs of choking?",
      "options": [
        "Inability to speak, cough, or breathe",
        "Smiling",
        "Sneezing",
        "Normal talking"
      ]
    },
    {
      "question": "How to help someone who is choking?",
      "options": [
        "Offer water",
        "Use back blows and abdominal thrusts",
        "Ignore them",
        "Lay them down"
      ]
    },
    {
      "question": "Can you perform abdominal thrusts on children?",
      "options": [
        "Yes, but be more gentle",
        "No",
        "Only adults",
        "Use feet instead"
      ]
    },
    {
      "question": "What to do if choking continues?",
      "options": [
        "Call emergency services if object doesn’t come out",
        "Leave them",
        "Give them juice",
        "Wait for someone else"
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
              title: Text("Choking First Aid Quiz"),
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
                  Navigator.pushNamed(context, '/burn_injuries_children_en'); // Navigate to next topic page
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
          ),title: Text("Choking First Aid")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🫁 What is choking?", "It occurs when a foreign object blocks the airway, making breathing difficult."),
                  _buildQuestionAnswer("🫁 What are signs of choking?", "Inability to speak, breathe, or cough, and sometimes silent gasping."),
                  _buildQuestionAnswer("🫁 What is the first aid for conscious choking?", "Encourage coughing if possible, then give 5 back blows and 5 abdominal thrusts."),
                  _buildQuestionAnswer("🫁 What is the Heimlich maneuver?", "A technique using abdominal thrusts to dislodge the object."),
                  _buildQuestionAnswer("🫁 What to do if person becomes unconscious?", "Lower them to the ground, start CPR and check for obstruction in mouth."),
                  _buildQuestionAnswer("🫁 Can choking happen to babies?", "Yes, and they need different first aid — back slaps and chest thrusts."),
                  _buildQuestionAnswer("🫁 Should you give water to someone choking?", "No, it may worsen the blockage."),
                  _buildQuestionAnswer("🫁 Is choking always obvious?", "Not always. Some people may not make any sound."),
                  _buildQuestionAnswer("🫁 Can a choking person nod or signal?", "Yes, they may point to throat or appear panicked."),
                  _buildQuestionAnswer("🫁 When should emergency services be called?", "Immediately if choking is severe or persists after attempts to clear it."),
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
