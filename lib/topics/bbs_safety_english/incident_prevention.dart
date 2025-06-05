import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/bbs_safety_english.dart';

class IncidentPreventionPage extends StatefulWidget {
  @override
  _IncidentPreventionPageState createState() => _IncidentPreventionPageState();
}

class _IncidentPreventionPageState extends State<IncidentPreventionPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "IncidentPrevention";

  final Map<int, String> correctAnswers = {
    1: "By identifying and correcting unsafe behaviors.",
    2: "To reduce the chance of injury or damage.",
    3: "They often lead to incidents if ignored.",
    4: "Using feedback and regular observation.",
    5: "Yes, prevention is a shared responsibility."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "How does BBS help prevent incidents?",
      "options": [
        "By increasing production",
        "By hiring more staff",
        "By identifying and correcting unsafe behaviors.",
        "By buying new tools"
      ]
    },
    {
      "question": "Why should we prevent incidents?",
      "options": [
        "To reduce the chance of injury or damage.",
        "To get promotions",
        "To impress auditors",
        "To make meetings shorter"
      ]
    },
    {
      "question": "What is the risk of unsafe acts?",
      "options": [
        "Nothing serious",
        "They improve speed",
        "They often lead to incidents if ignored.",
        "They save time"
      ]
    },
    {
      "question": "How can we reduce unsafe behavior?",
      "options": [
        "Ignore it",
        "Using feedback and regular observation.",
        "Shout at people",
        "Change the shift"
      ]
    },
    {
      "question": "Is incident prevention everyone's role?",
      "options": [
        "No, only safety officers",
        "Yes, prevention is a shared responsibility.",
        "Only supervisors care",
        "It’s optional"
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
    await prefs.setBool('Completed_$topicName', true);
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
      isCompleted = true;
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
              title: Text("Quiz: Incident Prevention"),
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
              child: Text("Finish"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => BBSSafetyEnglish()),
                );
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
        title: Text("Incident Prevention"),
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
                    "🔍 Spot Unsafe Acts",
                    "BBS starts with spotting unsafe acts in the workplace. These can include shortcuts, neglecting PPE, or distractions. Identifying them early allows for immediate correction and prevents escalation.",
                    imagePath: 'assets/bbs_incident_1.png',
                  ),
                  _buildQA(
                    "🎯 Focus on Prevention",
                    "The core of BBS is to act before something goes wrong. Instead of reacting to incidents, workers are trained to anticipate risks and prevent them from happening.",

                  ),
                  _buildQA(
                    "🧠 Use Feedback",
                    "Timely and constructive feedback reinforces safe behavior. Whether it's a quick conversation or structured coaching, feedback is critical in shaping safer habits.",
                    imagePath: 'assets/bbs_incident_3.png',
                  ),
                  _buildQA(
                    "👀 Encourage Observation",
                    "Every employee can be a safety observer. BBS encourages a culture where people regularly look out for one another, raising awareness across the team.",

                  ),
                  _buildQA(
                    "🤝 Team Effort",
                    "Incident prevention is not one person’s job. It involves everyone—supervisors, workers, and leadership—working together to promote a proactive safety culture.",
                    imagePath: 'assets/bbs_incident_5.png',
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
