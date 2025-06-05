import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/bbs_safety_english.dart';

class EmployeeEngagementPage extends StatefulWidget {
  @override
  _EmployeeEngagementPageState createState() => _EmployeeEngagementPageState();
}

class _EmployeeEngagementPageState extends State<EmployeeEngagementPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EmployeeEngagement";

  final Map<int, String> correctAnswers = {
    1: "Involve them in safety conversations and observations.",
    2: "It builds ownership and accountability.",
    3: "By recognizing and appreciating safe behavior.",
    4: "Peer-to-peer involvement and mentoring.",
    5: "Yes, participation improves safety outcomes."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "How can we engage employees in BBS?",
      "options": [
        "Avoid them",
        "Only report mistakes",
        "Involve them in safety conversations and observations.",
        "Assign extra work"
      ]
    },
    {
      "question": "Why is engagement important?",
      "options": [
        "It creates fear",
        "It builds ownership and accountability.",
        "It reduces tasks",
        "It adds confusion"
      ]
    },
    {
      "question": "How to encourage positive behavior?",
      "options": [
        "Ignore it",
        "By recognizing and appreciating safe behavior.",
        "Punish often",
        "Avoid feedback"
      ]
    },
    {
      "question": "What promotes employee participation?",
      "options": [
        "Isolation",
        "Strict rules only",
        "Peer-to-peer involvement and mentoring.",
        "Solo work"
      ]
    },
    {
      "question": "Does engagement improve safety?",
      "options": [
        "Yes, participation improves safety outcomes.",
        "No, it wastes time",
        "Only sometimes",
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
              title: Text("Quiz: Employee Engagement"),
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
                  Navigator.pushNamed(context, '/incident_prevention_en');
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
        title: Text("Employee Engagement"),
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
                    "👥 Involve Everyone",
                    "In Behavior-Based Safety (BBS), everyone — from senior leadership to line workers — should be actively involved in conversations and decision-making related to safety. Inclusion increases trust and commitment.",
                    imagePath: 'assets/bbs_engage_1.0.png',
                  ),
                  _buildQA(
                    "💡 Encourage Participation",
                    "Allow employees to observe work processes, report near misses, and suggest improvements. This empowers them and creates shared responsibility for safety.",

                  ),
                  _buildQA(
                    "👏 Recognize Efforts",
                    "Acknowledging and celebrating safe behavior builds morale and reinforces good practices. A simple 'thank you' or visual reward can go a long way.",
                    imagePath: 'assets/bbs_engage_3.png',
                  ),
                  _buildQA(
                    "🔄 Peer Learning",
                    "Enable employees to share experiences, mentor one another, and reflect on incidents as a team. Peer-to-peer feedback is often more effective than top-down corrections.",

                  ),
                  _buildQA(
                    "📣 Boost Morale",
                    "When employees see their input is valued and acted upon, their morale improves. A strong sense of purpose directly correlates with safer behavior and better results.",
                    imagePath: 'assets/bbs_engage_5.png',
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
