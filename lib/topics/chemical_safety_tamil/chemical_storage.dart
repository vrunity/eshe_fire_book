import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/chemical_safety_english.dart';

class ChemicalStoragePageTamil extends StatefulWidget {
  @override
  _ChemicalStoragePageTamilState createState() => _ChemicalStoragePageTamilState();
}

class _ChemicalStoragePageTamilState extends State<ChemicalStoragePageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ChemicalStorage";

  final Map<int, String> correctAnswers = {
    1: "Labels communicate hazards and proper handling instructions.",
    2: "Store acids and bases separately.",
    3: "It increases the risk of fires and spills.",
    4: "Ensure labels are clear and resistant to chemicals.",
    5: "Yes, improper storage can lead to serious accidents."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Why are labels important on chemical containers?",
      "options": [
        "To decorate bottles",
        "To confuse users",
        "Labels communicate hazards and proper handling instructions.",
        "To increase cost"
      ]
    },
    {
      "question": "How should acids and bases be stored?",
      "options": [
        "Together in one cabinet",
        "Store acids and bases separately.",
        "Next to water sources",
        "In the same bottle"
      ]
    },
    {
      "question": "What is the risk of storing chemicals improperly?",
      "options": [
        "It increases the risk of fires and spills.",
        "It keeps them fresh",
        "No risks involved",
        "They smell better"
      ]
    },
    {
      "question": "What should be ensured about labels?",
      "options": [
        "They look pretty",
        "Ensure labels are clear and resistant to chemicals.",
        "They are removed quickly",
        "They are handwritten in pencil"
      ]
    },
    {
      "question": "Can improper storage cause accidents?",
      "options": [
        "Yes, improper storage can lead to serious accidents.",
        "No, it’s always safe",
        "Only in big factories",
        "Not really"
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
              title: Text("Quiz: Chemical Storage & Labeling"),
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
                  Navigator.pushNamed(context, '/chemical_handling_ta');
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
        title: Text("Chemical Storage & Labeling (Tamil)"),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ChemicalSafetyEnglish()),
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
                  _buildQA("🏷 Proper Labeling", "Label all containers clearly to indicate contents and hazards.", imagePath: 'assets/chemical_3.0.png'),
                  _buildQA("📦 Separate Storage", "Incompatible chemicals should be stored separately to avoid reactions."),
                  _buildQA("🔥 Fire Risk", "Flammable chemicals should be stored in approved cabinets.", imagePath: 'assets/chemical_3.1.png'),
                  _buildQA("🧪 Chemical Resistance", "Use containers that are resistant to the stored chemical."),
                  _buildQA("🧻 Updated Logs", "Keep storage and usage records updated.", imagePath: 'assets/chemical_3.2.png'),
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
