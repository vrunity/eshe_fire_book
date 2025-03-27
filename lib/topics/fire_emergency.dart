import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireEmergencyPage extends StatefulWidget {
  @override
  _FireEmergencyPageState createState() => _FireEmergencyPageState();
}

class _FireEmergencyPageState extends State<FireEmergencyPage> {
  bool istopic_5_Completed = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FireEmergency"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "Alert others, activate the fire alarm, and call emergency services",
    2: "Elevators can get stuck, trapping people inside",
    3: "If clothing catches fire, stop moving, drop to the ground, and roll to put it out",
    4: "Stay low to avoid smoke, signal for help, and cover nose/mouth with a cloth",
    5: "It ensures safe evacuation and prevents panic in an emergency",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What should be the first step in a fire emergency?",
      "options": [
        "Ignore the fire and continue working",
        "Alert others, activate the fire alarm, and call emergency services",
        "Run immediately without telling anyone",
        "Wait for someone else to take action"
      ]
    },
    {
      "question": "Why should you avoid using elevators during a fire?",
      "options": [
        "Elevators can get stuck, trapping people inside",
        "Elevators are fireproof",
        "They are the fastest way to evacuate",
        "None of the above"
      ]
    },
    {
      "question": "What is the stop, drop, and roll technique?",
      "options": [
        "If clothing catches fire, stop moving, drop to the ground, and roll to put it out",
        "Jump into water immediately",
        "Run in circles to put out the flames",
        "Use a fire extinguisher on yourself"
      ]
    },
    {
      "question": "What should be done if trapped in a burning building?",
      "options": [
        "Stay low to avoid smoke, signal for help, and cover nose/mouth with a cloth",
        "Break all windows and jump",
        "Wait for the fire to go out",
        "Panic and run aimlessly"
      ]
    },
    {
      "question": "Why is it important to have a fire exit plan?",
      "options": [
        "It ensures safe evacuation and prevents panic in an emergency",
        "It is only necessary for large buildings",
        "It is only required for offices",
        "It is not important at all"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadTopicCompletionStatus();
  }

  Future<void> _loadTopicCompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      istopic_5_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_5_Completed = value;
    });

    if (value) {
      Future.delayed(Duration(milliseconds: 300), () {
        _showQuizDialog();
      });
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
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Fire Emergency Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int questionIndex = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question["question"],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fire Emergency Procedures")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 What should be the first step in a fire emergency?", "Alert others, activate the fire alarm, and call emergency services."),
                  _buildQuestionAnswer("🔥 Why should you avoid using elevators during a fire?", "Elevators can get stuck, trapping people inside."),
                  _buildQuestionAnswer("🔥 What is the stop, drop, and roll technique?", "If clothing catches fire, stop moving, drop to the ground, and roll to put it out."),
                  _buildQuestionAnswer("🔥 What should be done if trapped in a burning building?", "Stay low to avoid smoke, signal for help, and cover nose/mouth with a cloth."),
                  _buildQuestionAnswer("🔥 Why is it important to have a fire exit plan?", "It ensures safe evacuation and prevents panic in an emergency."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: istopic_5_Completed,
              onChanged: (value) {
                _saveTopicCompletionStatus(value ?? false);
              },
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

  Widget _buildQuestionAnswer(String question, String answer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(answer, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
