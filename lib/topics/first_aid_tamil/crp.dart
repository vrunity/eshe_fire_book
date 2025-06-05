import 'package:e_she_book/english/first_aid_english.dart';
import 'package:e_she_book/tamil/first_aid_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CPRForAdultsPage extends StatefulWidget {
  @override
  _CPRForAdultsPageState createState() => _CPRForAdultsPageState();
}

class _CPRForAdultsPageState extends State<CPRForAdultsPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "CPRForAdults";

  final Map<int, String> correctAnswers = {
    1: "இதய மற்றும் சுவாச மீட்பு செயல்",
    2: "நபருக்கு இதயத் துடிப்பு இல்லாமல் சுவாசிக்கவுமில்லை என்றால்",
    3: "30:2",
    4: "மார்பின் நடுவில்",
    5: "மூளைக்கும் இதயத்திற்கும் இரத்த ஓட்டத்தை மீட்டெடுக்க",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "CPR என்பது என்ன?",
      "options": [
        "இதய அழுத்தத் தெரிவு",
        "இதய மற்றும் சுவாச மீட்பு செயல்",
        "மார்பு அழுத்த தாளம்",
        "இதய துடிப்பு மீட்பு"
      ]
    },
    {
      "question": "CPR எப்போது கொடுக்க வேண்டும்?",
      "options": [
        "நபர் தூங்குகிறாரா என்பதைப் பார்க்க",
        "நபருக்கு இதயத் துடிப்பு இல்லாமல் சுவாசிக்கவுமில்லை",
        "நபர் மயங்குகிறார் என்றால்",
        "வயிற்று வலிக்கு"
      ]
    },
    {
      "question": "CPR இல் கம்பிரமம் மற்றும் மூச்சளிப்பு விகிதம் என்ன?",
      "options": [
        "15:2",
        "5:1",
        "30:2",
        "10:10"
      ]
    },
    {
      "question": "எங்கே கம்பிரமம் செய்ய வேண்டும்?",
      "options": [
        "இடது மார்பு",
        "வயிற்றில்",
        "மார்பின் நடுவில்",
        "பின்னால்"
      ]
    },
    {
      "question": "CPR ஏன் முக்கியம்?",
      "options": [
        "மூளைக்கும் இதயத்திற்கும் இரத்த ஓட்டத்தை மீட்டெடுக்க",
        "தசைகள் தளர",
        "செரிமானத்தை மேம்படுத்த",
        "நபரை அமைதியாக்க"
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
              title: Text("CPR for Adults Quiz"),
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
                        SnackBar(content: Text("தயவுசெய்து அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்.")),
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

  void _evaluateQuiz() async {
    int score = 0;
    userAnswers.forEach((key, value) {
      if (correctAnswers[key] == value) {
        score++;
      }
    });

    await _saveQuizScore(score);

    if (score >= 3) {
      final String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('CourseCompletedOn_First Aid', formattedDate);
      print("✅ Course completed date stored for First Aid: $formattedDate");
    }

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
            if (score > 3) // ✅ Show Next Topic only if score > 3
              TextButton(
                child: Text("சரி"),
                onPressed: () =>  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => firstaid_tamil()),
                ),
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
          ),title: Text("CPR")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // CPR Q&A in Tamil

                  _buildQuestionAnswer("💓 CPR என்பது என்ன?", "CPR என்பது 'மனித உருவிழந்து விழுந்துவிட்ட நபருக்கு ஹார்ட் மற்றும் மூளைக்கு இரத்த ஓட்டத்தை தற்காலிகமாக மீட்டெடுக்க' செய்யப்படும் அவசர சிகிச்சை முறை.", imagePath: 'assets/first_aid_6.0.png'),
                  _buildQuestionAnswer("💓 CPR எப்போது தேவையாகும்?", "நபர் விழிப்படையாமல் இருப்பதும், சுவாசிக்காததும் அல்லது இதயத் துடிப்பு இல்லாததும் போது."),
                  _buildQuestionAnswer("💓 நபர் விழிப்படையுறாரா என்பதை எப்படி சரிபார்ப்பது?", "மெதுவாக நபரை ஆட்டிப் பார்த்து, 'நீங்கள் சரி இருக்கிறீர்களா?' எனக் கேளுங்கள்.", imagePath: 'assets/first_aid_6.1.png'),
                  _buildQuestionAnswer("💓 கம்பிரமம் மற்றும் மூச்சளிப்பு விகிதம் என்ன?", "30 முறை கம்பிரமம், அதன் பின்பு 2 மீட்பு மூச்சுகள்."),
                  _buildQuestionAnswer("💓 எவ்வளவு ஆழத்தில் கம்பிரமம் செய்ய வேண்டும்?", "மார்பில் குறைந்தது 2 அங்குலம் (5 செ.மீ) ஆழத்தில்.", imagePath: 'assets/first_aid_6.2.png'),
                  _buildQuestionAnswer("💓 கம்பிரம விகிதம் என்ன?", "நிமிடத்திற்கு 100 முதல் 120 வரை கம்பிரமங்கள்."),
                  _buildQuestionAnswer("💓 மூச்சளிப்பதற்கான முன் தலை வளைத்தல் தேவைதானா?", "ஆம், 'தலைதொட்டு-நாவடைக்க' முறை பயன்படுத்தி வாயுவழியை திறக்க வேண்டும்.", imagePath: 'assets/first_aid_6.3.png'),
                  _buildQuestionAnswer("💓 நீங்கள் பயிற்சி பெறவில்லை என்றால்?", "முயற்சி CPR — கைகளை மட்டும் பயன்படுத்தி கம்பிரமம் செய்யவும், மூச்சளிக்க வேண்டாம்."),
                  _buildQuestionAnswer("💓 CPR எவ்வளவு நேரம் தொடரவேண்டும்?", "மருத்துவ உதவி வரும்வரை அல்லது நபர் விழித்துவரும்வரை.", imagePath: 'assets/first_aid_6.4.png'),
                  _buildQuestionAnswer("💓 CPR போது AED பயன்படுத்தலாமா?", "ஆம், வாயிலில் கிடைக்கும் உடனே தானியங்கி வெளியுறுதி சாதனம் (AED) பயன்படுத்தலாம்.")
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
