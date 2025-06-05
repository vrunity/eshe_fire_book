import 'package:e_she_book/tamil/first_aid_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BurnsAndScaldsPage extends StatefulWidget {
  @override
  _BurnsAndScaldsPageState createState() => _BurnsAndScaldsPageState();
}

class _BurnsAndScaldsPageState extends State<BurnsAndScaldsPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "BurnsAndScalds";

  final Map<int, String> correctAnswers = {
    1: "வெப்பம் ஏற்படும் போது தோலில் ஏற்படும் பாதிப்பு - வெப்பம் அல்லது இரட்டை மூடியலான நீராவி காரணமாக ஏற்படும் போது ஸ்கால்ட்கள்",
    2: "முதல், இரண்டாம் மற்றும் மூன்றாம் நிலை எரிப்புகள்",
    3: "10-20 நிமிடங்கள் வரை ஓடும் தண்ணீரில் புணையை குளிரச் செய்யவும்",
    4: "ஆம், இது தொற்றை ஏற்படுத்தும் வாய்ப்பு உள்ளது",
    5: "தூய்மை மற்றும் ஒட்டாத துணியை பயன்படுத்தவும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "வெப்பம் மற்றும் ஸ்கால்ட்களுக்கு இடையிலான வேறுபாடு என்ன?",
      "options": [
        "வெப்பம் உலர்ந்த வெப்பத்திலிருந்து, ஸ்கால்ட்கள் வெப்ப நீர்வரையிலிருந்து ஏற்படும்",
        "இவை இரண்டும் ஒன்றே",
        "ஸ்கால்ட்கள் வேதிப்பொருட்களால் ஏற்படும்",
        "வெப்பம் மிகவும் மெல்லியதாக இருக்கும்"
      ]
    },
    {
      "question": "எரிப்புகளின் வகைகள் என்ன?",
      "options": [
        "முதல், இரண்டாம் மற்றும் மூன்றாம் நிலை எரிப்புகள்",
        "மிதமானது மற்றும் கடுமையானது",
        "வெளிப்புறம் மற்றும் உள்ளுறுப்புகள்",
        "வேதியியல் மற்றும் இயற்பியல்"
      ]
    },
    {
      "question": "சிறிய எரிப்புக்கு முதலில் என்ன செய்ய வேண்டும்?",
      "options": [
        "பற்பசை தடிக்கவும்",
        "10-20 நிமிடங்கள் ஓடும் தண்ணீரில் குளிரச் செய்யவும்",
        "பனிக்கட்டியை வைக்கவும்",
        "வெண்ணெய் தடிக்கவும்"
      ]
    },
    {
      "question": "எரிப்புகளில் ஏற்படும் கொப்பளங்களை வெடிக்கவா வேண்டும்?",
      "options": [
        "ஆம், உள்ளிருப்புகளை வெளியேற்ற",
        "இல்லை, தொற்று ஏற்படும் வாய்ப்பு உள்ளது",
        "வளர்ந்தவைகளுக்கு மட்டும்",
        "எப்போதும் வெடிக்கவும்"
      ]
    },
    {
      "question": "எரிப்புகளுக்கு எந்த வகையான துணியை பயன்படுத்த வேண்டும்?",
      "options": [
        "டிஷ்யூ பேப்பர்",
        "பஞ்சு",
        "பிளாஸ்டிக் ஷீட்",
        "தூய்மையான, ஒட்டாத துணி"
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
              title: Text("வெப்பம் மற்றும் ஸ்கால்ட்கள் க்விஸ்"),
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
                        SnackBar(content: Text("அனைத்து கேள்விகளுக்கும் பதில் அளிக்கவும்.")),
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
          title: Text("முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score > 3)
              TextButton(
                child: Text("அடுத்த பாடம்"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/fractures_and_sprains_ta');
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
                child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity, height: 180),
              ),
            if (imagePath != null) SizedBox(height: 12),
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 6),
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => firstaid_tamil()),
              );
            },
          ),title: Text("வெப்பம் மற்றும் ஸ்கால்ட்கள்")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 வெப்பம் என்றால் என்ன?", "வெப்பம், வெப்பம் அல்லது வேதிப்பொருட்கள் போன்றவைகளால் தோலின் பாதிப்பு."),
                  _buildQuestionAnswer("🔥 ஸ்கால்ட் என்றால் என்ன?", "வெப்ப நீர் அல்லது நீராவியால் ஏற்படும் தோல் காயம்."),
                  _buildQuestionAnswer("🔥 எரிப்புகளின் நிலைகள் என்ன?", "முதல் நிலை (சிவந்த தோல்), இரண்டாம் நிலை (கொப்பளங்கள்), மூன்றாம் நிலை (ஆழமான கட்டமைப்பு பாதிப்பு)."),
                  _buildQuestionAnswer("🔥 சிறிய எரிப்புக்கு முதலில் என்ன செய்ய வேண்டும்?", "10–20 நிமிடங்கள் ஓடும் தண்ணீரில் குளிரச்செய்யவும்."),
                  _buildQuestionAnswer("🔥 பனியை பயன்படுத்தலாமா?", "இல்லை, பனி தோலை மேலும் பாதிக்கலாம்."),
                  _buildQuestionAnswer("🔥 எரிப்புகளில் என்ன தடிக்கக் கூடாது?", "வெண்ணெய், எண்ணெய், பற்பசை ஆகியவை தடிக்க கூடாது."),
                  _buildQuestionAnswer("🔥 கொப்பளங்களை வெடிக்கலாமா?", "இல்லை, தொற்று ஏற்படலாம்."),
                  _buildQuestionAnswer("🔥 குளிர்ச்சிக்கு பிறகு எவ்வாறு மூட வேண்டும்?", "தூய்மையான, ஒட்டாத துணி அல்லது கிளிங் ஃபில்ம் பயன்படுத்தவும்."),
                  _buildQuestionAnswer("🔥 எப்போது மருத்துவரை அணுக வேண்டும்?", "எரிப்பு பெரியதாக, ஆழமாக, முகம்/கை/பாலுறுப்புகள் பாதிக்கப்பட்டால்."),
                  _buildQuestionAnswer("🔥 கடுமையான எரிப்பின் அறிகுறிகள் என்ன?", "கரிந்த தோல், வெண்மையான புள்ளிகள் அல்லது உணர்விழப்பு."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முழுமையாக்கப்பட்டது என குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி க்விஸ் மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
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
