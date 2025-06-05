import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/construction_safety_tamil.dart';

class ConstructionIntroTamilPage extends StatefulWidget {
  @override
  _ConstructionIntroTamilPageState createState() => _ConstructionIntroTamilPageState();
}

class _ConstructionIntroTamilPageState extends State<ConstructionIntroTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ConstructionIntroTa";

  final Map<int, String> correctAnswers = {
    1: "தொழிலாளர்கள் பாதுகாப்பாக இருக்கவும் விபத்துகளைத் தவிர்க்கவும்.",
    2: "உயரத்தில் விழுவது, மின்சாரம், கருவி காயங்கள்.",
    3: "தளத்தில் உள்ள அனைவரும் – தொழிலாளர்கள் மற்றும் பார்வையாளர்கள்.",
    4: "பாதுகாப்பு விதிமுறைகளைப் பின்பற்றி மற்றும் PPE அணிவதன் மூலம்.",
    5: "வாழ்க்கையை பாதுகாக்க, அபராதங்களை தவிர்க்க, பொறுப்புணர்வு உருவாக்க.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "ஏன் கட்டுமான பாதுகாப்பு முக்கியம்?",
      "options": [
        "தொழிலாளர்கள் பாதுகாப்பாக இருக்கவும் விபத்துகளைத் தவிர்க்கவும்.",
        "வேலை விரைவாக முடிக்க.",
        "தொழிலாளர்களுக்கு சம்பளம் தராமல் இருக்க.",
        "அமைதியற்ற கட்டுமானம் செய்ய."
      ]
    },
    {
      "question": "பொதுவான கட்டுமான ஆபத்துகள் என்ன?",
      "options": [
        "உயரத்தில் விழுவது, மின்சாரம், கருவி காயங்கள்.",
        "திரைப்படங்கள் பார்க்கும், சத்தமாக பேசும்.",
        "இலகுரக பொருட்களை தூக்கும்.",
        "அதிகமாக சாப்பிடுவது."
      ]
    },
    {
      "question": "பாதுகாப்புக்கு பொறுப்பு யார்?",
      "options": [
        "தளத்தில் உள்ள அனைவரும் – தொழிலாளர்கள் மற்றும் பார்வையாளர்கள்.",
        "வசதி மேற்பார்வையாளர் மட்டும்.",
        "தொலைதூரம் இருக்கும் உரிமையாளர்.",
        "மட்டும் காவல்துறை."
      ]
    },
    {
      "question": "ஆபத்துகளை எப்படி குறைக்கலாம்?",
      "options": [
        "பாதுகாப்பு விதிமுறைகளைப் பின்பற்றி மற்றும் PPE அணிவதன் மூலம்.",
        "சைக்களைக் கடந்து செல்லாமல்.",
        "தலையில் ஹெல்மெட் அணியாமல்.",
        "வேகமாக ஓடுவதன் மூலம்."
      ]
    },
    {
      "question": "பாதுகாப்பு விதிகளை ஏன் பின்பற்ற வேண்டும்?",
      "options": [
        "வாழ்க்கையை பாதுகாக்க, அபராதங்களை தவிர்க்க, பொறுப்புணர்வு உருவாக்க.",
        "மற்றவர்கள் செய்வதற்காகவே.",
        "வேலை தவிர்க்கவே.",
        "அழகுக்கு மட்டும்."
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
              title: Text("கட்டுமான பாதுகாப்பு வினா-விலைகள்"),
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
                  child: Text("சமர்ப்பிக்கவும்"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("அனைத்து வினாக்களுக்கும் பதிலளிக்கவும்.")),
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
          title: Text("மதிப்பெண் முடிவு"),
          content: Text("நீங்கள் பெற்ற மதிப்பெண்: $score / ${quizQuestions.length}."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3)
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/personal_protective_ta');
                },
              ),
            TextButton(
              child: Text("மீளமுயற்சி"),
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
              MaterialPageRoute(builder: (_) => ConstructionSafetyTamil()),
            );
          },
        ),
        title: Text("கட்டுமானம் - அறிமுகம்"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🏗 ஏன் கட்டுமான பாதுகாப்பு அவசியம்?", "தொழிலாளர்களின் உயிர் பாதுகாப்பிற்காக.", imagePath: 'assets/construction_1.0.png'),
                  _buildQuestionAnswer("⚠ பொதுவான ஆபத்துகள்?", "உயரத்திலிருந்து விழும் ஆபத்து, மின்சாரம், கருவிகள்."),
                  _buildQuestionAnswer("👷 யார் பாதுகாப்புக்கு பொறுப்பு?", "தளத்தில் உள்ள அனைவரும்.", imagePath: 'assets/construction_1.1.png'),
                  _buildQuestionAnswer("✅ பாதுகாப்பு எப்படிப் பெறலாம்?", "PPE அணிந்து, விதிகளை பின்பற்றி."),
                  _buildQuestionAnswer("📢 பாதுகாப்பு விதிகள் ஏன்?", "வாழ்க்கையை பாதுகாக்க மற்றும் பொறுப்புணர்வை ஏற்படுத்த.", imagePath: 'assets/construction_1.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடித்துவிட்டேன் என குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) {
                _saveTopicCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீளமுயற்சி")),
          ],
        ),
      ),
    );
  }
}
