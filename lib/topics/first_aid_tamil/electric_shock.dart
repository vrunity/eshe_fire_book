import 'package:e_she_book/english/first_aid_english.dart';
import 'package:e_she_book/tamil/first_aid_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElectricShockPage extends StatefulWidget {
  @override
  _ElectricShockPageState createState() => _ElectricShockPageState();
}

class _ElectricShockPageState extends State<ElectricShockPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ElectricShock";

  final Map<int, String> correctAnswers = {
    1: "மின்சாரம் உடல் வழியாக செல்லும் போது ஏற்படும் பாதிப்பு",
    2: "பாதிக்கப்பட்டவரை தொடுவதற்கு முன் மின்சாரத்தை அணைக்கவும்",
    3: "மரம், பிளாஸ்டிக் பொருள் அல்லது உலர்ந்த துணி",
    4: "தீக்காயங்கள், உணர்விழப்பு அல்லது இதய நின்றுபோவது",
    5: "அவசர சேவையை அழைக்கவும், தேவைப்பட்டால் CPR துவங்கவும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "மின்சார அதிர்ச்சி என்றால் என்ன?",
      "options": [
        "நிலைத்த மின்சாரம்",
        "மின்சாரம் உடல் வழியாக செல்லும் போது ஏற்படும் பாதிப்பு",
        "பேட்டரி செயலிழப்பு",
        "ஒரு குளிர்ச்சியான உணர்வு"
      ]
    },
    {
      "question": "யாராவது மின்சாரம் அடித்திருந்தால் முதல் நடவடிக்கை என்ன?",
      "options": [
        "உடனே அவரைத் தொடவும்",
        "பாதிக்கப்பட்டவரை தொடுவதற்கு முன் மின்சாரத்தை அணைக்கவும்",
        "தண்ணீர் தெளிக்கவும்",
        "அவரை அசைக்கவும்"
      ]
    },
    {
      "question": "மின்சாரத்திலிருந்து பாதிக்கப்பட்டவரை பிரிக்க எதை பயன்படுத்தலாம்?",
      "options": [
        "இரும்புச் கம்பி",
        "நனைந்த கயிறு",
        "மரம், பிளாஸ்டிக் பொருள் அல்லது உலர்ந்த துணி",
        "உங்கள் கைகள்"
      ]
    },
    {
      "question": "மின்சார அதிர்ச்சியின் விளைவுகள் என்ன?",
      "options": [
        "தீக்காயங்கள், உணர்விழப்பு அல்லது இதய நின்றுபோவது",
        "வெறும் தோல் வீக்கம்",
        "மிதமான காய்ச்சல்",
        "விளைவில்லை"
      ]
    },
    {
      "question": "பாதிக்கப்பட்டவரை மின்சாரத்திலிருந்து பிரித்த பின் என்ன செய்ய வேண்டும்?",
      "options": [
        "அவரை தனியாக விட்டுவிடவும்",
        "அவசர சேவையை அழைக்கவும், தேவைப்பட்டால் CPR துவங்கவும்",
        "புகைப்படம் எடுக்கவும்",
        "மற்றவர் வரும்வரை காத்திருக்கவும்"
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
              title: Text("Electric Shock Quiz"),
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
                  Navigator.pushNamed(context, '/cpr_for_adults_en'); // Navigate to next topic page
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
          ),title: Text("மின்சாரம் அடிபடுதல்")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("⚡ மின்சாரம் அடிபடுதல் என்றால் என்ன?", "மின்சாரம் ஒரு மனித உடல் வழியாக செல்லும்போது, அது உடலின் செயல் முறை பாதிப்பை ஏற்படுத்தும். இது தீக்காயம், இதயநிறைவு, அல்லது உயிரிழப்பிற்கு கூட காரணமாக இருக்கலாம்.", imagePath: 'assets/first_aid_5.0.png'),

                  _buildQuestionAnswer("⚡ முதலில் என்ன செய்ய வேண்டும்?", "மின்சாரத்தை முழுமையாக அணைத்த பின் மட்டுமே பாதிக்கப்பட்டவரைத் தொட வேண்டும். நேரடியாகத் தொடக்கூடாது."),

                  _buildQuestionAnswer("⚡ பாதுகாப்பாக பிரிக்க எது பயன்படுத்தலாம்?", "மர கம்பி, பிளாஸ்டிக் கைப்பிடி, உலர்ந்த துணி போன்ற மின்சாரம் செலுத்தாத பொருட்கள்.", imagePath: 'assets/first_aid_5.1.png'),

                  _buildQuestionAnswer("⚡ மின்சாரம் அடிபடுதலால் ஏற்படும் பாதிப்புகள்?", "தீக்காயம், உணர்விழப்பு, சுவாச சிக்கல், இதய செயலிழப்பு போன்றவை ஏற்படலாம்."),

                  _buildQuestionAnswer("⚡ மருத்துவர் உதவிக்கு அழைக்க வேண்டுமா?", "ஆம். உடனடியாக அவசர உதவி அழைக்கவும். தேவைப்பட்டால் CPR செய்யவும்.", imagePath: 'assets/first_aid_5.2.png'),

                  _buildQuestionAnswer("⚡ மின்சாரம் அடிபட்ட பின் ஏற்படக்கூடிய அறிகுறிகள்?", "சுவாசக் குறைபாடு, இதயத் துடிப்பு மாறுதல், உணர்விழப்பு மற்றும் தோலின் சேதம்."),

                  _buildQuestionAnswer("⚡ மீட்பின் போது தண்ணீர் பயன்படுத்தலாமா?", "இல்லை. தண்ணீர் மின்சாரத்தை கடத்தக்கூடியதால் மேலும் ஆபத்தாக இருக்கலாம்.", imagePath: 'assets/first_aid_5.3.png'),

                  _buildQuestionAnswer("⚡ உடையை அகற்றலாமா?", "தீ பிடித்த உடைகளை அகற்றலாம். ஆனால் தீயால் சருமத்தோடு ஒட்டியிருந்தால் அகற்றக் கூடாது."),

                  _buildQuestionAnswer("⚡ எதை தவிர்க்க வேண்டும்?", "மின்சாரம் ஓடிக்கொண்டிருந்தால், ஒருவரையும் நேரடியாகத் தொடக்கூடாது.", imagePath: 'assets/first_aid_5.4.png'),

                  _buildQuestionAnswer("⚡ பாதிக்கப்பட்டவரை தனியாக விட்டுவிடலாமா?", "இல்லை. சுவாசத்தை கண்காணிக்கவும், அவருக்கு நிம்மதியளிக்கவும். உதவி வரும் வரை கவனிக்கவும்."),
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
