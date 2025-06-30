import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/chemical_safety_tamil.dart';

class HazardCommunicationPageTamil extends StatefulWidget {
  @override
  _HazardCommunicationPageTamilState createState() => _HazardCommunicationPageTamilState();
}

class _HazardCommunicationPageTamilState extends State<HazardCommunicationPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "HazardCommunication";

  final Map<int, String> correctAnswers = {
    1: "ஓர் பணிக்கான ஆபத்துகளை தெரிந்து கொள்வது மற்றும் பாதுகாப்பை உறுதி செய்வதற்காக.",
    2: "SDS ஆனது ரசாயனங்களின் ஆபத்து மற்றும் கையாளுதல் பற்றிய விவரங்களை வழங்குகிறது.",
    3: "லேபிள்கள் ரசாயனங்களை அடையாளம் காட்டுகின்றன மற்றும் பாதுகாப்பான கையாளுதலை விளக்குகின்றன.",
    4: "பயிற்சி மூலம் SDS மற்றும் லேபிள்கள் வாசிக்க தெரியும்.",
    5: "ஆம், இது சட்டப்படி கட்டாயம்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "ஆபத்து தொடர்பு என்னும் உரையின் நோக்கம் என்ன?",
      "options": [
        "ரகசியமாக வைத்திருக்க",
        "ஓர் பணிக்கான ஆபத்துகளை தெரிந்து கொள்வது மற்றும் பாதுகாப்பை உறுதி செய்வதற்காக.",
        "செலவைக் குறைக்க",
        "மேலே உள்ளவை எதுவும் இல்லை"
      ]
    },
    {
      "question": "SDS என்ன தகவல்களை வழங்குகிறது?",
      "options": [
        "வேலை நேரங்கள்",
        "தனிப்பட்ட தகவல்",
        "SDS ஆனது ரசாயனங்களின் ஆபத்து மற்றும் கையாளுதல் பற்றிய விவரங்களை வழங்குகிறது.",
        "விளம்பர உள்ளடக்கம்"
      ]
    },
    {
      "question": "லேபிள்கள் ஏன் முக்கியம்?",
      "options": [
        "அழகாக இருப்பதற்காக",
        "லேபிள்கள் ரசாயனங்களை அடையாளம் காட்டுகின்றன மற்றும் பாதுகாப்பான கையாளுதலை விளக்குகின்றன.",
        "வண்ணங்களை பொருத்த",
        "மார்க்கெட்டிங் செய்ய"
      ]
    },
    {
      "question": "பயிற்சி ஆபத்து தொடர்புக்கு எப்படிச் செயல் அளிக்கிறது?",
      "options": [
        "ஓவியம் கற்பதற்கு",
        "பயிற்சி மூலம் SDS மற்றும் லேபிள்கள் வாசிக்க தெரியும்.",
        "புதிய நடனங்களை கற்பதற்கு",
        "மேலே உள்ளவை எதுவும் இல்லை"
      ]
    },
    {
      "question": "ஆபத்து தொடர்பு சட்டப்படி கட்டாயமா?",
      "options": [
        "இல்லை, விருப்பம்",
        "நிறுவனத்தின் மீது பொருத்தம்",
        "ஆம், இது சட்டப்படி கட்டாயம்.",
        "பரிசோதனை அறைகளில் மட்டுமே"
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
              title: Text("வினாடி வினா: ஆபத்து தொடர்பு"),
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
          title: Text("வினாடி வினா முடிவு"),
          content: Text("நீங்கள் ${quizQuestions.length} இல் $score மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3)
              TextButton(
                child: Text("அடுத்த பகுதி"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/chemical_storage_ta');
                },
              ),
            TextButton(
              child: Text("மீளத் தேர்வு"),
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
        title: Text("ஆபத்து தொடர்பு"),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ChemicalSafetyTamil()),
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
                  _buildQA("📋 ஆபத்து தொடர்பு என்பது என்ன?",
                      "இது வேலை இடங்களில் இருக்கும் ஆபத்தான ரசாயனங்களைப் பற்றி ஊழியர்களை நன்கு அறிவிக்கிறது.",
                      imagePath: "assets/chemical_2.0.png"),
                  _buildQA("📄 பாதுகாப்பு தரவுத் தாள் (SDS)",
                      "SDS என்பது ரசாயனங்களின் ஆபத்துகள், கையாளும் முறை மற்றும் அவசர நிலைமைகள் குறித்த முழுமையான தகவல்களைக் கொண்டது."),
                  _buildQA("🏷️ லேபிள்கள் மற்றும் அடையாளங்கள்",
                      "ஆபத்தான ரசாயனங்களை அடையாளம் காண உதவும் முக்கியமான கருவிகள்.",
                      imagePath: "assets/chemical_2.1.png"),
                  _buildQA("🎓 பயிற்சி மற்றும் விழிப்புணர்வு",
                      "பயிற்சி ஊழியர்களுக்கு SDS மற்றும் லேபிள்களை வாசிக்கத் தெரிந்து கொள்ள உதவுகிறது."),
                  _buildQA("⚖️ சட்டத் தேவைகள்",
                      "OSHA போன்ற அரசாங்க அமைப்புகள் இதனை கட்டாயமாக்கி உள்ளன.",
                      imagePath: "assets/chemical_2.2.png"),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீளத் தேர்வு")),
          ],
        ),
      ),
    );
  }
}
