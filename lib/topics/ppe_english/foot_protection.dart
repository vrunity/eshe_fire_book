// Flutter page for Topic 7: Foot Protection
// Includes educational content, quiz, and local progress tracking

import 'package:e_she_book/english/ppe_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class FootProtectionPage extends StatefulWidget {
  @override
  _FootProtectionPageState createState() => _FootProtectionPageState();
}

class _FootProtectionPageState extends State<FootProtectionPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FootProtection";

  final Map<int, String> correctAnswers = {
    1: "To protect feet from falling objects and slips",
    2: "Safety shoes and boots",
    3: "Non-slip soles and protective toe caps",
    4: "Check for wear and tear, proper fit",
    5: "When working in environments with foot hazards",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Why is foot protection necessary?",
      "options": [
        "To walk better",
        "To protect feet from falling objects and slips",
        "To keep shoes clean",
        "For fashion purposes"
      ]
    },
    {
      "question": "What types of PPE are used for feet?",
      "options": [
        "Sandals",
        "Safety shoes and boots",
        "Slippers",
        "Barefoot"
      ]
    },
    {
      "question": "What are key features of safety footwear?",
      "options": [
        "Bright colors",
        "Soft soles",
        "Non-slip soles and protective toe caps",
        "Open toe design"
      ]
    },
    {
      "question": "How should safety footwear be maintained?",
      "options": [
        "Check for wear and tear, proper fit",
        "Polish daily",
        "Avoid cleaning",
        "Wear different shoes"
      ]
    },
    {
      "question": "When should you wear foot protection?",
      "options": [
        "Only at meetings",
        "At home",
        "When working in environments with foot hazards",
        "Only in offices"
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
    if (value) {
      _showQuizDialog();
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
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Foot Protection Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int index = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question["question"], style: TextStyle(fontWeight: FontWeight.bold)),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[index],
                            onChanged: (String? value) {
                              setState(() {
                                userAnswers[index] = value!;
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
                      Navigator.of(context).pop();
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
      await prefs.setString('CourseCompletedOn_PPE', formattedDate);
      print("✅ Course completed date stored for PPE: $formattedDate");
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
            if (score >= 3) // ✅ Show Next Topic button only if score 3 or above
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ppe_english()),
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

  Widget _buildQuestionAnswer(String question, String answer, {String? imagePath}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 5),
            Text(answer, style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Foot Protection")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🥾 What is foot protection?", "Foot protection involves wearing safety footwear to prevent injuries from falling objects, sharp items, or slippery surfaces.",imagePath: 'assets/ppe_5.0.png'),
                  _buildQuestionAnswer("🥾 Why is it important?", "Foot injuries can cause long absences and reduce mobility. Proper protection prevents such incidents."),
                  _buildQuestionAnswer("🥾 What are common foot hazards?", "Falling tools, sharp objects, hot surfaces, and chemical spills.",imagePath: 'assets/ppe_5.1.png'),
                  _buildQuestionAnswer("🥾 What types of safety footwear exist?", "Steel toe boots, slip-resistant shoes, chemical-resistant boots."),
                  _buildQuestionAnswer("🥾 Who needs foot PPE?", "Construction workers, warehouse staff, chemical handlers, and others exposed to foot hazards."),
                  _buildQuestionAnswer("🥾 How often should you inspect safety shoes?", "Before every shift to ensure no wear or damage.",imagePath: 'assets/ppe_5.2.png'),
                  _buildQuestionAnswer("🥾 Can damaged shoes still protect?", "No. They must be replaced immediately if compromised."),
                  _buildQuestionAnswer("🥾 Are sports shoes acceptable at work?", "Only if certified for safety use. Otherwise, no.",imagePath: 'assets/ppe_5.3.png'),
                  _buildQuestionAnswer("🥾 What standards apply to safety footwear?", "They must meet local or international safety certification standards like ASTM or ISI."),
                  _buildQuestionAnswer("🥾 Who provides safety footwear?", "It is typically the employer's responsibility in hazardous workplaces.",imagePath: 'assets/ppe_5.4.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("Last Quiz Score: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("Retest"),
              )
          ],
        ),
      ),
    );
  }
}
