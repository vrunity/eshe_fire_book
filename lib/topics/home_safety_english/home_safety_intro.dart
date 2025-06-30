import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/home_safety_english.dart';

class HomeSafetyIntroPage extends StatefulWidget {
  @override
  _HomeSafetyIntroPageState createState() => _HomeSafetyIntroPageState();
}

class _HomeSafetyIntroPageState extends State<HomeSafetyIntroPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "HomeSafetyIntro";

  final Map<int, String> correctAnswers = {
    1: "It helps reduce the risk of injuries and accidents in the home.",
    2: "Falls, burns, electrocution, gas leaks.",
    3: "Because many hazards are unnoticed but dangerous.",
    4: "Yes, especially for kids and elderly.",
    5: "Education and awareness."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Why is home safety important?",
      "options": [
        "It helps reduce the risk of injuries and accidents in the home.",
        "It decorates the house.",
        "It reduces electricity bills.",
        "It makes cleaning easier."
      ]
    },
    {
      "question": "What are common home hazards?",
      "options": [
        "Falls, burns, electrocution, gas leaks.",
        "Television and Wi-Fi.",
        "Plastic bottles and utensils.",
        "Books and magazines."
      ]
    },
    {
      "question": "Why do we need to be aware of safety at home?",
      "options": [
        "Because many hazards are unnoticed but dangerous.",
        "Because it’s trendy.",
        "Because neighbors told us.",
        "For beauty."
      ]
    },
    {
      "question": "Are children and elderly more at risk?",
      "options": [
        "Yes, especially for kids and elderly.",
        "No, only adults are at risk.",
        "Only during day time.",
        "Only when alone."
      ]
    },
    {
      "question": "How can accidents be reduced?",
      "options": [
        "Education and awareness.",
        "By ignoring the issues.",
        "By removing furniture.",
        "Using old appliances."
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
              title: Text("Quiz: Home Safety Introduction"),
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
      if (correctAnswers[key] == value) score++;
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
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/kitchen_safety_en');
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

  Widget _buildQA(String question, String answer, {String? imagePath}) {
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
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(answer, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🏡 Introduction to Home Safety"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQA("🏠 What is Home Safety?", "Home safety includes identifying hazards at home and taking action to prevent accidents.", imagePath: 'assets/home_intro_1.0.png'),
                  _buildQA("❗ Why is it Important?", "It helps protect everyone, especially kids, elderly, and people with disabilities."),
                  _buildQA("📉 Common Hazards", "Falls, burns, poisoning, fire, electrical faults, and gas leaks.", imagePath: 'assets/home_intro_1.1.png'),
                  _buildQA("🛑 Prevention Tips", "Keep walkways clear, check appliances regularly, and store chemicals safely."),
                  _buildQA("👶 Safety for Kids", "Keep dangerous items out of reach and educate children.", imagePath: 'assets/home_intro_1.2.png'),
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
              ElevatedButton(onPressed: _showQuizDialog, child: Text("Retest")),
          ],
        ),
      ),
    );
  }
}
