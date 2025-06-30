import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/home_safety_english.dart';

class KidsSafetyPage extends StatefulWidget {
  @override
  _KidsSafetyPageState createState() => _KidsSafetyPageState();
}

class _KidsSafetyPageState extends State<KidsSafetyPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "KidsSafetyHome";

  final Map<int, String> correctAnswers = {
    1: "Install safety gates, secure furniture, and use outlet covers.",
    2: "Keep sharp objects, chemicals, and medicines out of reach.",
    3: "Teach personal info, emergency numbers, and safe strangers.",
    4: "Yes, they are more curious and unaware of risks.",
    5: "Yes, regular talks and supervision are important."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "How to prevent kids from falling or injury at home?",
      "options": [
        "Install safety gates, secure furniture, and use outlet covers.",
        "Let them climb everywhere.",
        "Don’t block stairs.",
        "Leave furniture loose."
      ]
    },
    {
      "question": "What should be kept away from children?",
      "options": [
        "Keep sharp objects, chemicals, and medicines out of reach.",
        "Toys and books.",
        "Water bottles.",
        "Cushions and pillows."
      ]
    },
    {
      "question": "What should kids know for safety?",
      "options": [
        "Teach personal info, emergency numbers, and safe strangers.",
        "Just to play outside.",
        "Use social media.",
        "How to cook alone."
      ]
    },
    {
      "question": "Are kids more prone to home accidents?",
      "options": [
        "Yes, they are more curious and unaware of risks.",
        "No, they know everything.",
        "Only teenagers are at risk.",
        "Not if they are home alone."
      ]
    },
    {
      "question": "Is communication with children important?",
      "options": [
        "Yes, regular talks and supervision are important.",
        "No, they will learn themselves.",
        "Only during exams.",
        "Only if they cry."
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
              title: Text("Quiz: Kids Safety at Home"),
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
                child: Text("Finish"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
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
        title: Text("Kids Safety at Home"),
        backgroundColor: Colors.purple[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeSafetyEnglish()),
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
                  _buildQA("👶 Why is Kids Safety Important?", "Children are vulnerable to accidents and need a protected environment.", imagePath: 'assets/home_5.0.png'),
                  _buildQA("🔐 Home Proofing", "Use outlet covers, secure shelves, and lock cabinets."),
                  _buildQA("🧪 Risk Prevention", "Keep harmful items like cleaners and medicines locked.", imagePath: 'assets/home_5.1.png'),
                  _buildQA("📞 Emergency Info", "Teach kids how to call emergency numbers."),
                  _buildQA("💬 Communication", "Discuss safety rules and supervise play time.", imagePath: 'assets/home_5.2.png'),
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
