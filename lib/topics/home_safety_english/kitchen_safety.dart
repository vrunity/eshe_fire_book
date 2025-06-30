import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/home_safety_english.dart';

class KitchenSafetyPage extends StatefulWidget {
  @override
  _KitchenSafetyPageState createState() => _KitchenSafetyPageState();
}

class _KitchenSafetyPageState extends State<KitchenSafetyPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "KitchenSafety";

  final Map<int, String> correctAnswers = {
    1: "Never leave cooking unattended.",
    2: "Keep flammable items away from the stove.",
    3: "Turn pot handles inward to avoid spills.",
    4: "Install fire extinguishers near kitchen exits.",
    5: "Use dry hands and dry utensils around electric appliances."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is a basic kitchen fire safety rule?",
      "options": [
        "Use candles for light.",
        "Keep the oven door open.",
        "Never leave cooking unattended.",
        "Use plastic spoons on stove."
      ]
    },
    {
      "question": "How can fire risk be reduced near the stove?",
      "options": [
        "Keep flammable items away from the stove.",
        "Use paper towels for covering food.",
        "Hang curtains near burners.",
        "Keep spices on the burner."
      ]
    },
    {
      "question": "How to avoid spills and burns from pots?",
      "options": [
        "Turn pot handles inward to avoid spills.",
        "Use large pots only.",
        "Fill to the top.",
        "Cook on high heat always."
      ]
    },
    {
      "question": "What is an important safety measure?",
      "options": [
        "Install fire extinguishers near kitchen exits.",
        "Store extinguishers in bedroom.",
        "Hide extinguishers in drawers.",
        "Don't keep one at all."
      ]
    },
    {
      "question": "What is safe when using electric appliances?",
      "options": [
        "Use dry hands and dry utensils around electric appliances.",
        "Use water to clean sockets.",
        "Pull wires when unplugging.",
        "Keep near wet sink."
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
              title: Text("Quiz: Kitchen Safety"),
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
                  Navigator.pushNamed(context, '/lpg_safety_en');
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
        title: Text("Kitchen Safety"),
        backgroundColor: Colors.redAccent,
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
                  _buildQA("🔥 Stove Safety", "Never leave cooking unattended.", imagePath: 'assets/kitchen_1.0.png'),
                  _buildQA("🧯 Prevent Fire", "Keep flammable items away from the stove."),
                  _buildQA("🍲 Handle Pots Safely", "Turn pot handles inward to avoid spills.", imagePath: 'assets/kitchen_1.1.png'),
                  _buildQA("🚨 Be Prepared", "Install fire extinguishers near kitchen exits."),
                  _buildQA("⚡ Electrical Appliances", "Use dry hands and dry utensils around electric appliances.", imagePath: 'assets/kitchen_1.2.png'),
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
