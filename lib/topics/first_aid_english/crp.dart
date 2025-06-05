import 'package:e_she_book/english/first_aid_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CPRForAdultsPage extends StatefulWidget {
  @override
  _CPRForAdultsPageState createState() => _CPRForAdultsPageState();
}

class _CPRForAdultsPageState extends State<CPRForAdultsPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "CPRForAdults";

  final Map<int, String> correctAnswers = {
    1: "Cardiopulmonary resuscitation",
    2: "When a person has no pulse and is not breathing",
    3: "30:2",
    4: "Center of the chest",
    5: "To restore blood flow to the brain and heart",
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What does CPR stand for?",
      "options": [
        "Cardiac Pressure Response",
        "Cardiopulmonary resuscitation",
        "Chest Pump Rhythm",
        "Cardiac Pulse Rescue"
      ]
    },
    {
      "question": "When should CPR be given?",
      "options": [
        "When a person is sleepy",
        "When a person has no pulse and is not breathing",
        "When someone faints",
        "For stomach pain"
      ]
    },
    {
      "question": "What is the ratio of compressions to breaths in CPR?",
      "options": [
        "15:2",
        "5:1",
        "30:2",
        "10:10"
      ]
    },
    {
      "question": "Where should compressions be given?",
      "options": [
        "Left side of chest",
        "Over the stomach",
        "Center of the chest",
        "Back"
      ]
    },
    {
      "question": "Why is CPR important?",
      "options": [
        "To restore blood flow to the brain and heart",
        "To relax muscles",
        "To improve digestion",
        "To calm the person"
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
              title: Text("CPR"),
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
      await prefs.setString('CourseCompletedOn_First Aid', formattedDate);
      print("✅ Course completed date stored for First Aid: $formattedDate");
    }

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
            if (score > 3) // ✅ Show Next Topic only if score > 3
              TextButton(
                child: Text("Ok"),
                  onPressed: () =>  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => firstaid_english()),
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
          ),title: Text("CPR")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("💓 What is CPR?", "Cardiopulmonary resuscitation - an emergency procedure to manually preserve brain and heart function.",imagePath: 'assets/first_aid_6.0.png'),
                  _buildQuestionAnswer("💓 When is CPR needed?", "When someone is unresponsive, not breathing, or has no pulse."),
                  _buildQuestionAnswer("💓 How to check for response?", "Shake the person gently and ask loudly if they’re okay.",imagePath: 'assets/first_aid_6.1.png'),
                  _buildQuestionAnswer("💓 What is the compression to breath ratio?", "30 compressions followed by 2 rescue breaths."),
                  _buildQuestionAnswer("💓 How deep should compressions be?", "At least 2 inches (5 cm) deep on the chest.",imagePath: 'assets/first_aid_6.2.png'),
                  _buildQuestionAnswer("💓 What is the rate of compressions?", "100 to 120 compressions per minute."),
                  _buildQuestionAnswer("💓 Should you tilt the head before giving breaths?", "Yes, use head-tilt-chin-lift to open the airway.",imagePath: 'assets/first_aid_6.3.png'),
                  _buildQuestionAnswer("💓 What if you're untrained?", "Give hands-only CPR: just compressions, no breaths."),
                  _buildQuestionAnswer("💓 How long should CPR be continued?", "Until professional help arrives or the person recovers.",imagePath: 'assets/first_aid_6.4.png'),
                  _buildQuestionAnswer("💓 Can AED be used during CPR?", "Yes, use an Automated External Defibrillator as soon as available."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Take Quiz Now"),
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
