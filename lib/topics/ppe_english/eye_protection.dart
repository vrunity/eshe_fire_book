import 'package:e_she_book/english/ppe_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EyeProtectionPage extends StatefulWidget {
  @override
  _EyeProtectionPageState createState() => _EyeProtectionPageState();
}

class _EyeProtectionPageState extends State<EyeProtectionPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EyeProtection";

  final Map<int, String> correctAnswers = {
    1: "To protect eyes from hazards like flying particles and chemicals",
    2: "Safety goggles and face shields",
    3: "Before each use",
    4: "Ensure a snug fit and no scratches",
    5: "When there is any risk to eye safety",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Why is eye protection important?",
      "options": [
        "To enhance appearance",
        "To protect eyes from hazards like flying particles and chemicals",
        "To avoid glasses",
        "To follow fashion"
      ]
    },
    {
      "question": "What are common types of eye protection?",
      "options": [
        "Caps and helmets",
        "Masks",
        "Safety goggles and face shields",
        "Hats"
      ]
    },
    {
      "question": "When should eye PPE be inspected?",
      "options": [
        "Before each use",
        "Once a year",
        "Never",
        "Only when damaged"
      ]
    },
    {
      "question": "What is a key aspect of proper eye PPE?",
      "options": [
        "Stylish design",
        "Ensure a snug fit and no scratches",
        "Brand name",
        "Color matching outfit"
      ]
    },
    {
      "question": "When should you wear eye protection?",
      "options": [
        "Only during rain",
        "When watching TV",
        "When there is any risk to eye safety",
        "While driving"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadTopicStatus();
  }

  Future<void> _loadTopicStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCompleted = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      isCompleted = value;
    });
    if (value) {
      _showQuizDialog();
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
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Eye Protection Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int index = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question["question"],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[index],
                            onChanged: (String? value) {
                              setState(() {
                                userAnswers[index] = value!;
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
                      Navigator.of(context).pop();
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
            if (score >= 3) // ✅ Show Next Topic button only if score 3 or above
              TextButton(
                child: Text("Next Topic"),
                onPressed: () {
                  Navigator.pushNamed(context, '/respiratory_protection_en'); // <-- Your next page route
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
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 5),
            Text(answer, style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF4500), Color(0xFF5B0000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ppe_english()),
              );
            },
          ),title: Text("Eye Protection")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("👁️ What is eye protection?", "Eye protection involves using specialized PPE such as safety goggles or face shields to prevent injury from flying debris, chemicals, or light radiation.",imagePath: 'assets/ppe_3.0.png'),
                  _buildQuestionAnswer("👁️ Why is eye protection necessary?", "Eyes are sensitive and easily injured. PPE prevents damage that could cause temporary or permanent vision loss."),
                  _buildQuestionAnswer("👁️ What are common hazards to the eyes?", "Flying particles, splashes of harmful liquids, intense light or radiation, and dust.",imagePath: 'assets/ppe_3.1.png'),
                  _buildQuestionAnswer("👁️ What PPE is used for eye protection?", "Safety goggles, face shields, welding helmets, and laser safety glasses depending on the risk."),
                  _buildQuestionAnswer("👁️ How should eye PPE fit?", "It should fit snugly without obstructing vision or causing discomfort.",imagePath: 'assets/ppe_3.2.png'),
                  _buildQuestionAnswer("👁️ When should eye protection be used?", "During any activity where there’s a risk to the eyes, such as grinding, welding, or chemical handling."),
                  _buildQuestionAnswer("👁️ Can ordinary glasses replace safety goggles?", "No. Regular glasses are not impact-resistant or sealed and cannot replace certified eye protection.",imagePath: 'assets/ppe_3.3.png'),
                  _buildQuestionAnswer("👁️ How should you maintain eye PPE?", "Clean after use, store in a dry place, and inspect for scratches or damage before use."),
                  _buildQuestionAnswer("👁️ Who is responsible for eye safety?", "Both employers and employees share responsibility: providing and properly using PPE.",imagePath: 'assets/ppe_3.4.png'),
                  _buildQuestionAnswer("👁️ What should be done if eye PPE is damaged?", "It should be replaced immediately to ensure proper protection."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("Last Quiz Score: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("Retest"),
              )
          ],
        ),
      ),
    );
  }
}
