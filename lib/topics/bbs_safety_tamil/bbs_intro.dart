import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/bbs_safety_english.dart';

class BBSIntroPageTamil extends StatefulWidget {
  @override
  _BBSIntroPageState createState() => _BBSIntroPageState();
}

class _BBSIntroPageState extends State<BBSIntroPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "BBSIntro";

  final Map<int, String> correctAnswers = {
    1: "BBS என்பது பாதுகாப்பான நடத்தைமுறைகளை அடையாளம் காணும் மற்றும் வலுப்படுத்தும் முறையாகும்.",
    2: "பாதுகாப்பான நடைமுறைகளை ஊக்குவிப்பதன் மூலம் விபத்துகளை குறைக்க",
    3: "ஆம், இது பாதுகாப்பற்ற பழக்கங்களை சரி செய்ய உதவுகிறது.",
    4: "கவனிக்கவும், நடத்தைப் பகுப்பாய்வு செய்யவும், பின்னூட்டம் அளிக்கவும்.",
    5: "பணியாளர்கள், மேற்பார்வையாளர்கள் மற்றும் மேலாண்மை."
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "🧠 BBS என்பது என்ன?",
      "options": [
        "ஒரு கூடைச்செயலியல் பட்டியல்",
        "பயிற்சி வீடியோவின் ஒரு வகை",
        "BBS என்பது பாதுகாப்பான நடத்தைமுறைகளை அடையாளம் காணும் மற்றும் வலுப்படுத்தும் முறையாகும்.",
        "மேலே எதுவும் இல்லை"
      ]
    },
    {
      "question": "🎯 BBS ஏன் செயல்படுத்தப்படுகிறது?",
      "options": [
        "செலவுகளை அதிகரிக்க",
        "பாதுகாப்பான நடைமுறைகளை ஊக்குவிப்பதன் மூலம் விபத்துகளை குறைக்க",
        "வேலை நேரத்தை குறைக்க",
        "சமூக ஊடக புகழை உயர்த்த"
      ]
    },
    {
      "question": "BBS பாதுகாப்பு கலாச்சாரத்தை மேம்படுத்துமா?",
      "options": [
        "இல்லை, இது பயனற்றது",
        "ஆம், இது பாதுகாப்பற்ற பழக்கங்களை சரி செய்ய உதவுகிறது.",
        "மேலாளர்களுக்கே மட்டுமே",
        "பெரிய நிறுவனங்களுக்கு மட்டும்"
      ]
    },
    {
      "question": "BBS இல் முக்கியமான படிகள் என்ன?",
      "options": [
        "அறிக்கை எழுதி மறந்து விடு",
        "கவனிக்கவும், நடத்தைப் பகுப்பாய்வு செய்யவும், பின்னூட்டம் அளிக்கவும்.",
        "புகார்களை பதிவு செய்",
        "பாதுகாப்பற்ற செயல்களை புறக்கணி"
      ]
    },
    {
      "question": "BBS யில் யார் கலந்து கொள்கின்றனர்?",
      "options": [
        "மனித வளத்துறை மட்டும்",
        "பாதுகாப்பு அதிகாரிகள் மட்டும்",
        "பணியாளர்கள், மேற்பார்வையாளர்கள் மற்றும் மேலாண்மை.",
        "வெளி நபர்கள்"
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
              title: Text("வினாடி வினா: BBS அறிமுகம்"),
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
                        SnackBar(content: Text("அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
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
          content: Text("நீங்கள் ${quizQuestions.length} ல் $score மதிப்பெண் பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/core_principles_ta');
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
        title: Text("BBS அறிமுகம்"),
        backgroundColor: Colors.blue,
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
                    "🧠 BBS என்றால் என்ன?",
                    "BBS என்பது நடத்தை அடிப்படையிலான பாதுகாப்பு முறையாகும். இது பணியாளர்களின் நடத்தை மீது கவனம் செலுத்தும் பாதுகாப்பு மேலாண்மை அணுகுமுறை ஆகும். இது அவதானிப்பு, பின்னூட்டம் மற்றும் ஊக்குவிப்பின் மூலம் பாதுகாப்பான நடைமுறைகளை ஊக்குவிக்கிறது.",
                    imagePath: 'assets/bbs_intro_1.png',
                  ),
                  _buildQA(
                    "🎯 BBS-இன் குறிக்கோள்",
                    "பணியிட விபத்துகள் மற்றும் காயங்களைத் தடுப்பதே BBS-இன் முதன்மையான நோக்கமாகும். இது பாதுகாப்பற்ற நடைமுறைகளை அடையாளம் காண்பதன் மூலம் பாதுகாப்பானவற்றை வலுப்படுத்துகிறது.",
                  ),
                  _buildQA(
                    "👥 யார் கலந்து கொள்கிறார்கள்?",
                    "BBS எல்லா நிலை பணியாளர்களையும் உள்ளடக்குகிறது — பணியாளர்கள், மேற்பார்வையாளர்கள் மற்றும் மேலாண்மை ஆகியோர். இது ஒருங்கிணைந்த பாதுகாப்பு பண்பாட்டை உருவாக்குகிறது.",
                    imagePath: 'assets/bbs_intro_2.png',
                  ),
                  _buildQA(
                    "🔍 கவனிப்பு அடிப்படையிலானது",
                    "BBS நேரடி பணித்தள நடத்தைங்களைப் பதிவு செய்து, தரவுகளை சேகரித்து, பகுப்பாய்வு செய்து, உடனடி பின்னூட்டம் அளிக்கிறது.",
                  ),
                  _buildQA(
                    "📈 தாக்கம்",
                    "BBS-ஐ செயல்படுத்தும் நிறுவனங்கள் பாதுகாப்பு செயல்திறன், ஊக்கமளிப்பு மற்றும் பாதுகாப்பு முதன்மை சிந்தனையில் மேம்பாட்டை காண்கின்றன.",
                    imagePath: 'assets/bbs_intro_3.png',
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிக்கப்பட்டதாக குறியிடு"),
              value: isCompleted,
              onChanged: (value) {
                _saveCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சி")),
          ],
        ),
      ),
    );
  }
}
