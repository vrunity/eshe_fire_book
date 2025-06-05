import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/bbs_safety_english.dart';

class ObservationProcessPage extends StatefulWidget {
  @override
  _ObservationProcessPageState createState() => _ObservationProcessPageState();
}

class _ObservationProcessPageState extends State<ObservationProcessPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ObservationProcess";

  final Map<int, String> correctAnswers = {
    1: "Observe behaviors during work routines.",
    2: "To identify safe and unsafe actions.",
    3: "Record what is seen objectively.",
    4: "To give constructive feedback.",
    5: "Yes, documentation helps tracking trends."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What should observers do during the BBS process?",
      "options": [
        "Observe behaviors during work routines.",
        "Avoid workers",
        "Take photos secretly",
        "Talk to supervisors only"
      ]
    },
    {
      "question": "Why do we observe employee behavior?",
      "options": [
        "To pass time",
        "To identify safe and unsafe actions.",
        "To gossip",
        "To assign blame"
      ]
    },
    {
      "question": "What should be done after observing?",
      "options": [
        "Forget it",
        "Record what is seen objectively.",
        "Complain immediately",
        "Blame the employee"
      ]
    },
    {
      "question": "Why is feedback provided after observation?",
      "options": [
        "To scold the employee",
        "To give constructive feedback.",
        "To scare workers",
        "To document issues only"
      ]
    },
    {
      "question": "Is documentation important in BBS?",
      "options": [
        "No, it's not necessary",
        "Only if there's an accident",
        "Yes, documentation helps tracking trends.",
        "Only when told"
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
              title: Text("Quiz: Observation Process"),
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
                  Navigator.pushNamed(context, '/employee_engagement_en');
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
        title: Text("Observation Process"),
        backgroundColor: Colors.blue[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BBSSafetyEnglish()),
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
                  _buildQA(
                    "👀 Behavior Monitoring",
                    "Behavior monitoring involves watching employees during routine tasks. It helps identify patterns in how tasks are approached, whether safely or unsafely.",
                    imagePath: 'assets/bbs_observe_1.png',
                  ),
                  _buildQA(
                    "✅ Spot Safe/Unsafe Acts",
                    "Recognizing both safe and unsafe behaviors is key. This helps in reinforcing good practices and correcting unsafe habits before incidents occur.",

                  ),
                  _buildQA(
                    "📝 Document Observations",
                    "Accurate documentation is critical. Observers must write what they see, not what they think happened. This keeps the data objective and reliable.",
                    imagePath: 'assets/bbs_observe_3.png',
                  ),
                  _buildQA(
                    "💬 Give Feedback",
                    "Constructive feedback helps workers improve. It should be immediate, specific, and focused on actions rather than individuals.",

                  ),
                  _buildQA(
                    "📊 Data Collection",
                    "Observation data helps identify unsafe trends and training needs. Tracking this over time allows organizations to take preventive actions.",
                    imagePath: 'assets/bbs_observe_5.png',
                  ),
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
