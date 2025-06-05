import 'package:e_she_book/english/ppe_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionToPPEPage extends StatefulWidget {
  @override
  _IntroductionToPPEPageState createState() => _IntroductionToPPEPageState();
}

class _IntroductionToPPEPageState extends State<IntroductionToPPEPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "IntroductionToPPE";

  final Map<int, String> correctAnswers = {
    1: "To protect workers from injury and illness",
    2: "Personal Protective Equipment",
    3: "Eye protection, gloves, helmets, safety shoes",
    4: "They must be used correctly and consistently",
    5: "To foster a safety-conscious work culture",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is the main purpose of PPE?",
      "options": [
        "To decorate the uniform",
        "To protect workers from injury and illness",
        "To make employees look professional",
        "To avoid wearing casuals"
      ]
    },
    {
      "question": "What does PPE stand for?",
      "options": [
        "Professional Protection Equipment",
        "Personal Protective Equipment",
        "Private Protection Essentials",
        "Public Protective Environment"
      ]
    },
    {
      "question": "Which of the following is a type of PPE?",
      "options": [
        "Smartwatch",
        "Leather belt",
        "Eye protection, gloves, helmets, safety shoes",
        "ID card"
      ]
    },
    {
      "question": "Why is training on PPE usage important?",
      "options": [
        "They must be used correctly and consistently",
        "Because it’s a rule",
        "To reduce clothing costs",
        "To make a good impression"
      ]
    },
    {
      "question": "Why should a safety culture be promoted?",
      "options": [
        "To boost sales",
        "To increase meetings",
        "To foster a safety-conscious work culture",
        "To avoid uniforms"
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
              title: Text("Introduction to PPE Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int index = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question["question"],
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
            if (score >= 3) // ✅ Show Next Topic only if score > 3
              TextButton(
                child: Text("Next Topic"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/head_protection_en'); // Navigate to next topic page
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
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove shadow for clean UI
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF4500), Color(0xFF5B0000)], // Red to Dark Maroon
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28), // Back Arrow
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ppe_english()),
              );
            },
          ),title: Text("Introduction to PPE")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("👷 What is PPE?",
                      "PPE stands for Personal Protective Equipment. It includes items like gloves, goggles, helmets, and safety shoes that protect workers from injury or illness.",imagePath: 'assets/ppe_1.0.png'),

                  _buildQuestionAnswer("👷 Why is PPE important?",
                      "PPE reduces the risk of exposure to hazards such as chemicals, falling objects, sharp edges, and noise."),

                  _buildQuestionAnswer("👷 Who should use PPE?",
                      "All individuals working in hazardous environments should use PPE as per safety standards and company policy.",imagePath: 'assets/ppe_1.1.png'),

                  _buildQuestionAnswer("👷 Is PPE alone enough to ensure safety?",
                      "No. PPE is a last line of defense and should be used in combination with training, engineering controls, and safety procedures."),

                  _buildQuestionAnswer("👷 What are the main types of PPE?",
                      "Head protection, eye and face protection, hearing protection, respiratory protection, hand protection, foot protection, and body protection.",imagePath: 'assets/ppe_1.2.png'),

                  _buildQuestionAnswer("👷 How do you select the right PPE?",
                      "PPE should be selected based on the specific hazards present in the work environment, and should fit properly and be comfortable."),

                  _buildQuestionAnswer("👷 What is the role of employers in PPE?",
                      "Employers must provide suitable PPE, ensure it is maintained, and train employees on proper usage."),

                  _buildQuestionAnswer("👷 What responsibilities do employees have regarding PPE?",
                      "Employees must use PPE correctly, take care of it, and report any defects or issues to their supervisor."),

                  _buildQuestionAnswer("👷 Can PPE be shared among workers?",
                      "PPE should ideally not be shared. If shared, it must be properly cleaned and sanitized before use.",imagePath: 'assets/ppe_1.3.png'),

                  _buildQuestionAnswer("👷 How often should PPE be inspected?",
                      "PPE should be inspected before each use and regularly maintained as per manufacturer guidelines."),
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
