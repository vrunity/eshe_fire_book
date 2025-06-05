import 'package:e_she_book/english/first_aid_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BurnsAndScaldsPage extends StatefulWidget {
  @override
  _BurnsAndScaldsPageState createState() => _BurnsAndScaldsPageState();
}

class _BurnsAndScaldsPageState extends State<BurnsAndScaldsPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "BurnsAndScalds";

  final Map<int, String> correctAnswers = {
    1: "Burns are from dry heat; scalds from hot liquids or steam",
    2: "First, second, and third degree",
    3: "Cool the burn under running water for 10-20 minutes",
    4: "Yes, as it can cause infection",
    5: "Use a clean, non-stick dressing",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is the difference between burns and scalds?",
      "options": [
        "Burns are from dry heat; scalds from hot liquids or steam",
        "Both are the same",
        "Scalds are from chemicals",
        "Burns are less serious"
      ]
    },
    {
      "question": "What are the types of burns?",
      "options": [
        "First, second, and third degree",
        "Mild and severe",
        "External and internal",
        "Chemical and physical"
      ]
    },
    {
      "question": "What should you do first for a minor burn?",
      "options": [
        "Apply toothpaste",
        "Cool the burn under running water for 10-20 minutes",
        "Cover with ice",
        "Apply butter"
      ]
    },
    {
      "question": "Should you pop blisters from a burn?",
      "options": [
        "Yes, to release fluid",
        "No, it can cause infection",
        "Only large ones",
        "Always"
      ]
    },
    {
      "question": "What dressing should be used for burns?",
      "options": [
        "Tissue paper",
        "Cotton wool",
        "Plastic wrap",
        "Use a clean, non-stick dressing"
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
              title: Text("Burns and Scalds Quiz"),
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
                  Navigator.pushNamed(context, '/fractures_and_sprains_en'); // Navigate to next topic page
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
          ),title: Text("Burns and Scalds")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 What is a burn?", "A damage to skin or tissues caused by heat, electricity, chemicals, or radiation.",imagePath: 'assets/first_aid_3.0.png'),
                  _buildQuestionAnswer("🔥 What is a scald?", "Injury caused by hot liquids or steam."),
                  _buildQuestionAnswer("🔥 What are the degrees of burns?", "First (red skin), Second (blisters), Third (deep tissue damage).",imagePath: 'assets/first_aid_3.1.png'),
                  _buildQuestionAnswer("🔥 What to do first for a minor burn?", "Cool it with running water for 10–20 minutes."),
                  _buildQuestionAnswer("🔥 Can we apply ice to a burn?", "No, ice can damage the skin further.",imagePath: 'assets/first_aid_3.2.png'),
                  _buildQuestionAnswer("🔥 What not to apply on burns?", "Do not apply butter, oils, or toothpaste."),
                  _buildQuestionAnswer("🔥 Should blisters be popped?", "No, leave them intact to prevent infection.",imagePath: 'assets/first_aid_3.0.png'),
                  _buildQuestionAnswer("🔥 How to cover a burn after cooling?", "Use a clean, non-stick dressing or cling film."),
                  _buildQuestionAnswer("🔥 When should you seek medical help?", "If the burn is large, deep, or affects the face, hands, or genitals.",imagePath: 'assets/first_aid_3.4.png'),
                  _buildQuestionAnswer("🔥 What are signs of severe burns?", "Charred skin, white patches, or numbness."),
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
