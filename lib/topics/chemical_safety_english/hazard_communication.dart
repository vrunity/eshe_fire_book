import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/chemical_safety_english.dart';

class HazardCommunicationPage extends StatefulWidget {
  @override
  _HazardCommunicationPageState createState() => _HazardCommunicationPageState();
}

class _HazardCommunicationPageState extends State<HazardCommunicationPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "HazardCommunication";

  final Map<int, String> correctAnswers = {
    1: "Hazard Communication ensures workers know about chemical hazards and safety.",
    2: "Safety Data Sheets (SDS) provide detailed chemical hazard and handling info.",
    3: "Labels identify chemical hazards and safe handling instructions.",
    4: "Training teaches how to interpret hazard labels and SDS.",
    5: "Yes, it's legally required in most workplaces."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is the purpose of Hazard Communication?",
      "options": [
        "To keep secrets",
        "Hazard Communication ensures workers know about chemical hazards and safety.",
        "To reduce costs",
        "None of the above"
      ]
    },
    {
      "question": "What does a Safety Data Sheet (SDS) contain?",
      "options": [
        "Work schedules",
        "Personal info",
        "Safety Data Sheets (SDS) provide detailed chemical hazard and handling info.",
        "Marketing content"
      ]
    },
    {
      "question": "Why are labels important in chemical safety?",
      "options": [
        "They look nice",
        "Labels identify chemical hazards and safe handling instructions.",
        "To match colors",
        "For advertising"
      ]
    },
    {
      "question": "How does training help with hazard communication?",
      "options": [
        "Improves painting skills",
        "Training teaches how to interpret hazard labels and SDS.",
        "Teaches new dances",
        "None of the above"
      ]
    },
    {
      "question": "Is hazard communication mandatory?",
      "options": [
        "No, optional",
        "Depends on company",
        "Yes, it's legally required in most workplaces.",
        "Only in labs"
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
              title: Text("Quiz: Hazard Communication"),
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
                  Navigator.pushNamed(context, '/chemical_storage_en');
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
        title: Text("Hazard Communication"),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ChemicalSafetyEnglish()),
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
                  _buildQA("📋 What is Hazard Communication?",
                      "Hazard Communication (HazCom) ensures all employees are informed about hazardous chemicals in the workplace.",
                      imagePath: "assets/chemical_2.0.png"),
                  _buildQA("📄 Safety Data Sheets (SDS)",
                      "SDS provides detailed info about a chemical including hazards, handling, storage, and emergency procedures."),
                  _buildQA("🏷️ Labels and Signs",
                      "Proper labels and warning signs are vital for identifying hazardous materials.",
                      imagePath: "assets/chemical_2.1.png"),
                  _buildQA("🎓 Training & Awareness",
                      "Training ensures employees understand chemical hazards and how to read SDS and labels."),
                  _buildQA("⚖️ Legal Requirements",
                      "HazCom standards are often regulated by government bodies like OSHA to ensure workplace safety.",
                      imagePath: "assets/chemical_2.2.png"),
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
