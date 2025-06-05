import 'package:e_she_book/english/first_aid_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BleedingControlPage extends StatefulWidget {
  @override
  _BleedingControlPageState createState() => _BleedingControlPageState();
}

class _BleedingControlPageState extends State<BleedingControlPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "BleedingControl";

  final Map<int, String> correctAnswers = {
    1: "Injury to blood vessels",
    2: "Capillary, venous, arterial",
    3: "Apply direct pressure",
    4: "Clean cloth or sterile dressing",
    5: "To avoid infection and control bleeding",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What causes bleeding?",
      "options": [
        "Injury to blood vessels",
        "Fever",
        "Skin rash",
        "Dehydration"
      ]
    },
    {
      "question": "What are the types of bleeding?",
      "options": [
        "Capillary, venous, arterial",
        "Minor, moderate, major",
        "Superficial, deep, internal",
        "External only"
      ]
    },
    {
      "question": "How do you stop external bleeding?",
      "options": [
        "Apply direct pressure",
        "Sprinkle cold water",
        "Expose to air",
        "Bandage without pressure"
      ]
    },
    {
      "question": "What can be used to cover a bleeding wound?",
      "options": [
        "Clean cloth or sterile dressing",
        "Plastic sheet",
        "Tissue paper",
        "Cotton wool"
      ]
    },
    {
      "question": "Why should you wash your hands before giving First Aid?",
      "options": [
        "To avoid infection and control bleeding",
        "To look professional",
        "To clean yourself",
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
              title: Text("Bleeding Control Quiz"),
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
                  Navigator.pushNamed(context, '/burns_and_scalds_en'); // Navigate to next topic page
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
          ),title: Text("Bleeding Control")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🩸 What causes bleeding?", "Bleeding occurs when blood vessels are damaged due to injury or trauma.",imagePath: 'assets/first_aid_2.0.png'),
                  _buildQuestionAnswer("🩸 What are the three types of bleeding?", "Capillary, venous, and arterial bleeding."),
                  _buildQuestionAnswer("🩸 What is the first step to control bleeding?", "Apply direct pressure to the wound with a clean cloth.",imagePath: 'assets/first_aid_1.2.png'),
                  _buildQuestionAnswer("🩸 Can tourniquets be used?", "Yes, but only in severe cases where bleeding cannot be controlled otherwise."),
                  _buildQuestionAnswer("🩸 Why should gloves be worn?", "To protect both the first aider and the victim from infections.",imagePath: 'assets/first_aid_2.2.png'),
                  _buildQuestionAnswer("🩸 Should you remove embedded objects?", "No. Stabilize them and apply pressure around them."),
                  _buildQuestionAnswer("🩸 What is internal bleeding?", "Bleeding that occurs inside the body and may not be visible externally.",imagePath: 'assets/first_aid_1.0.png'),
                  _buildQuestionAnswer("🩸 What signs indicate internal bleeding?", "Swelling, pain, bruising, or shock symptoms like dizziness."),
                  _buildQuestionAnswer("🩸 How should a bleeding limb be positioned?", "Elevate above heart level to reduce blood flow.",imagePath: 'assets/first_aid_2.4.png'),
                  _buildQuestionAnswer("🩸 When should emergency help be called?", "If bleeding is severe, continuous, or if the person shows shock symptoms."),
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
