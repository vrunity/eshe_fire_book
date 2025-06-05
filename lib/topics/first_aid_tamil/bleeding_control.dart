import 'package:e_she_book/tamil/first_aid_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BleedingControlPage extends StatefulWidget {
  @override
  _BleedingControlPageState createState() => _BleedingControlPageState();
}

class _BleedingControlPageState extends State<BleedingControlPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "BleedingControl";

  final Map<int, String> correctAnswers = {
    1: "இரத்த நாளங்கள் காயமடைவதால்",
    2: "தோல் கீழ், நரம்பு, அர்டீரி",
    3: "அடிக்கடி அழுத்தம் தர வேண்டும்",
    4: "தூய துணி அல்லது ஸ்டெரைல் பட்டி",
    5: "தொற்று பரவாமல் இருக்கவும், இரத்தம் கட்டுப்படுத்தவும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "இரத்தசோகை ஏற்படுவது எதனால்?",
      "options": [
        "இரத்த நாளங்கள் காயமடைவதால்",
        "காய்ச்சல் காரணமாக",
        "தோல் சொறி காரணமாக",
        "தண்ணீர் குடிக்காமல் இருப்பது"
      ]
    },
    {
      "question": "இரத்தம் வடிவங்களாக எத்தனை வகைகள் உள்ளன?",
      "options": [
        "தோல் கீழ், நரம்பு, அர்டீரி",
        "சிறிய, நடுத்தர, பெரிய",
        "மேலோட்ட, ஆழமான, உள்",
        "வெளிப்புறம் மட்டும்"
      ]
    },
    {
      "question": "வெளிப்புற இரத்தத்தை கட்டுப்படுத்த முதல் நடவடிக்கை?",
      "options": [
        "அடிக்கடி அழுத்தம் தர வேண்டும்",
        "தண்ணீர் தெளிக்க வேண்டும்",
        "காற்றுக்கு வெளிப்படுத்தவும்",
        "அழுத்தமின்றி பட்டி போடுங்கள்"
      ]
    },
    {
      "question": "காயத்தை மூட எது பயன்படுத்தலாம்?",
      "options": [
        "தூய துணி அல்லது ஸ்டெரைல் பட்டி",
        "பிளாஸ்டிக் ஷீட்",
        "திசு பேப்பர்",
        "காடன் பாலின்"
      ]
    },
    {
      "question": "முதலுதவி கொடுப்பதற்கு முன் கைகளை கழுவுவதன் முக்கியத்துவம்?",
      "options": [
        "தொற்று பரவாமல் இருக்கவும், இரத்தம் கட்டுப்படுத்தவும்",
        "தொழில்முறை போல தோன்ற",
        "தன்னைத்தான் சுத்தம் செய்ய",
        "தேவை இல்லை"
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
              title: Text("இரத்த கட்டுப்பாடு கேள்விகள்"),
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
          title: Text("மதிப்பெண் முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score > 3)
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/burns_and_scalds_ta');
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
            Text(
              question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 6),
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
          ),title: Text("இரத்த கட்டுப்பாடு")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🩸 இரத்த சிந்தல் ஏற்பட காரணம் என்ன?", "இரத்த நாளங்கள் காயமடைந்தால் அல்லது தாக்கம் காரணமாக இரத்த சிந்தல் ஏற்படுகிறது.", imagePath: 'assets/first_aid_2.0.png'),
                  _buildQuestionAnswer("🩸 இரத்த சிந்தலின் மூன்று வகைகள் என்ன?", "தோல் அடியில் (Capillary), நரம்பு (Venous), மற்றும் அர்டீரி (Arterial) இரத்த சிந்தல்."),
                  _buildQuestionAnswer("🩸 இரத்த சிந்தலை கட்டுப்படுத்த முதலில் என்ன செய்ய வேண்டும்?", "தூய துணியுடன் காயத்தின் மீது நேரடியாக அழுத்தம் கொடுக்க வேண்டும்.", imagePath: 'assets/first_aid_1.2.png'),
                  _buildQuestionAnswer("🩸 டூர்னிகேட் (Tourniquet) பயன்படுத்தலாமா?", "ஆம், ஆனால் மிகவும் கடுமையான இரத்த சிந்தல் கட்டுப்படாத நிலையில் மட்டும் பயன்படுத்த வேண்டும்."),
                  _buildQuestionAnswer("🩸 கையுறை ஏன் அணிய வேண்டும்?", "முதலுதவி அளிப்பவரும் பாதிக்கப்பட்டவரும் தொற்றுகளில் இருந்து பாதுகாக்கப்பட வேண்டும்.", imagePath: 'assets/first_aid_2.2.png'),
                  _buildQuestionAnswer("🩸 உடலுக்கு பதிக்கப்பட்ட பொருளை அகற்றலாமா?", "இல்லை. அவற்றை நிலைப்படுத்தி அதன் சுற்றுவட்டமாக அழுத்தம் கொடுக்க வேண்டும்."),
                  _buildQuestionAnswer("🩸 உள் இரத்த சிந்தல் என்றால் என்ன?", "உடலுக்குள் ஏற்படும், வெளிப்படையாக தெரியாத இரத்த சிந்தல்.", imagePath: 'assets/first_aid_1.0.png'),
                  _buildQuestionAnswer("🩸 உள் இரத்த சிந்தலை குறிக்கும் அறிகுறிகள்?", "வலி, வீக்கம், அடர் நீல அடையாளங்கள் அல்லது மயக்கம் போன்ற ஷாக் அறிகுறிகள்."),
                  _buildQuestionAnswer("🩸 இரத்தம் கசியும் அங்கத்தை எப்படி வைக்க வேண்டும்?", "இதயம் உயரத்திற்கு மேல் நிலைக்க வைக்க வேண்டும், இரத்த ஓட்டத்தை குறைக்க.",imagePath: 'assets/first_aid_2.4.png'),
                  _buildQuestionAnswer("🩸 எப்போது அவசர உதவிக்கு அழைக்க வேண்டும்?", "இரத்த சிந்தல் மிக அதிகமாக இருந்தால், தொடர்ச்சியாக இருந்தால், அல்லது ஷாக் அறிகுறிகள் இருந்தால் உடனே அழைக்கவும்."),
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
