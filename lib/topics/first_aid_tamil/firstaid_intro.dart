import 'package:e_she_book/tamil/first_aid_tamil.dart';
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
    1: "தற்காலிகமாக மருத்துவ உதவி வரும் வரை உடனடியாக செய்யப்படும் சிகிச்சை",
    2: "வாழ்நிலை காக்க, மோசமடையாமல் தடுக்கும், மீட்பு ஏற்படுத்தும்",
    3: "அறிவும் விருப்பமும் உள்ள எவரும்",
    4: "ஆம், அவசர நேரங்களில் மிகவும் பயனுள்ளதாகும்",
    5: "அமைதியாக இருங்கள், நிலைமையை மதிப்பீடு செய்யுங்கள், பாதுகாப்பை உறுதி செய்யுங்கள்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "முதலுதவி என்றால் என்ன?",
      "options": [
        "மருத்துவமனையில் செய்யப்படும் சிகிச்சை",
        "தற்காலிகமாக மருத்துவ உதவி வரும் வரை உடனடியாக செய்யப்படும் சிகிச்சை",
        "மட்டும் CPR",
        "மருத்துவ பரிசோதனை"
      ]
    },
    {
      "question": "முதலுதவியின் நோக்கங்கள் என்ன?",
      "options": [
        "வாழ்நிலை காக்க, மோசமடையாமல் தடுக்கும், மீட்பு ஏற்படுத்தும்",
        "அவசர சேவைக்கு அழைக்க வேண்டும்",
        "மருந்தளிக்க வேண்டும்",
        "பாதிக்கப்பட்டவரை மயக்கப்படுத்த வேண்டும்"
      ]
    },
    {
      "question": "யார் முதலுதவி வழங்க முடியும்?",
      "options": [
        "மட்டும் மருத்தவர்கள்",
        "போலீசார் மட்டும்",
        "அறிவும் விருப்பமும் உள்ள எவரும்",
        "உரிமம் இல்லாதவர்கள் முடியாது"
      ]
    },
    {
      "question": "முதலுதவி நாளாந்த வாழ்க்கையில் பயனுள்ளதா?",
      "options": [
        "இல்லை",
        "மட்டும் மருத்துவமனையில்",
        "ஆம், அவசர நேரங்களில் மிகவும் பயனுள்ளதாகும்",
        "மட்டும் பயிற்சி பெற்றவர்கள்"
      ]
    },
    {
      "question": "முதலுதவி அளிக்கும் முன் என்ன செய்ய வேண்டும்?",
      "options": [
        "அங்கே இருந்து ஓடுங்கள்",
        "மீடியாவை அழையுங்கள்",
        "அமைதியாக இருங்கள், நிலைமையை மதிப்பீடு செய்யுங்கள், பாதுகாப்பை உறுதி செய்யுங்கள்",
        "புகைப்படம் எடுக்கவும்"
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
                  Navigator.pushNamed(context, '/bleeding_control_ta'); // Navigate to next topic page
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
                MaterialPageRoute(builder: (context) => firstaid_tamil()),
              );
            },
          ),title: Text(" முதலுதவியின் அறிமுகம்")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🩹 முதலுதவி என்றால் என்ன?",
                      "ஒருவர் காயமடைந்தாலோ திடீரென நோயுற்றாலோ, மருத்துவ உதவி வரும் வரை உடனடியாக வழங்கப்படும் உதவி.",
                      imagePath: 'assets/first_aid_1.0.png'),
                  _buildQuestionAnswer("🎯 முதலுதவியின் நோக்கங்கள் என்ன?",
                      "வாழ்நிலை காக்க, நிலை மோசமடையாமல் தடுப்பது மற்றும் மீட்பு ஏற்படுத்துவது."),
                  _buildQuestionAnswer("👥 யார் முதலுதவி வழங்க முடியும்?",
                      "அறிவும் விருப்பமும் உள்ள எவரும் வழங்கலாம்.", imagePath: 'assets/first_aid_1.1.png'),
                  _buildQuestionAnswer("🏠 முதலுதவி நாளாந்த வாழ்க்கையில் முக்கியமா?",
                      "ஆம். இது வீடு, பள்ளி, வேலை இடங்களில் ஏற்பட்ட விபத்துக்களை கையாள உதவும்."),
                  _buildQuestionAnswer("🧠 முதலுதவிக்கு முன் என்ன செய்ய வேண்டும்?",
                      "அமைதியாக இருங்கள், பாதுகாப்பு சூழலை மதிப்பீடு செய்து, அவசியமான உதவிக்கு அழைக்கவும்.", imagePath: 'assets/first_aid_1.2.png'),
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
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சி"),
              ),
          ],
        ),
      ),
    );
  }
}
