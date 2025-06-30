import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/home_safety_english.dart';

class ElectricalSafetyPage extends StatefulWidget {
  @override
  _ElectricalSafetyPageState createState() => _ElectricalSafetyPageState();
}

class _ElectricalSafetyPageState extends State<ElectricalSafetyPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "HomeElectricalSafety";

  final Map<int, String> correctAnswers = {
    1: "Avoid using wet hands or water around electrical devices.",
    2: "Install circuit breakers and use insulated tools.",
    3: "Avoid overloading and use the correct fuse rating.",
    4: "Yes, frayed or cracked cords can lead to fire or shock.",
    5: "Check appliance condition and follow manufacturer guidelines."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "How can we stay safe from electric shock at home?",
      "options": [
        "Avoid using wet hands or water around electrical devices.",
        "Use wet clothes to clean sockets.",
        "Always keep devices plugged in.",
        "Touch wires directly."
      ]
    },
    {
      "question": "What are basic electrical safety practices?",
      "options": [
        "Install circuit breakers and use insulated tools.",
        "Connect multiple devices to a single plug.",
        "Ignore sparks from sockets.",
        "Use metal objects inside sockets."
      ]
    },
    {
      "question": "How to prevent overheating or fire from electrical sources?",
      "options": [
        "Avoid overloading and use the correct fuse rating.",
        "Plug all devices into one outlet.",
        "Use damaged cords freely.",
        "Cover wires with cloth."
      ]
    },
    {
      "question": "Are damaged wires dangerous?",
      "options": [
        "Yes, frayed or cracked cords can lead to fire or shock.",
        "No, they work just fine.",
        "Only if they are too old.",
        "Only if touched directly."
      ]
    },
    {
      "question": "What is the safe use of appliances?",
      "options": [
        "Check appliance condition and follow manufacturer guidelines.",
        "Ignore user manuals.",
        "Keep appliances on all the time.",
        "Substitute parts randomly."
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
              title: Text("Quiz: Electrical Safety"),
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
                  Navigator.pushNamed(context, '/kids_safety_home_en');
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
        title: Text("Electrical Safety"),
        backgroundColor: Colors.red[700],
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
                  _buildQA("⚡ What is Electrical Safety?", "Using electricity safely to prevent shocks, fires, or damage.", imagePath: 'assets/home_4.0.png'),
                  _buildQA("🔌 Shock Prevention", "Avoid using devices with wet hands and inspect for damaged cords."),
                  _buildQA("🧰 Safety Tips", "Use circuit breakers, check wires, and don't overload sockets.", imagePath: 'assets/home_4.1.png'),
                  _buildQA("⚠️ Common Dangers", "Overloaded plugs, exposed wires, and faulty devices."),
                  _buildQA("📋 Appliance Care", "Follow manual guidelines and use rated plugs and sockets.", imagePath: 'assets/home_4.2.png'),
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
