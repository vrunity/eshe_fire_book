import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EyeProtectionPage extends StatefulWidget {
  @override
  _EyeProtectionPageState createState() => _EyeProtectionPageState();
}

class _EyeProtectionPageState extends State<EyeProtectionPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EyeProtection";

  final Map<int, String> correctAnswers = {
    1: "வீழும் துகள்கள் மற்றும் இரசாயனங்கள் போன்ற அபாயங்களில் இருந்து கண்களை பாதுகாப்பதற்காக",
    2: "பாதுகாப்பு கண்ணாடிகள் மற்றும் முக கவசங்கள்",
    3: "ஒவ்வொரு பயன்பாட்டிற்கும் முன்பு",
    4: "நன்றாக பொருந்துதல் மற்றும் சிதைவில்லாமல் இருக்க வேண்டும்",
    5: "கண் பாதுகாப்பிற்கான எந்த அபாயமும் இருக்கும்போது",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "கண் பாதுகாப்பு ஏன் முக்கியம்?",
      "options": [
        "அழகை மேம்படுத்த",
        "வீழும் துகள்கள் மற்றும் இரசாயனங்கள் போன்ற அபாயங்களில் இருந்து கண்களை பாதுகாப்பதற்காக",
        "கண்ணாடிகளைத் தவிர்க்க",
        "போஷாக்குக்கு ஏற்ப"
      ]
    },
    {
      "question": "கண்களுக்கு பொதுவாக பயன்படுத்தப்படும் பாதுகாப்பு உபகரணங்கள் என்ன?",
      "options": [
        "தொப்பிகள் மற்றும் ஹெல்மெட்கள்",
        "முகமூடிகள்",
        "பாதுகாப்பு கண்ணாடிகள் மற்றும் முக கவசங்கள்",
        "தொப்பிகள்"
      ]
    },
    {
      "question": "கண் பாதுகாப்பு உபகரணங்களை எப்போது பரிசோதிக்க வேண்டும்?",
      "options": [
        "ஒவ்வொரு பயன்பாட்டிற்கும் முன்பு",
        "ஒரு வருடத்திற்கு ஒருமுறை",
        "ஒருபோதும் இல்லை",
        "சிதைவடைந்த பிறகு மட்டுமே"
      ]
    },
    {
      "question": "சரியான கண் பாதுகாப்பின் முக்கிய அம்சம் என்ன?",
      "options": [
        "நவீன வடிவமைப்பு",
        "நன்றாக பொருந்துதல் மற்றும் சிதைவில்லாமல் இருக்க வேண்டும்",
        "பிரபலமான பிராண்ட்",
        "உடை நிறத்துடன் பொருந்துதல்"
      ]
    },
    {
      "question": "எப்போது கண் பாதுகாப்பு அணிய வேண்டும்?",
      "options": [
        "மழையில் மட்டும்",
        "தொலைக்காட்சி பார்க்கும் போது",
        "கண் பாதுகாப்பு அபாயம் இருக்கும்போது",
        "வாகனம் ஓட்டும்போது"
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
    if (value) {
      _showQuizDialog();
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
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("கண் பாதுகாப்பு வினாடி வினா"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int index = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question["question"], style: TextStyle(fontWeight: FontWeight.bold)),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[index],
                            onChanged: (String? value) {
                              setState(() {
                                userAnswers[index] = value!;
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
                      Navigator.of(context).pop();
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
          content: Text("நீங்கள் ${quizQuestions.length} இலிருந்து $score மதிப்பெண் பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/ppe_tamil');
                },
              ),
            TextButton(
              child: Text("மீண்டும் முயற்சி செய்யவும்"),
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

  Widget _buildQuestionAnswer(String question, String answer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 5),
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
            Navigator.pop(context);
          },
        ),
        title: Text("கண் பாதுகாப்பு"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("👁️ கண் பாதுகாப்பு என்பது என்ன?", "வீழும் துகள்கள், இரசாயனங்கள் அல்லது ஒளிக் கதிர்வீச்சுகளால் ஏற்படும் காயங்களைத் தடுக்கும் பாதுகாப்பு உபகரணங்களை பயன்படுத்துதல்."),
                  _buildQuestionAnswer("👁️ கண் பாதுகாப்பு ஏன் தேவை?", "கண்கள் மிகவும் உணர்ச்சிப்பூர்வமானவை மற்றும் எளிதாக காயப்படக்கூடியவை. பாதுகாப்பு உபகரணங்கள் தற்காலிக அல்லது நிரந்தர பார்வை இழப்பைத் தடுக்கும்."),
                  _buildQuestionAnswer("👁️ கண்களுக்கு உள்ள பொதுவான அபாயங்கள் என்ன?", "வீழும் துகள்கள், தீவிரமான ஒளி, இரசாயனம் தெறிப்பு மற்றும் தூசி."),
                  _buildQuestionAnswer("👁️ கண் பாதுகாப்பிற்குப் பயன்படுத்தப்படும் உபகரணங்கள்?", "பாதுகாப்பு கண்ணாடிகள், முக கவசங்கள், வெல்டிங் ஹெல்மெட்கள், லேசர் பாதுகாப்பு கண்ணாடிகள்."),
                  _buildQuestionAnswer("👁️ கண் பாதுகாப்பு உபகரணங்கள் எப்படி பொருந்த வேண்டும்?", "சரியாக பொருந்த வேண்டும் மற்றும் பார்வையை தடையில்லாமல் இருக்க வேண்டும்."),
                  _buildQuestionAnswer("👁️ எப்போது கண் பாதுகாப்பு பயன்படுத்த வேண்டும்?", "வெல்டிங், ரசாயன கையாளுதல் போன்ற எந்த அபாயமும் இருக்கும்போது."),
                  _buildQuestionAnswer("👁️ சாதாரண கண்ணாடிகள் பாதுகாப்பு கண்ணாடிகளை மாற்ற முடியுமா?", "முடியாது. சாதாரண கண்ணாடிகள் தாக்கங்களை எதிர்க்கும் வகையில் வடிவமைக்கப்படவில்லை."),
                  _buildQuestionAnswer("👁️ கண் பாதுகாப்பு உபகரணங்களை எப்படி பராமரிக்க வேண்டும்?", "ஒவ்வொரு பயன்பாட்டின் பிறகும் சுத்தம் செய்யவும், பாதிப்புகளுக்குப் பரிசோதிக்கவும்."),
                  _buildQuestionAnswer("👁️ கண் பாதுகாப்பிற்கு யார் பொறுப்பாக இருக்க வேண்டும்?", "முதலாளிகளும் ஊழியர்களும் இருவரும் கண் பாதுகாப்பிற்குப் பொறுப்பாக இருக்க வேண்டும்."),
                  _buildQuestionAnswer("👁️ கண் பாதுகாப்பு உபகரணம் சேதமடைந்தால் என்ன செய்ய வேண்டும்?", "உடனடியாக மாற்ற வேண்டும்."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடித்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி வினாடி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சி செய்யவும்"),
              )
          ],
        ),
      ),
    );
  }
}
