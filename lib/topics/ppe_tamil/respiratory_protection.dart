import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RespiratoryProtectionPage extends StatefulWidget {
  @override
  _RespiratoryProtectionPageState createState() => _RespiratoryProtectionPageState();
}

class _RespiratoryProtectionPageState extends State<RespiratoryProtectionPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "RespiratoryProtection";

  final Map<int, String> correctAnswers = {
    1: "ஆபத்தான வாயுவுகளை சுவாசிக்காமல் தடுக்கும்",
    2: "மூக்குக் கவசங்கள் மற்றும் ரெஸ்பிரேட்டர்கள்",
    3: "தீங்கு விளைவிக்கும் துகள்கள் மற்றும் வாயுக்களை வடிகட்டி விடும்",
    4: "பயன்பாட்டு ஆபத்து அடிப்படையில் தேர்வு செய்ய வேண்டும்",
    5: "தூய்மை, சரியாக சேமித்தல் மற்றும் சேதங்களை பரிசோதித்தல்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "மூச்சு பாதுகாப்பு ஏன் அவசியம்?",
      "options": [
        "மோசமான வாசனையிலிருந்து தவிர்க்க",
        "ஆபத்தான வாயுக்களை சுவாசிக்காமல் தடுக்கும்",
        "காற்றை சூடாக்க",
        "முகத்தை மறைக்க"
      ]
    },
    {
      "question": "மூச்சு பாதுகாப்பு சாதனங்கள் எவை?",
      "options": [
        "கையுறை",
        "தலைக்கவசம்",
        "மூக்குக் கவசங்கள் மற்றும் ரெஸ்பிரேட்டர்கள்",
        "காதில் செருகும் பொருட்கள்"
      ]
    },
    {
      "question": "ரெஸ்பிரேட்டர்கள் எப்படி செயல்படுகின்றன?",
      "options": [
        "ஆக்ஸிஜனை பம்ப் செய்கின்றன",
        "தீங்கு விளைவிக்கும் துகள்கள் மற்றும் வாயுக்களை வடிகட்டும்",
        "காற்றை ஈரமாக்கும்",
        "மூச்சை மேம்படுத்தும்"
      ]
    },
    {
      "question": "சரியான ரெஸ்பிரேட்டரை எப்படித் தேர்ந்தெடுக்கலாம்?",
      "options": [
        "ஃபாஷன் அடிப்படையில்",
        "நண்பரை கேட்டு",
        "மிகக் குறைந்த விலையில் வாங்கி",
        "பயன்பாட்டு ஆபத்து அடிப்படையில்"
      ]
    },
    {
      "question": "ரெஸ்பிரேட்டர்களை எப்படி பராமரிக்க வேண்டும்?",
      "options": [
        "தூய்மை, சரியாக சேமித்தல் மற்றும் சேதங்களை பரிசோதித்தல்",
        "ப்ளீச் கொண்டு கழுவுதல்",
        "முறிந்து விடும் வரை பயன்படுத்தல்",
        "மற்றவர்களிடம் கொடுப்பது"
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
              title: Text("மூச்சு பாதுகாப்பு வினாடி வினா"),
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
                  child: Text("சமர்ப்பிக்க"),
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
          content: Text("நீங்கள் ${quizQuestions.length} இல் $score மதிப்பெண்களை பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3)
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pushNamed(context, '/foot_protection_ta');
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
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
      appBar: AppBar(title: Text("மூச்சு பாதுகாப்பு")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("😷 மூச்சு பாதுகாப்பு என்றால் என்ன?", "ஆபத்தான வாயுக்கள் மற்றும் துகள்கள் போன்றவற்றைத் தவிர்க்கும் சாதனங்கள்.", imagePath: 'assets/ppe_4.0.png'),
                  _buildQuestionAnswer("😷 இது ஏன் முக்கியம்?", "தூசி, வாயுக்கள் போன்றவை நுரையீரல் நோய்களையும் சுவாச கோளாறுகளையும் ஏற்படுத்தலாம்."),
                  _buildQuestionAnswer("😷 எந்த வகையான மூச்சுப் பாதுகாப்பு சாதனங்கள் உள்ளன?", "மூக்குக் கவசம், அரைமுக கவசம், முழு முக கவசம், சுத்திகரிக்கப்பட்ட காற்று வழங்கும் சாதனங்கள்."),
                  _buildQuestionAnswer("😷 எப்போது பயன்படுத்த வேண்டும்?", "தூசி, இரசாயன வாயுக்கள் போன்றவைகள் உள்ள சூழலில்."),
                  _buildQuestionAnswer("😷 யாரும் எந்த ரெஸ்பிரேட்டரும் பயன்படுத்தலாமா?", "இல்லை, பொருத்தம் மற்றும் ஆபத்து அடிப்படையில் தேர்வு செய்ய வேண்டும்.", imagePath: 'assets/ppe_4.1.png'),
                  _buildQuestionAnswer("😷 கசியலுக்கு எப்படி பரிசோதிக்கலாம்?", "ஒவ்வொரு முறையும் பயன்படுத்தும் முன் சீல் சோதனை செய்ய வேண்டும்."),
                  _buildQuestionAnswer("😷 வேலைகளுக்கு துணி முகக்கவசம் போதுமா?", "இல்லை, சான்றளிக்கப்பட்ட ரெஸ்பிரேட்டர்கள் மட்டுமே பயன்படுத்த வேண்டும்."),
                  _buildQuestionAnswer("😷 வடிகட்டிகள் எப்படிப் பணியாற்றுகின்றன?", "தீங்கு விளைவிக்கும் துகள்கள், வாயுக்கள் ஆகியவற்றை பிடித்து அல்லது செயலிழக்கச் செய்கின்றன."),
                  _buildQuestionAnswer("😷 ரெஸ்பிரேட்டர் கார்ட்ரிட்ஜ் என்றால் என்ன?", "புதுப்பிக்கக்கூடிய வடிகட்டி; காற்றை சுத்திகரிக்கிறது.", imagePath: 'assets/ppe_4.2.png'),
                  _buildQuestionAnswer("😷 யார் இந்த நெறிமுறைகளை பின்பற்றச் செய்ய வேண்டும்?", "தொழிலாளர் மற்றும் பாதுகாப்பு அலுவலர்கள் கட்டாயமாக இது செயல் படுத்த வேண்டும்."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("நிறைவு செய்யப்பட்டுள்ளது என குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி வினாடி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சி"),
              )
          ],
        ),
      ),
    );
  }
}
