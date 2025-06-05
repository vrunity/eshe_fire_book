import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/environment_safety_english.dart';

class EnvironmentalPollutionTypesPage extends StatefulWidget {
  @override
  _EnvironmentalPollutionTypesPageState createState() => _EnvironmentalPollutionTypesPageState();
}

class _EnvironmentalPollutionTypesPageState extends State<EnvironmentalPollutionTypesPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EnvTopic3";

  final Map<int, String> correctAnswers = {
    1: "Air, water, soil, noise, thermal, radioactive, and personal pollution",
    2: "Air pollution occurs when harmful substances contaminate the air.",
    3: "Soil pollution happens due to waste, chemicals, and poor farming.",
    4: "Noise pollution includes loud and disturbing sounds.",
    5: "Thermal pollution is due to heat discharge from factories."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What are the main types of environmental pollution?",
      "options": [
        "Air, water, soil, noise, thermal, radioactive, and personal pollution",
        "Only air and water",
        "Plastic and paper",
        "Rain and sunlight"
      ]
    },
    {
      "question": "What is air pollution?",
      "options": [
        "Pollution in playgrounds",
        "Air pollution occurs when harmful substances contaminate the air.",
        "Clean air with perfume",
        "Cold air movement"
      ]
    },
    {
      "question": "How does soil pollution occur?",
      "options": [
        "From too many trees",
        "From clean farming",
        "Soil pollution happens due to waste, chemicals, and poor farming.",
        "From cloudy weather"
      ]
    },
    {
      "question": "What is noise pollution?",
      "options": [
        "Whispering sounds",
        "Soft music in homes",
        "Noise pollution includes loud and disturbing sounds.",
        "Bird chirping"
      ]
    },
    {
      "question": "What causes thermal pollution?",
      "options": [
        "Cooling from ice",
        "Thermal pollution is due to heat discharge from factories.",
        "Cold rains",
        "Winter season"
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
              title: Text("Quiz: Types of Pollution"),
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
                  Navigator.pushNamed(context, '/daily_and_eating_habits_en'); // update to next route
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
        title: Text("Environmental Pollution Types"),
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
                  _buildQuestionAnswer("🌫 What is air pollution?", "Contamination of air by harmful gases and particles.", imagePath: 'assets/env_3.0.png'),
                  _buildQuestionAnswer("💧 What is water pollution?", "Harmful substances affecting rivers, lakes, and oceans."),
                  _buildQuestionAnswer("🌱 What is soil pollution?", "Dumping chemicals, waste, or using bad farming techniques.", imagePath: 'assets/env_3.1.png'),
                  _buildQuestionAnswer("🔊 What is noise pollution?", "Disturbing and loud sounds affecting humans and animals."),
                  _buildQuestionAnswer("🔥 What is thermal pollution?", "Heat discharge from power plants that disturbs ecosystems.", imagePath: 'assets/env_3.2.png'),
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
