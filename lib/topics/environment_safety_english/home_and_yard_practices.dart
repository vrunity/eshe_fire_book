import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/environment_safety_english.dart';
import 'package:intl/intl.dart';

class HomeAndYardPracticesPage extends StatefulWidget {
  @override
  _HomeAndYardPracticesPageState createState() => _HomeAndYardPracticesPageState();
}

class _HomeAndYardPracticesPageState extends State<HomeAndYardPracticesPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EnvTopic5";

  final Map<int, String> correctAnswers = {
    1: "Use LED bulbs and insulate your home properly.",
    2: "Install solar panels and energy-saving appliances.",
    3: "Plant trees around your house to save energy.",
    4: "Avoid chemical pesticides and fertilizers.",
    5: "Create a compost area for biodegradable waste."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is one way to reduce electricity use at home?",
      "options": [
        "Keep lights on all day",
        "Use LED bulbs and insulate your home properly.",
        "Use old appliances",
        "Leave fans running"
      ]
    },
    {
      "question": "How can solar panels help at home?",
      "options": [
        "They increase electricity bills",
        "They are decorative",
        "Install solar panels and energy-saving appliances.",
        "They only work at night"
      ]
    },
    {
      "question": "How does planting trees around your house help?",
      "options": [
        "Blocks fresh air",
        "Attracts insects",
        "Increases power usage",
        "Plant trees around your house to save energy."
      ]
    },
    {
      "question": "How can we keep our yard eco-friendly?",
      "options": [
        "Avoid chemical pesticides and fertilizers.",
        "Use plastic decorations",
        "Spray toxic chemicals often",
        "Install bright decorative lights"
      ]
    },
    {
      "question": "What can be done with biodegradable yard waste?",
      "options": [
        "Throw in the river",
        "Burn it",
        "Create a compost area for biodegradable waste.",
        "Store it indoors"
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
              title: Text("Quiz: Home & Yard Practices"),
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
      await prefs.setString('CourseCompletedOn_Environmental Safety', formattedDate);
      print("✅ Course completed date stored for Environmental Safety: $formattedDate");
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
        title: Text("Home & Yard Practices"),
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
                  _buildQuestionAnswer("💡 Efficient Lighting", "Use LED bulbs and turn off lights when not needed.", imagePath: 'assets/env_5.0.png'),
                  _buildQuestionAnswer("🏡 Energy Smart Home", "Insulate your house and use solar energy if possible."),
                  _buildQuestionAnswer("🌳 Greening Your Yard", "Plant trees to provide shade and reduce cooling needs.", imagePath: 'assets/env_5.1.png'),
                  _buildQuestionAnswer("🚫 Avoid Harmful Chemicals", "Use natural alternatives to chemical pesticides."),
                  _buildQuestionAnswer("🌱 Composting", "Create compost from organic kitchen and yard waste.", imagePath: 'assets/env_5.2.png'),
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

