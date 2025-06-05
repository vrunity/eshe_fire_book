import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/bbs_safety_english.dart';

class CorePrinciplesPage extends StatefulWidget {
  @override
  _CorePrinciplesPageState createState() => _CorePrinciplesPageState();
}

class _CorePrinciplesPageState extends State<CorePrinciplesPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "CorePrinciples";

  final Map<int, String> correctAnswers = {
    1: "BBS relies on observation and feedback to correct unsafe behavior.",
    2: "Positive reinforcement encourages safe actions.",
    3: "BBS is proactive, focusing on behavior before incidents.",
    4: "It involves employees at all levels in safety improvement.",
    5: "Yes, it empowers workers to own safety outcomes."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What does BBS rely on to improve safety?",
      "options": [
        "Punishment",
        "Rules alone",
        "BBS relies on observation and feedback to correct unsafe behavior.",
        "Safety posters"
      ]
    },
    {
      "question": "Why is positive reinforcement important in BBS?",
      "options": [
        "To reduce salary",
        "Positive reinforcement encourages safe actions.",
        "To monitor attendance",
        "To discipline workers"
      ]
    },
    {
      "question": "Is BBS proactive or reactive?",
      "options": [
        "Reactive after accidents",
        "Only in emergencies",
        "BBS is proactive, focusing on behavior before incidents.",
        "It's a reactive method"
      ]
    },
    {
      "question": "Who is involved in BBS implementation?",
      "options": [
        "Only the manager",
        "It involves employees at all levels in safety improvement.",
        "Just safety officers",
        "Visitors"
      ]
    },
    {
      "question": "Does BBS promote ownership of safety?",
      "options": [
        "No, it removes responsibility",
        "Yes, it empowers workers to own safety outcomes.",
        "Only for top level",
        "Depends on location"
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
              title: Text("Quiz: Core BBS Principles"),
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
                  Navigator.pushNamed(context, '/observation_process_en');
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
        title: Text("Core BBS Principles"),
        backgroundColor: Colors.blue[700],
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
                    "🔍 Observation & Feedback",
                    "In BBS, observing how employees perform tasks and providing constructive feedback is critical. This helps identify unsafe habits and encourages safer alternatives.",
                    imagePath: 'assets/bbs_core_1.png',
                  ),
                  _buildQA(
                    "🎁 Reinforcement",
                    "BBS promotes the use of positive reinforcement — acknowledging and rewarding safe behaviors — to motivate employees and build lasting safety habits.",

                  ),
                  _buildQA(
                    "🛡️ Proactive Safety",
                    "Instead of reacting to incidents, BBS takes a proactive stance. It seeks to prevent accidents by analyzing behavior trends and adjusting practices early.",
                    imagePath: 'assets/bbs_core_3.png',
                  ),
                  _buildQA(
                    "🤝 Employee Involvement",
                    "A successful BBS system includes all employees — from top management to frontline workers — in observations, discussions, and improvement efforts.",

                  ),
                  _buildQA(
                    "📌 Accountability",
                    "Each worker is empowered and responsible for their safety and the safety of others. BBS encourages self-correction and peer involvement.",
                    imagePath: 'assets/bbs_core_5.png',
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
