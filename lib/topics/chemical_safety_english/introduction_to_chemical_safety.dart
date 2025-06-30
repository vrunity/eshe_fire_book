import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/chemical_safety_english.dart';

class ChemicalIntroPage extends StatefulWidget {
  @override
  _ChemicalIntroPageState createState() => _ChemicalIntroPageState();
}

class _ChemicalIntroPageState extends State<ChemicalIntroPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ChemicalIntro";

  final Map<int, String> correctAnswers = {
    1: "To protect workers from chemical hazards.",
    2: "Skin contact, inhalation, ingestion.",
    3: "Yes, they can cause burns, poisoning, or cancer.",
    4: "By learning safe handling and emergency procedures.",
    5: "To ensure a safe and healthy workplace."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Why is chemical safety important?",
      "options": [
        "To protect workers from chemical hazards.",
        "To increase paperwork.",
        "To delay projects.",
        "To make training harder."
      ]
    },
    {
      "question": "What are common routes of chemical exposure?",
      "options": [
        "Skin contact, inhalation, ingestion.",
        "Phone calls and emails.",
        "Hearing loud noise.",
        "Sunlight and cold weather."
      ]
    },
    {
      "question": "Can chemicals cause serious health effects?",
      "options": [
        "Yes, they can cause burns, poisoning, or cancer.",
        "No, they are always safe.",
        "Only if touched.",
        "Only if mixed together."
      ]
    },
    {
      "question": "How can chemical risks be reduced?",
      "options": [
        "By ignoring them.",
        "By learning safe handling and emergency procedures.",
        "By rushing tasks.",
        "By not using chemicals."
      ]
    },
    {
      "question": "Why should workers be trained in chemical safety?",
      "options": [
        "To ensure a safe and healthy workplace.",
        "To complete tests quickly.",
        "To avoid being fired.",
        "To save time."
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
              title: Text("Quiz: Introduction to Chemical Safety"),
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
                  Navigator.pushNamed(context, '/hazard_communication_en');
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
        title: Text("Introduction to Chemical Safety"),
        backgroundColor: Colors.teal[700],
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
                  _buildQA("🧪 What is Chemical Safety?", "It involves proper handling, usage, and disposal of chemicals to prevent harm."),
                  _buildQA("📛 Hazards", "Chemicals can be toxic, flammable, corrosive, or reactive.", imagePath: 'assets/chemical_1.0.png'),
                  _buildQA("📋 Training Importance", "Workers must be educated on chemical risks and responses."),
                  _buildQA("💼 Role of Employers", "Provide safety data sheets, PPE, and training.", imagePath: 'assets/chemical_1.1.png'),
                  _buildQA("⚠️ Goal", "To prevent chemical-related injuries and illnesses."),
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
