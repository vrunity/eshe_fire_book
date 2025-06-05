import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BurnInjuriesChildrenPage extends StatefulWidget {
  @override
  _BurnInjuriesChildrenPageState createState() => _BurnInjuriesChildrenPageState();
}

class _BurnInjuriesChildrenPageState extends State<BurnInjuriesChildrenPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "BurnInjuriesChildren";

  final Map<int, String> correctAnswers = {
    1: "Hot liquids, steam, electrical sources",
    2: "Gently remove clothing not stuck to skin",
    3: "Cool the area under running water",
    4: "No, avoid creams or butter",
    5: "Use clean, non-stick dressing",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What causes burn injuries in children?",
      "options": [
        "Hot liquids, steam, electrical sources",
        "Cold water",
        "Dry towels",
        "Sunlight only"
      ]
    },
    {
      "question": "What should be done with burned clothing?",
      "options": [
        "Rip it off",
        "Gently remove clothing not stuck to skin",
        "Leave it always",
        "Soak it in oil"
      ]
    },
    {
      "question": "What is the first step in burn care?",
      "options": [
        "Apply cream",
        "Cool the area under running water",
        "Cover with blanket",
        "Give hot drink"
      ]
    },
    {
      "question": "Can you apply butter to burns?",
      "options": [
        "Yes",
        "No, avoid creams or butter",
        "Only on small burns",
        "Apply oil instead"
      ]
    },
    {
      "question": "What should be used to cover a burn?",
      "options": [
        "Cotton wool",
        "Plastic wrap",
        "Use clean, non-stick dressing",
        "Tissue paper"
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
              title: Text("Burn Injuries in Children Quiz"),
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
                  Navigator.pushNamed(context, '/poisoning_firstaid_en'); // Navigate to next topic page
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
      appBar: AppBar(title: Text("Burn Injuries in Children")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 What causes most burns in children?", "Hot liquids, hot surfaces, steam, electricity, and chemicals."),
                  _buildQuestionAnswer("🔥 What is the first step in treating a burn?", "Remove the child from the source and cool the area under running water."),
                  _buildQuestionAnswer("🔥 Can you remove burned clothes?", "Yes, gently, unless stuck to skin."),
                  _buildQuestionAnswer("🔥 Should ointments or butter be applied?", "No, these can worsen burns or cause infection."),
                  _buildQuestionAnswer("🔥 What should be applied after cooling?", "A clean, dry, non-stick dressing."),
                  _buildQuestionAnswer("🔥 When to seek emergency help?", "If burn is deep, covers large area, or affects face, hands, or genitals."),
                  _buildQuestionAnswer("🔥 How to comfort a burned child?", "Stay calm, reassure them, and avoid unnecessary movement."),
                  _buildQuestionAnswer("🔥 Can burns cause shock?", "Yes, especially large or severe burns."),
                  _buildQuestionAnswer("🔥 What signs show burn shock?", "Pale skin, cold hands, rapid breathing, weakness."),
                  _buildQuestionAnswer("🔥 Should you break blisters?", "No, keep them intact to prevent infection."),
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
