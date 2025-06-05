import 'package:e_she_book/english/kids_safety_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhyKidsSafetyPage extends StatefulWidget {
  @override
  _WhyKidsSafetyPageState createState() => _WhyKidsSafetyPageState();
}

class _WhyKidsSafetyPageState extends State<WhyKidsSafetyPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "KidsIntro";

  final Map<int, String> correctAnswers = {
    1: "Kids may not recognize danger or know how to react in emergencies.",
    2: "Safety education teaches knowledge and skills to protect children.",
    3: "To prevent injuries and keep children secure.",
    4: "Yes, it helps avoid injuries and teaches safe responses.",
    5: "By giving awareness and confidence to stay safe in danger.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Why are kids more vulnerable to danger?",
      "options": [
        "Kids may not recognize danger or know how to react in emergencies.",
        "Kids always know what to do.",
        "Kids follow all safety rules.",
        "None of the above"
      ]
    },
    {
      "question": "What is the purpose of safety education for kids?",
      "options": [
        "Safety education teaches knowledge and skills to protect children.",
        "It is just an extra subject.",
        "It makes them afraid.",
        "Only useful for adults"
      ]
    },
    {
      "question": "Why is teaching safety to kids important?",
      "options": [
        "To prevent injuries and keep children secure.",
        "So they can stay home alone.",
        "Because school says so.",
        "It’s not important"
      ]
    },
    {
      "question": "Does safety education help avoid injuries?",
      "options": [
        "Yes, it helps avoid injuries and teaches safe responses.",
        "No, injuries are unavoidable.",
        "It depends on luck.",
        "Only doctors can help"
      ]
    },
    {
      "question": "How does safety education help kids?",
      "options": [
        "By giving awareness and confidence to stay safe in danger.",
        "It makes them overconfident.",
        "It replaces parenting.",
        "It teaches driving early"
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
              title: Text("Why Kids Safety? - Quiz"),
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
                  Navigator.pushNamed(context, '/stranger_danger_en'); // TODO: Replace with actual route
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF4500), Color(0xFF5B0000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => KidsSafetyEnglish()),
              );
            },
          ),title: Text("Why Kids Safety?")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🧒 Why do kids need safety education?",
                      "Kids are not always aware about the consequences of their actions, and may not know how to react in emergencies.",
                      imagePath: 'assets/kids_1.0.png'),
                  _buildQuestionAnswer("🧒 What is safety education?",
                      "Safety education is the teaching of specific knowledge, skills, and understanding that help children stay safe in dangerous situations."),
                  _buildQuestionAnswer("🧒 Why is it important to teach kids about safety?",
                      "It helps avoid injuries and keeps children safe both indoors and outdoors.",
                      imagePath: 'assets/kids_1.1.png'),
                  _buildQuestionAnswer("🧒 Can safety education prevent accidents?",
                      "Yes, by building awareness and safe behaviors in children, accidents and injuries can be significantly reduced."),
                  _buildQuestionAnswer("🧒 What is the goal of kids’ safety training?",
                      "To provide children with the tools, confidence, and awareness to react appropriately in emergencies and stay safe.",
                      imagePath: 'assets/kids_1.2.png'),
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
            if (hasTakenQuiz) Text("Last Quiz Score: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("Retest")),
          ],
        ),
      ),
    );
  }
}
