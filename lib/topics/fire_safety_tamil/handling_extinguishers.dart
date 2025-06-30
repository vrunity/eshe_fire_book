import 'package:e_she_book/tamil/fire_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HandlingExtinguishersPage extends StatefulWidget {
  @override
  _HandlingExtinguishersPageState createState() =>
      _HandlingExtinguishersPageState();
}

class _HandlingExtinguishersPageState extends State<HandlingExtinguishersPage> {
  bool istopic_6_Completed = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "HandlingExtinguishers"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "ஒவ்வொரு முறையும் பயன்படுத்திய பிறகு, முழுவதும் காலியாகவில்லை என்றாலும்",
    2: "அணுகக்கூடிய இடத்தில், சுவற்றில் மாட்டப்பட்டு, நேரடி வெப்பத்திலிருந்து விலக்கி",
    3: "மருத்துவக் காற்றழுத்தம், கசியல் அல்லது காலாவதியான ரசாயனங்களை பரிசோதிக்க",
    4: "உடனடியாக மாற்றவும் அல்லது சேவையளிக்கவும்",
    5: "அனைத்து ஊழியர்களும் மற்றும் வீட்டு உறுப்பினர்களும்"
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "தீ அணைப்பான் எப்போது நிரப்பப்பட வேண்டும்?",
      "options": [
        "வருடத்தில் ஒரு முறை",
        "முழுவதும் காலியாகிய பிறகு மட்டும்",
        "ஒவ்வொரு முறையும் பயன்படுத்திய பிறகு, முழுவதும் காலியாகவில்லை என்றாலும்",
        "பராமரிப்பு பரிசோதனைகளின் போது மட்டும்"
      ]
    },
    {
      "question": "தீ அணைப்பான் எங்கே வைக்கப்பட வேண்டும்?",
      "options": [
        "அணுகக்கூடிய இடத்தில், சுவற்றில் மாட்டப்பட்டு, நேரடி வெப்பத்திலிருந்து விலக்கி",
        "பூட்டிய அலமாரியில்",
        "வெப்பமான இடத்திற்கு அருகில்",
        "நிலத்தில், மக்களுக்கு தொலைவில்"
      ]
    },
    {
      "question": "தீ அணைப்பான்களை ஏன் தவிர்க்க முடியாத பரிசோதனை செய்ய வேண்டும்?",
      "options": [
        "மருத்துவக் காற்றழுத்தம், கசியல் அல்லது காலாவதியான ரசாயனங்களை பரிசோதிக்க",
        "சரியான இடத்தில் இருக்கிறதா என்பதை மட்டும் உறுதிசெய்ய",
        "சட்டப்படி தேவைப்படுவதால்",
        "பரிசோதனை தேவையில்லை"
      ]
    },
    {
      "question": "தீ அணைப்பான் பழுதடைந்தால் என்ன செய்ய வேண்டும்?",
      "options": [
        "உடனடியாக மாற்றவும் அல்லது சேவையளிக்கவும்",
        "பழுது இருந்தாலும் பயன்படுத்தவும்",
        "முழுவதும் காலியாகும் வரை பயன்படுத்தவும்",
        "பாதுகாப்பாக வைக்கவும், பயன்படுத்த வேண்டாம்"
      ]
    },
    {
      "question": "தீ அணைப்பானை பயன்படுத்த யார் பயிற்சி பெற வேண்டும்?",
      "options": [
        "வழக்கமான தீயணைப்பு ஊழியர்கள் மட்டும்",
        "பயிற்சி பெற்ற நிபுணர்கள் மட்டும்",
        "அனைத்து ஊழியர்களும் மற்றும் வீட்டு உறுப்பினர்களும்",
        "அவசர சேவைபுரியவர்கள் மட்டும்"
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
      istopic_6_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_6_Completed = value;
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
              title: Text("Handling Fire Extinguishers Quiz"),
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
                  child: Text("சமர்ப்பிக்கவும்"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("தயவுசெய்து அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
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
          title: Text("வினாடி வினா முடிவு"),
          content: Text("You scored $score out of ${quizQuestions.length}."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score > 3) // ✅ Show Next Topic only if score > 3
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/industrial_safety_ta'); // Navigate to next topic page
                },
              ),
            TextButton(
              child: Text("மீண்டும் முயற்சி"),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => fire_safety_tamil()),
              );
            },
          ),
          title: Text("தீ அணைப்பான்கள் கையாளும் முறை")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 தீ அணைப்பான் எப்போது நிரப்பப்பட வேண்டும்?", "ஒவ்வொரு முறையும் பயன்படுத்திய பிறகு, முழுவதும் காலியாகவில்லை என்றாலும்.",imagePath: 'assets/banner_6.1.jpg'),
                  _buildQuestionAnswer("🔥 தீ அணைப்பான் எங்கே வைக்கப்பட வேண்டும்?", "அணுகக்கூடிய இடத்தில், சுவற்றில் மாட்டப்பட்டு, நேரடி வெப்பத்திலிருந்து விலக்கி."),
                  _buildQuestionAnswer("🔥 தீ அணைப்பான்களை ஏன் பரிசோதிக்க வேண்டும்?", "மருத்துவக் காற்றழுத்தம், கசியல் அல்லது காலாவதியான ரசாயனங்களை பரிசோதிக்க.",imagePath: 'assets/banner_6.2.jpg'),
                  _buildQuestionAnswer("🔥 தீ அணைப்பான் பழுதடைந்தால் என்ன செய்ய வேண்டும்?", "உடனடியாக மாற்றவும் அல்லது சேவையளிக்கவும்."),
                  _buildQuestionAnswer("🔥 யார் தீ அணைப்பானைப் பயன்படுத்த பயிற்சி பெற வேண்டும்?", "அனைத்து ஊழியர்களும் மற்றும் வீட்டு உறுப்பினர்களும்.",imagePath: 'assets/banner_6.3.jpg'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: istopic_6_Completed,
              onChanged: (value) {
                _saveTopicCompletionStatus(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சி"),
              ),
          ],
        ),
      ),
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
}
