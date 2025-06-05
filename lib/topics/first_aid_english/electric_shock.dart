import 'package:e_she_book/english/first_aid_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElectricShockPage extends StatefulWidget {
  @override
  _ElectricShockPageState createState() => _ElectricShockPageState();
}

class _ElectricShockPageState extends State<ElectricShockPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ElectricShock";

  final Map<int, String> correctAnswers = {
    1: "Disruption caused by electricity passing through the body",
    2: "Turn off power source before touching victim",
    3: "Wooden stick, plastic object or dry cloth",
    4: "Burns, unconsciousness, or cardiac arrest",
    5: "Call emergency services and begin CPR if needed",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is electric shock?",
      "options": [
        "Static energy",
        "Disruption caused by electricity passing through the body",
        "Battery failure",
        "A type of cold sensation"
      ]
    },
    {
      "question": "What is the first step when someone is electrocuted?",
      "options": [
        "Touch them immediately",
        "Turn off power source before touching victim",
        "Throw water",
        "Shake them awake"
      ]
    },
    {
      "question": "What is safe to use when separating the victim from electricity?",
      "options": [
        "Metal rod",
        "Wet rope",
        "Wooden stick, plastic object or dry cloth",
        "Your hands"
      ]
    },
    {
      "question": "What injuries can result from electric shock?",
      "options": [
        "Burns, unconsciousness, or cardiac arrest",
        "Only a rash",
        "Mild fever",
        "None at all"
      ]
    },
    {
      "question": "What should you do after removing the person from source?",
      "options": [
        "Leave them alone",
        "Call emergency services and begin CPR if needed",
        "Take a photo",
        "Wait for someone else to help"
      ]
    }
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
              title: Text("Electric Shock Quiz"),
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
                  Navigator.pushNamed(context, '/cpr_for_adults_en'); // Navigate to next topic page
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
          ),title: Text("Electric Shock")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("⚡ What is electric shock?", "It is a physiological reaction caused when electric current passes through the body.",imagePath: 'assets/first_aid_5.0.png'),
                  _buildQuestionAnswer("⚡ What is the first action to take?", "Turn off the power source before touching the victim."),
                  _buildQuestionAnswer("⚡ What can be used to separate a victim from power?", "Non-conductive items like a wooden stick or dry cloth.",imagePath: 'assets/first_aid_5.1.png'),
                  _buildQuestionAnswer("⚡ Can electric shock cause burns?", "Yes, and also cardiac arrest or unconsciousness."),
                  _buildQuestionAnswer("⚡ Should you call for medical help?", "Yes, and begin CPR if the person isn’t breathing.",imagePath: 'assets/first_aid_5.2.png'),
                  _buildQuestionAnswer("⚡ What symptoms may follow an electric shock?", "Difficulty breathing, irregular heartbeat, burns, numbness."),
                  _buildQuestionAnswer("⚡ Should water be used during rescue?", "No, water conducts electricity and increases risk.",imagePath: 'assets/first_aid_5.3.png'),
                  _buildQuestionAnswer("⚡ Can clothing be removed?", "Yes, if it’s smoldering, but not if it’s stuck to the burn."),
                  _buildQuestionAnswer("⚡ What should be avoided?", "Never touch the person directly until the power is off.",imagePath: 'assets/first_aid_5.4.png'),
                  _buildQuestionAnswer("⚡ Is it safe to leave the person alone?", "No, monitor breathing and provide reassurance until help arrives."),
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
