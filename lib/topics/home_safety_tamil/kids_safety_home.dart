import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/home_safety_tamil.dart';

class KidsSafetyTamilPage extends StatefulWidget {
  @override
  _KidsSafetyTamilPageState createState() => _KidsSafetyTamilPageState();
}

class _KidsSafetyTamilPageState extends State<KidsSafetyTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "KidsSafetyHome";

  final Map<int, String> correctAnswers = {
    1: "பாதுகாப்பு வாயில்கள், உறுதியான மரச்சாமான்கள் மற்றும் சாக்கெட் காப்புகள் அமைக்க வேண்டும்.",
    2: "முனை கூரிய பொருட்கள், ரசாயனங்கள் மற்றும் மருந்துகளை குழந்தைகள் எட்ட முடியாத இடத்தில் வைக்கவும்.",
    3: "தனது பெயர், அவசர எண்ணுகள் மற்றும் நம்பகமான மக்களை கற்றுக்கொடுக்க வேண்டும்.",
    4: "ஆம், அவர்கள் ஆர்வமுள்ளவர்கள் மற்றும் அபாயங்களைப் புரிந்துகொள்ள முடியாது.",
    5: "ஆம், முறைப்படி பேசுவதும் கண்காணிப்பதும் அவசியம்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "குழந்தைகளை வீட்டு விபத்துகளிலிருந்து எப்படி பாதுகாப்பது?",
      "options": [
        "பாதுகாப்பு வாயில்கள், உறுதியான மரச்சாமான்கள் மற்றும் சாக்கெட் காப்புகள் அமைக்க வேண்டும்.",
        "எல்லா இடங்களிலும் ஏறச் சொல்லவும்.",
        "மாடிப்படிகளைத் திறந்தே வைக்கவும்.",
        "மரச்சாமான்களை தளர்வாக வைக்கவும்."
      ]
    },
    {
      "question": "எதை குழந்தைகளிடமிருந்து விலக்கி வைக்க வேண்டும்?",
      "options": [
        "முனை கூரிய பொருட்கள், ரசாயனங்கள் மற்றும் மருந்துகளை குழந்தைகள் எட்ட முடியாத இடத்தில் வைக்கவும்.",
        "பட்டங்கள் மற்றும் புத்தகங்கள்.",
        "தண்ணீர் பாட்டில்கள்.",
        "தலையணைகள் மற்றும் மெத்தை."
      ]
    },
    {
      "question": "குழந்தைகள் பாதுகாப்புக்காக என்ன தெரிய வேண்டும்?",
      "options": [
        "தனது பெயர், அவசர எண்ணுகள் மற்றும் நம்பகமான மக்களை கற்றுக்கொடுக்க வேண்டும்.",
        "வெளியே விளையாடச் சொல்லுங்கள்.",
        "சோஷியல் மீடியாவை பயன்படுத்தக் கற்றுக்கொடுக்கவும்.",
        "தனியாக சமையல் செய்ய கற்றுக்கொடுக்கவும்."
      ]
    },
    {
      "question": "குழந்தைகள் வீட்டு விபத்துகளுக்கு ஆளாவார்களா?",
      "options": [
        "ஆம், அவர்கள் ஆர்வமுள்ளவர்கள் மற்றும் அபாயங்களைப் புரிந்துகொள்ள முடியாது.",
        "இல்லை, அவர்கள் அனைத்தையும் அறிந்திருக்கிறார்கள்.",
        "வயது வந்தவர்கள் மட்டுமே ஆபத்துக்கு உள்ளாகிறார்கள்.",
        "அவர்கள் தனியாக இருக்கும்போது இல்லை."
      ]
    },
    {
      "question": "குழந்தைகளுடன் தொடர்பு முக்கியமா?",
      "options": [
        "ஆம், முறைப்படி பேசுவதும் கண்காணிப்பதும் அவசியம்.",
        "இல்லை, அவர்கள் தானாகவே கற்றுக்கொள்வார்கள்.",
        "தேர்வுகள் நடக்கும் போது மட்டும்.",
        "அவர்கள் அழும்போது மட்டும்."
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
              title: Text("வினா: வீட்டில் குழந்தை பாதுகாப்பு"),
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
                  child: Text("சமர்ப்பிக்க"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("தயவுசெய்து அனைத்து வினாக்களுக்கும் பதிலளிக்கவும்")),
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
      if (correctAnswers[key] == value) score++;
    });
    _saveQuizScore(score);
    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("வினா முடிவு"),
          content: Text("நீங்கள் ${quizQuestions.length} வினாக்களில் $score மதிப்பெண் பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3)
              TextButton(
                child: Text("முடிக்கவும்"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
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
        title: Text("🏠 வீட்டில் குழந்தைகள் பாதுகாப்பு"),
        backgroundColor: Colors.purple[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQA("👶 குழந்தை பாதுகாப்பு ஏன் முக்கியம்?", "குழந்தைகள் நுண்ணறிவு இல்லாமல் செயல்படுவதால், பாதுகாப்பான சூழல் அவசியம்.", imagePath: 'assets/home_5.0.png'),
                  _buildQA("🔐 வீட்டைப் பாதுகாப்பாக்குதல்", "சாக்கெட் காப்புகள், உறுதியான அலமாரிகள் மற்றும் பூட்டுகள் பயன்படுத்தவும்."),
                  _buildQA("🧪 அபாய தடுப்பு", "கழிவுகள் மற்றும் மருந்துகளை அடைத்து வைக்கவும்.", imagePath: 'assets/home_5.1.png'),
                  _buildQA("📞 அவசர தகவல்", "அவசர எண்ணுகளை எப்படி அழைக்க வேண்டும் என்பதைக் கற்றுக்கொள்ளச் சொல்லவும்."),
                  _buildQA("💬 தொடர்பு", "பாதுகாப்பு விதிகளைப் பற்றி பேசுங்கள் மற்றும் விளையாட்டை கண்காணிக்கவும்.", imagePath: 'assets/home_5.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடித்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சி")),
          ],
        ),
      ),
    );
  }
}
