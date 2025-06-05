import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/construction_safety_english.dart';

class ToolsHandlingPage extends StatefulWidget {
  @override
  _ToolsHandlingPageState createState() => _ToolsHandlingPageState();
}

class _ToolsHandlingPageState extends State<ToolsHandlingPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ToolsHandling";

  final Map<int, String> correctAnswers = {
    1: "Manual handling means lifting, carrying, or moving items by hand.",
    2: "By bending knees, keeping back straight, and using both hands.",
    3: "Injuries like sprains, strains, and back pain.",
    4: "Tools should be inspected, maintained, and used properly.",
    5: "Loose clothes, wet hands, and distractions.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is manual handling?",
      "options": [
        "Manual handling means lifting, carrying, or moving items by hand.",
        "Typing on computer.",
        "Working with cement.",
        "Painting walls."
      ]
    },
    {
      "question": "How to lift heavy objects safely?",
      "options": [
        "By bending knees, keeping back straight, and using both hands.",
        "By bending the back fully.",
        "With a single hand quickly.",
        "By asking someone else always."
      ]
    },
    {
      "question": "What injuries can occur from poor manual handling?",
      "options": [
        "Injuries like sprains, strains, and back pain.",
        "Headache.",
        "Toothache.",
        "Hearing loss."
      ]
    },
    {
      "question": "How should tools be handled?",
      "options": [
        "Tools should be inspected, maintained, and used properly.",
        "Used as toys.",
        "Lent to friends.",
        "Thrown after use."
      ]
    },
    {
      "question": "What should be avoided during tool use?",
      "options": [
        "Loose clothes, wet hands, and distractions.",
        "Wearing gloves.",
        "Safety goggles.",
        "Focus and care."
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
              title: Text("Tools Handling Quiz"),
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
                  Navigator.pushNamed(context, '/working_at_height_en');
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
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imagePath, fit: BoxFit.cover, height: 180, width: double.infinity),
              ),
            if (imagePath != null) SizedBox(height: 10),
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 6),
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
        elevation: 0, // Remove shadow for clean UI
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF4500), Color(0xFF5B0000)], // Red to Dark Maroon
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28), // Back Arrow
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ConstructionSafetyEnglish()),
            );
          },
        ),
        title: Text("Tools & Lifting Safety"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("📦 What is manual handling?", "Lifting, carrying or moving things by hand.", imagePath: 'assets/construction_3.0.png'),
                  _buildQuestionAnswer("🧍 How to lift correctly?", "Keep straight back, bend knees, lift slowly."),
                  _buildQuestionAnswer("💢 What injuries may happen?", "Back injuries, sprains, or strains.", imagePath: 'assets/construction_3.1.png'),
                  _buildQuestionAnswer("🔧 Tool safety?", "Check condition, use tools as intended."),
                  _buildQuestionAnswer("❌ Avoid what?", "Loose clothes, wet hands, distractions.", imagePath: 'assets/construction_3.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: isCompleted,
              onChanged: (value) {
                _saveTopicCompletion(value ?? false);
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
