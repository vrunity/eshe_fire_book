import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstAidPage extends StatefulWidget {
  @override
  _FirstAidPageState createState() => _FirstAidPageState();
}

class _FirstAidPageState extends State<FirstAidPage> {
  bool istopic_8_Completed = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FirstAidForFireInjuries"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "தீக்காயத்தை குறைந்தது 10 நிமிடங்கள் ஓடும் குளிர்ந்த நீரில் குளிர்விக்கவும்",
    2: "இது கூடுதல் திசு சேதத்தை ஏற்படுத்தும்",
    3: "நிறுத்து, விழு, சுழற்று முறையைப் பயன்படுத்தவும் அல்லது கனமான துணியால் மூடவும்",
    4: "ஒரு கிருமிநாசினி தடவி ஸ்டெரைல் டிரெஸ்ஸிங்கால் மூடவும்",
    5: "உடனடி மருத்துவ உதவியை நாடவும் மற்றும் தீக்காயப் பகுதியைத் தொட வேண்டாம்"
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "தீக்காயங்களை சிகிச்சை செய்யும் முதல் படி என்ன?",
      "options": [
        "தீக்காயத்தை குறைந்தது 10 நிமிடங்கள் ஓடும் குளிர்ந்த நீரில் குளிர்விக்கவும்",
        "ஐஸை நேரடியாக பயன்படுத்தவும்",
        "துணியால் இறுக்கமாக கட்டவும்",
        "அதை புறக்கணிக்கவும்"
      ]
    },
    {
      "question": "ஐஸ்ஐ தீக்காயங்களில் ஏன் பயன்படுத்தக்கூடாது?",
      "options": [
        "இது கூடுதல் திசு சேதத்தை ஏற்படுத்தும்",
        "இது குணமாக உதவுகிறது",
        "உடனடி நிவாரணம் தரும்",
        "இது குளிர்ந்த நீரை விட சிறந்தது"
      ]
    },
    {
      "question": "ஒருவரின் உடை தீப்பிடித்தால் என்ன செய்ய வேண்டும்?",
      "options": [
        "நிறுத்து, விழு, சுழற்று முறையைப் பயன்படுத்தவும் அல்லது கனமான துணியால் மூடவும்",
        "பெர்ஃப்யூம் தெளிக்கவும்",
        "வேகமாக ஓடவும்",
        "தீயை அசைத்து விடவும்"
      ]
    },
    {
      "question": "சிறிய தீக்காயத்தை எப்படி சிகிச்சை செய்ய வேண்டும்?",
      "options": [
        "ஒரு கிருமிநாசினி தடவி ஸ்டெரைல் டிரெஸ்ஸிங்கால் மூடவும்",
        "அதை புறக்கணிக்கவும்",
        "டூத் பேஸ்ட் தடவவும்",
        "கிருமிநாசினி இல்லாமல் பட்டையை பயன்படுத்தவும்"
      ]
    },
    {
      "question": "கடுமையான தீக்காயத்திற்கு என்ன செய்ய வேண்டும்?",
      "options": [
        "உடனடி மருத்துவ உதவியை நாடவும் மற்றும் தீக்காயப் பகுதியைத் தொட வேண்டாம்",
        "சோப்பால் கழுவவும்",
        "வீட்டு மருந்துகளை பயன்படுத்தவும்",
        "பிளாஸ்டிக் கொண்டு மூடவும்"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadTopicCompletionStatus();
  }

  Future<void> _loadTopicCompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      istopic_8_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_8_Completed = value;
    });

    if (value) {
      Future.delayed(Duration(milliseconds: 300), () {
        _showQuizDialog();
      });
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
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("First Aid Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int questionIndex = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question["question"],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
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
              Navigator.pop(context);
            },
          ),title: Text("First Aid for Fire Injuries")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 தீக்காயங்களை சிகிச்சை செய்யும் முதல் படி என்ன?", "தீக்காயத்தை குறைந்தது 10 நிமிடங்கள் ஓடும் குளிர்ந்த நீரில் குளிர்விக்கவும்."),
                  _buildQuestionAnswer("🔥 ஐஸ்ஐ தீக்காயங்களில் ஏன் பயன்படுத்தக்கூடாது?", "இது கூடுதல் திசு சேதத்தை ஏற்படுத்தும்."),
                  _buildQuestionAnswer("🔥 ஒருவரின் உடை தீப்பிடித்தால் என்ன செய்ய வேண்டும்?", "நிறுத்து, விழு, சுழற்று முறையைப் பயன்படுத்தவும் அல்லது கனமான துணியால் மூடவும்."),
                  _buildQuestionAnswer("🔥 சிறிய தீக்காயத்தை எப்படி சிகிச்சை செய்ய வேண்டும்?", "ஒரு கிருமிநாசினி தடவி ஸ்டெரைல் டிரெஸ்ஸிங்கால் மூடவும்."),
                  _buildQuestionAnswer("🔥 கடுமையான தீக்காயத்திற்கு என்ன செய்ய வேண்டும்?", "உடனடி மருத்துவ உதவியை நாடவும் மற்றும் தீக்காயப் பகுதியைத் தொட வேண்டாம்."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: istopic_8_Completed,
              onChanged: (value) {
                _saveTopicCompletionStatus(value ?? false);
              },
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

  Widget _buildQuestionAnswer(String question, String answer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(answer, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
