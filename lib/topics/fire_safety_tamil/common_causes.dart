import 'package:e_she_book/tamil/fire_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonCausesPage extends StatefulWidget {
  @override
  _CommonCausesPageState createState() => _CommonCausesPageState();
}

class _CommonCausesPageState extends State<CommonCausesPage> {
  bool istopic_2_Completed = false;
  int quizScore = 0;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "CommonCauses"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "மின் ஓட்ட மிகை மற்றும் பழுதான வயரிங்",
    2: "600°C (1,112°F)",
    3: "பராமரிப்பு இல்லாமை, பழுதடைந்த வயர்கள், எரிவாயு ஒளிப்பு",
    4: "மின்தொட்டுகள் எரியும் வாயுக்கள் அல்லது தூள்களை எரிக்கச் செய்யும்",
    5: "சரியான சேமிப்பு, மின் பரிசோதனை, தீ பாதுகாப்பு பயிற்சி",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "தீ ஏற்படும் பொதுவான காரணம் எது?",
      "options": [
        "மின் ஓட்ட மிகை மற்றும் பழுதான வயரிங்",
        "குளிர்ந்த வானிலை",
        "சுத்தமான ஆக்சிஜன் சூழல்",
        "மேலே எதுவும் இல்லை"
      ]
    },
    {
      "question": "சிகரெட் எரியும் வெப்பநிலை எவ்வளவு?",
      "options": [
        "100°C (212°F)",
        "300°C (572°F)",
        "600°C (1,112°F)",
        "900°C (1,652°F)"
      ]
    },
    {
      "question": "தீ விபத்துகள் ஏற்படும் வாய்ப்பு ஏன் அதிகமாகிறது?",
      "options": [
        "பராமரிப்பு இல்லாமை, பழுதடைந்த வயர்கள், எரிவாயு ஒளிப்பு",
        "வழக்கமான உபகரண பரிசோதனைகள்",
        "அவசர தயார் நிலை",
        "தீ அணைப்பான்கள்"
      ]
    },
    {
      "question": "மின்னியல் நிலைத்துறை தீயை எப்படி ஏற்படுத்துகிறது?",
      "options": [
        "இது தீ அலாரங்களை இயக்குகிறது",
        "மின்தொட்டுகள் எரியும் வாயுக்கள் அல்லது தூள்களை எரிக்கச் செய்யும்",
        "இது சூடான மேற்பரப்புகளை குளிர்விக்கிறது",
        "மின் அதிர்வுகளைத் தடுக்கிறது"
      ]
    },
    {
      "question": "தொழிலிடங்களில் தீயைத் தடுப்பதற்கு என்ன செய்ய வேண்டும்?",
      "options": [
        "சரியான சேமிப்பு, மின் பரிசோதனை, தீ பாதுகாப்பு பயிற்சி",
        "தீ பயிற்சிகளை புறக்கணித்தல்",
        "மின் சொக்கெட்டுகளை அதிகம் பயன்படுத்துதல்",
        "எரியும் திரவங்களை திறந்துவைத்தல்"
      ]
    },
  ];



  @override
  void initState() {
    super.initState();
    _load_topic_2_CompletionStatus();
  }

  Future<void> _load_topic_2_CompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      istopic_2_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? 0;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _save_topic_2_CompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_2_Completed = value;
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
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Common Causes of Fire Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int questionIndex = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question["question"],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
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
                  child: Text("சமர்ப்பிக்கவும்"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(Navigator.of(context, rootNavigator: true).context).showSnackBar(
                        SnackBar(content: Text("அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")), // Tamil message
                      );
                    } else {
                      Navigator.of(dialogContext, rootNavigator: true).pop();
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
          content: Text("You scored $score out of ${quizQuestions.length}."),
          actions: [
            TextButton(
              child: Text("	சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score > 3) // ✅ Show Next Topic only if score > 3
              TextButton(
                child: Text("அடுத்த பகுதி"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/fire_extinguishers_ta'); // Navigate to next topic page
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove shadow for clean UI
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF4500), Color(0xFF5B0000)], // Red to Dark Maroon
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28), // Back Arrow
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => fire_safety_tamil()),
              );
            },
          ),title: Text("தீ ஏற்படும் பொதுவான காரணங்கள் - வினாடி வினா"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer(
                      "🔥 தீ ஏற்படும் முக்கிய காரணங்கள் என்ன?",
                      "தீ வெடிப்புகள் பல காரணங்களால் ஏற்படலாம். இதில் பொதுவாக மனித தவறுகள், மின் குறைபாடுகள், மற்றும் எரியும் பொருட்களின் தவறான கையாளுதல் அடங்கும். "
                          "பாதுகாப்பின்றி விட்டுவைக்கப்படும் தீ மூலங்கள், தூக்கப்படாத சிகரெட் முடிச்சுகள் மற்றும் எரியும் பொருட்களின் நேரடி தொடர்பு தீ விபத்துகளுக்கு வழிவகுக்கும். "
                          "மின் கோளாறுகள், அதிகம் மின் சுமை கட்டமைப்புகள், மற்றும் பழுதடைந்த வயரிங் ஆகியவை பெரும்பாலும் தீக்காய்ச்சல்களை உருவாக்குகின்றன.",
                      imagePath: 'assets/banner_2.1.jpg'
                  ),

                  _buildQuestionAnswer(
                      "🔥 எரியும் பொருட்களுக்கு அருகில் புகைப்பிடிப்பது ஏன் ஆபத்தானது?",
                      "சிகரெட்டுகள் சுமார் 600°C (1,112°F) வெப்பநிலையை அடைவதால், அது எளிதில் எரியும் திரவங்கள் மற்றும் வாயுக்களை எரிக்கச் செய்யும். "
                          "போதைப்பொருட்கள், கெமிக்கல்கள், அல்லது உலர்ந்த பசுந்தளைகள் அருகில் புகைப்பிடிப்பது தீ விபத்து ஏற்படச்செய்யும். "
                          "தவறாக அணைக்கப்படாத சிகரெட் முடிச்சுகள் காட்டுத் தீக்கும், தொழிற்துறை தீக்கும் முக்கிய காரணமாக உள்ளன."
                  ),

                  _buildQuestionAnswer(
                      "🔥 பராமரிப்பு இல்லாமை எவ்வாறு தீ அபாயத்தை அதிகரிக்கிறது?",
                      "மின் உபகரணங்கள், எரிவாயு பைப்கள், மற்றும் தொழில்துறை இயந்திரங்கள் ஆகியவை முறையாக பராமரிக்கப்படவில்லை என்றால், அதனால் தீ அபாயம் ஏற்படக்கூடும். "
                          "பழுதடைந்த வயர்கள், கசிந்த வாயுக்கள் மற்றும் தூசியால் மூடிய எலக்ட்ரிக் பேனல்கள் ஆகியவை தீப்பற்றி பரவும் வாய்ப்பை அதிகரிக்கும். "
                          "வழக்கமான பரிசோதனைகள் மற்றும் பராமரிப்பு செயல்கள் தீ விபத்தைத் தடுக்கும் முக்கியமானவை."
                  ,imagePath: 'assets/banner_2.2.jpg'
                  ),

                  _buildQuestionAnswer(
                      "🔥 மின்தொட்டு எப்படி தீக்கதிராக மாறும்?",
                      "மின்தொட்டுகள் மேற்பரப்புகளில் மின்சாரம் சேர்ந்து நிலைத்துறையை உருவாக்கும். "
                          "இது திடீரென வெளிச்சமாகும் போது, ஒரு சிறிய மின்சாரக்கதிர் உருவாகும், அது எளிதில் எரியும் வாயுக்கள் மற்றும் தூள் அருகில் இருந்தால் தீ உருவாக்கும். "
                          "இதனைத் தடுக்கும் விதமாக, நிலைத்துறை எதிர்ப்பு உடைகள் அணிவது, பூமியுடன் இணைக்கப்பட்ட சாதனங்களை பயன்படுத்துவது முக்கியம்."
                  ),

                  _buildQuestionAnswer(
                      "🔥 தொழிலிடங்களில் தீயைத் தடுப்பதற்கான வழிமுறைகள் என்ன?",
                      "1. எரியும் பொருட்களை பாதுகாப்பாக சேமித்து வைக்க வேண்டும்\n"
                          "2. மின் பரிசோதனைகளை முறையாக நடத்த வேண்டும்\n"
                          "3. ஊழியர்களுக்கு தீ பாதுகாப்பு பயிற்சி வழங்க வேண்டும்\n"
                          "4. கழிவுகளை நியமப்படி அகற்ற வேண்டும்\n"
                          "5. தீ அலாரங்கள் மற்றும் நீர் தெளிப்பான்கள் பொருத்தப்பட வேண்டும்"
                  ,imagePath: 'assets/banner_2.3.jpg'
                  ),

                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: istopic_2_Completed,
              onChanged: (value) {
                _save_topic_2_CompletionStatus(value ?? false);
              },
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
}