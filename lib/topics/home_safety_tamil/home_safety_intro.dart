import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/home_safety_tamil.dart';

class HomeSafetyIntroTamilPage extends StatefulWidget {
  @override
  _HomeSafetyIntroTamilPageState createState() => _HomeSafetyIntroTamilPageState();
}

class _HomeSafetyIntroTamilPageState extends State<HomeSafetyIntroTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "HomeSafetyIntro";

  final Map<int, String> correctAnswers = {
    1: "இது வீட்டில் ஏற்பட்டுக்கொள்ளும் விபத்துகள் மற்றும் காயங்களை குறைக்க உதவுகிறது.",
    2: "வீழ்வது, எரிவைப்பு, மின்சாதன தாக்கம், வாயுகழிவுகள்.",
    3: "ஏனெனில் பல அபாயங்கள் கவனிக்கப்படாமல் ஆபத்தாக இருக்கலாம்.",
    4: "ஆம், சிறார்களுக்கும் மூப்பர்களுக்கும் அதிக ஆபத்து உள்ளது.",
    5: "கல்வி மற்றும் விழிப்புணர்வு."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "வீட்டு பாதுகாப்பு ஏன் முக்கியம்?",
      "options": [
        "இது வீட்டில் ஏற்பட்டுக்கொள்ளும் விபத்துகள் மற்றும் காயங்களை குறைக்க உதவுகிறது.",
        "வீட்டை அழகாக மாற்றும்.",
        "மின்சாரம் கட்டணத்தை குறைக்கும்.",
        "வீட்டைப் பராமரிக்க எளிதாகும்."
      ]
    },
    {
      "question": "பொதுவாக உள்ள வீட்டுப் பாய்கள் என்னென்ன?",
      "options": [
        "வீழ்வது, எரிவைப்பு, மின்சாதன தாக்கம், வாயுகழிவுகள்.",
        "டிவி மற்றும் வைஃபை.",
        "பிளாஸ்டிக் பாட்டில்கள் மற்றும் பானைகள்.",
        "புத்தகங்கள் மற்றும் இதழ்கள்."
      ]
    },
    {
      "question": "வீட்டுப் பாதுகாப்பு குறித்து விழிப்புணர்வாக இருக்க வேண்டியதேன்?",
      "options": [
        "ஏனெனில் பல அபாயங்கள் கவனிக்கப்படாமல் ஆபத்தாக இருக்கலாம்.",
        "ஏனெனில் அது பழக்கம்.",
        "அண்டை வீட்டார் சொன்னதால்.",
        "அழகாக இருக்கும்."
      ]
    },
    {
      "question": "சிறார்களும் மூப்பர்களும் அதிக ஆபத்துக்கு உள்ளாகிறார்களா?",
      "options": [
        "ஆம், சிறார்களுக்கும் மூப்பர்களுக்கும் அதிக ஆபத்து உள்ளது.",
        "இல்லை, பெரியவர்களே ஆபத்தில் உள்ளார்கள்.",
        "பகலில் மட்டும் ஆபத்து.",
        "தனியாக இருக்கும்போது மட்டுமே ஆபத்து."
      ]
    },
    {
      "question": "விபத்துக்களை எவ்வாறு குறைக்கலாம்?",
      "options": [
        "கல்வி மற்றும் விழிப்புணர்வு.",
        "அபாயங்களை அலட்சியம் செயல்.",
        "அமர்ந்த இடங்களை அகற்றுவது.",
        "பழைய சாதனங்களை பயன்படுத்துவது."
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
              title: Text("வினா-விலுக்கு: வீட்டுப் பாதுகாப்பு அறிமுகம்"),
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
                        SnackBar(content: Text("தயவுசெய்து அனைத்து வினாக்களுக்கும் பதில் அளிக்கவும்")),
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
                child: Text("அடுத்தது"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/kitchen_safety_ta');
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
        title: Text("🏡 வீட்டுப் பாதுகாப்பு அறிமுகம்"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQA("🏠 வீட்டுப் பாதுகாப்பு என்றால் என்ன?", "வீட்டில் உள்ள அபாயங்களை அடையாளம் கண்டு அவற்றை தவிர்க்க நடவடிக்கை எடுப்பது.", imagePath: 'assets/home_intro_1.0.png'),
                  _buildQA("❗ முக்கியத்துவம்", "சிறார்கள், முதியவர்கள் மற்றும் மாற்றுத் திறனாளிகளை பாதுகாப்பது."),
                  _buildQA("📉 பொதுவான அபாயங்கள்", "வீழ்வது, எரிவைப்பு, விஷப்பொருள், மின்சட்டம் மற்றும் வாயுகழிவுகள்.", imagePath: 'assets/home_intro_1.1.png'),
                  _buildQA("🛑 தடுப்பு வழிகள்", "வழிச்செலுத்தும் பாதையைத் துடைத்து வைக்கவும், சாதனங்களை சரிபார்க்கவும், ரசாயனங்களை பாதுகாப்பாக வைக்கவும்."),
                  _buildQA("👶 சிறார் பாதுகாப்பு", "ஆபத்தான பொருட்களை தொலைவில் வைக்கவும் மற்றும் குழந்தைகளை கற்றுக்கொடுக்கவும்.", imagePath: 'assets/home_intro_1.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடித்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("முந்தைய மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சி")),
          ],
        ),
      ),
    );
  }
}
