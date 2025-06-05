import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/environment_safety_english.dart';
import 'package:intl/intl.dart';

class EnergySavingAndUsagePage extends StatefulWidget {
  @override
  _EnergySavingAndUsagePageState createState() => _EnergySavingAndUsagePageState();
}

class _EnergySavingAndUsagePageState extends State<EnergySavingAndUsagePage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EnvTopic6";

  final Map<int, String> correctAnswers = {
    1: "Turn off appliances and lights when not needed.",
    2: "Energy saving reduces pollution and saves money.",
    3: "Use energy-efficient appliances and lighting.",
    4: "Unplug devices and reduce hot water usage.",
    5: "A sustainable future and lower environmental impact."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is one simple way to save energy at home?",
      "options": [
        "Leave lights on all night",
        "Turn off appliances and lights when not needed.",
        "Use heaters during summer",
        "Keep fridge doors open"
      ]
    },
    {
      "question": "Why is saving energy important?",
      "options": [
        "It increases pollution",
        "Energy saving reduces pollution and saves money.",
        "It makes bills higher",
        "It helps waste resources"
      ]
    },
    {
      "question": "What helps in saving electricity?",
      "options": [
        "Using decorative lights all day",
        "Using old appliances",
        "Use energy-efficient appliances and lighting.",
        "Running ACs with windows open"
      ]
    },
    {
      "question": "How to cut down unnecessary energy use?",
      "options": [
        "Unplug devices and reduce hot water usage.",
        "Boil water frequently",
        "Charge phones overnight always",
        "Use ovens just for heating rooms"
      ]
    },
    {
      "question": "What is the long-term benefit of saving energy?",
      "options": [
        "Higher electricity usage",
        "A sustainable future and lower environmental impact.",
        "More pollution",
        "None"
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

    // Save completion date when final topic is completed with score >= 3
    if ((prefs.getString('EnvCompletionDate') ?? "").isEmpty && isCompleted && quizScore >= 3) {
      prefs.setString('EnvCompletionDate', DateTime.now().toIso8601String());
    }
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
    if ((prefs.getString('EnvCompletionDate') ?? "").isEmpty && isCompleted && score >= 3) {
      prefs.setString('EnvCompletionDate', DateTime.now().toIso8601String());
    }
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
              title: Text("Quiz: Energy Saving & Usage"),
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

  void _evaluateQuiz() async {
    int score = 0;
    userAnswers.forEach((key, value) {
      if (correctAnswers[key] == value) {
        score++;
      }
    });

    await _saveQuizScore(score);

    if (score >= 3) {
      final String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('CourseCompletedOn_Electrical Safety', formattedDate);
      print("✅ Course completed date stored for Electrical Safety: $formattedDate");
    }

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
              onPressed: () =>  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EnvironmentalSafety()),
              ),
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
        title: Text("Energy Saving & Usage"),
        backgroundColor: Colors.green[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => EnvironmentalSafety()),
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
                  _buildQuestionAnswer("💡 Turn off devices", "Switch off lights, fans, and electronics when not in use.", imagePath: 'assets/env_5.0.png'),
                  _buildQuestionAnswer("🔋 Use energy-efficient products", "Choose LED bulbs and appliances with good ratings."),
                  _buildQuestionAnswer("🌞 Harness solar energy", "Install solar panels to reduce dependency on electricity.", imagePath: 'assets/env_5.0.png'),
                  _buildQuestionAnswer("🔌 Unplug idle electronics", "Prevent phantom power loss by unplugging unused chargers."),
                  _buildQuestionAnswer("🌍 Save energy = Save planet", "Less consumption means less pollution and better future.", imagePath: 'assets/env_5.0.png'),
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
