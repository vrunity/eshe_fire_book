import 'package:e_she_book/english/first_aid_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionToFirstAidPage extends StatefulWidget {
  @override
  _IntroductionToFirstAidPageState createState() => _IntroductionToFirstAidPageState();
}

class _IntroductionToFirstAidPageState extends State<IntroductionToFirstAidPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "IntroductionToFirstAid";

  final Map<int, String> correctAnswers = {
    1: "Immediate care given before professional help arrives",
    2: "Preserve life, prevent worsening, promote recovery",
    3: "Anyone with basic knowledge and willingness",
    4: "Yes, especially in emergencies before help arrives",
    5: "Stay calm, assess situation, ensure safety",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is First Aid?",
      "options": [
        "A final medical treatment",
        "Immediate care given before professional help arrives",
        "Only CPR",
        "Hospital emergency care"
      ]
    },
    {
      "question": "What are the objectives of First Aid?",
      "options": [
        "Preserve life, prevent worsening, promote recovery",
        "Call ambulance only",
        "Provide medication",
        "Make the person unconscious"
      ]
    },
    {
      "question": "Who can give First Aid?",
      "options": [
        "Only doctors",
        "Police",
        "Anyone with basic knowledge and willingness",
        "No one without license"
      ]
    },
    {
      "question": "Is First Aid helpful in daily life?",
      "options": [
        "No",
        "Only in hospitals",
        "Yes, especially in emergencies before help arrives",
        "Only trained doctors"
      ]
    },
    {
      "question": "What should be done before giving First Aid?",
      "options": [
        "Run away",
        "Call the media",
        "Stay calm, assess situation, ensure safety",
        "Take photos"
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
              title: Text("Introduction to First Aid Quiz"),
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

  void _evaluateQuiz() {
    int score = 0;
    userAnswers.forEach((key, value) {
      if (correctAnswers[key] == value) score++;
    });
    _saveQuizScore(score);
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
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score > 3) // ✅ Show Next Topic only if score > 3
              TextButton(
                child: Text("Next Topic"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/bleeding_control_en'); // Navigate to next topic page
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => firstaid_english()),
            );
          },
        ),
        title: const Text("Introduction to First Aid"),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🩹 What is First Aid?", "It is the immediate help given to someone who is injured or suddenly ill before professional medical help is available.",imagePath: 'assets/first_aid_1.0.png'),
                  _buildQuestionAnswer("🎯 What are the objectives of First Aid?", "Preserve life, prevent the condition from worsening, and promote recovery."),
                  _buildQuestionAnswer("👥 Who can provide First Aid?", "Anyone who has basic training or knowledge, including bystanders.",imagePath: 'assets/first_aid_1.1.png'),
                  _buildQuestionAnswer("🏠 Is First Aid important in daily life?", "Yes. It helps manage accidents at home, work, school, or public places before help arrives."),
                  _buildQuestionAnswer("🧠 What should you do before giving First Aid?", "Stay calm, check surroundings for danger, assess the person’s condition, and call for help.",imagePath: 'assets/first_aid_1.2.png'),
                  _buildQuestionAnswer("🧰 What is included in a First Aid Kit?", "Basic supplies such as bandages, antiseptic wipes, scissors, gloves, and CPR face shield."),
                  _buildQuestionAnswer("🧪 What is the golden hour in First Aid?", "It refers to the first hour after a traumatic injury when prompt care can improve survival.",imagePath: 'assets/first_aid_1.3.png'),
                  _buildQuestionAnswer("📞 Should you call emergency services even if injury looks minor?", "Yes, if you're unsure. It's better to have professionals assess the situation."),
                  _buildQuestionAnswer("💉 Can First Aid include CPR and bleeding control?", "Yes, First Aid covers basic life support, bleeding control, and more.",imagePath: 'assets/first_aid_1.4.png'),
                  _buildQuestionAnswer("🚨 Why is First Aid training important for everyone?", "Because accidents can happen anytime, and trained individuals can save lives before help arrives."),
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
