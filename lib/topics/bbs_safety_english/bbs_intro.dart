import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/bbs_safety_english.dart';

class BBSIntroPage extends StatefulWidget {
  @override
  _BBSIntroPageState createState() => _BBSIntroPageState();
}

class _BBSIntroPageState extends State<BBSIntroPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "BBSIntro";

  final Map<int, String> correctAnswers = {
    1: "Behavior-Based Safety focuses on identifying and reinforcing safe behaviors.",
    2: "To reduce workplace incidents by promoting safer practices.",
    3: "Yes, it helps in recognizing and correcting unsafe habits.",
    4: "Observe, analyze behavior, give feedback.",
    5: "Employees, supervisors, and management."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is Behavior-Based Safety (BBS)?",
      "options": [
        "A checklist method",
        "A type of training video",
        "Behavior-Based Safety focuses on identifying and reinforcing safe behaviors.",
        "None of the above"
      ]
    },
    {
      "question": "Why is BBS implemented in workplaces?",
      "options": [
        "To increase costs",
        "To reduce workplace incidents by promoting safer practices.",
        "To reduce working hours",
        "To improve social media presence"
      ]
    },
    {
      "question": "Can BBS improve safety culture?",
      "options": [
        "No, it's ineffective",
        "Yes, it helps in recognizing and correcting unsafe habits.",
        "Only for managers",
        "Only in large companies"
      ]
    },
    {
      "question": "What are the key steps in BBS?",
      "options": [
        "Report and forget",
        "Observe, analyze behavior, give feedback.",
        "File complaints",
        "Ignore unsafe acts"
      ]
    },
    {
      "question": "Who should be involved in BBS?",
      "options": [
        "Only HR",
        "Only safety officers",
        "Employees, supervisors, and management.",
        "Outsiders"
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
              title: Text("Quiz: Introduction to BBS"),
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
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/core_principles_en');
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
        title: Text("Introduction to BBS"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BBSSafetyEnglish()),
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
                  _buildQA(
                      "🧠 What is BBS?",
                      "BBS stands for Behavior-Based Safety. It is a safety management approach that focuses on individuals' behavior and encourages safe practices through observation, feedback, and reinforcement.",
                      imagePath: 'assets/bbs_intro_1.png'
                  ),
                  _buildQA(
                      "🎯 Goal of BBS",
                      "The primary goal of BBS is to prevent workplace accidents and injuries by identifying unsafe behaviors and reinforcing safe ones before incidents occur."
                  ),
                  _buildQA(
                      "👥 Who participates?",
                      "BBS involves participation from all organizational levels — including employees, supervisors, and top management — to build a shared safety culture.",
                      imagePath: 'assets/bbs_intro_2.png'
                  ),
                  _buildQA(
                      "🔍 Observation-Based",
                      "BBS uses real-time workplace behavior observations to collect data, analyze trends, and provide immediate feedback for behavior correction."
                  ),
                  _buildQA(
                      "📈 Impact",
                      "Organizations that implement BBS often see a significant improvement in safety performance, morale, and a stronger safety-first mindset across teams.",
                      imagePath: 'assets/bbs_intro_3.png'
                  ),
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
