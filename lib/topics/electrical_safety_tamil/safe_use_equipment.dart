import 'package:e_she_book/tamil/electrical_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafeUseEquipmentPageTamil extends StatefulWidget {
  @override
  _SafeUseEquipmentPageTamilState createState() => _SafeUseEquipmentPageTamilState();
}

class _SafeUseEquipmentPageTamilState extends State<SafeUseEquipmentPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "SafeUseEquipmentTamil";

  final Map<int, String> correctAnswers = {
    1: "பயன்படுத்துவதற்கு முன் உபகரணங்களை ஆய்வு செய்ய வேண்டும்",
    2: "உற்பத்தியாளர் வழிமுறைகளின்படி உபகரணங்களை பயன்படுத்த வேண்டும்",
    3: "பாதிக்கப்பட்ட உபகரணங்களை புகாரளித்து மாற்ற வேண்டும்",
    4: "உபகரணங்களை வற்றிய மற்றும் நீர் இல்லாத இடங்களில் வைக்கவும்",
    5: "அணைத்து பிளக் அகற்ற வேண்டும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {"question": "எந்த மின் உபகரணத்தையும் பயன்படுத்துவதற்கு முன் என்ன செய்ய வேண்டும்?", "options": ["பயன்படுத்துவதற்கு முன் உபகரணங்களை ஆய்வு செய்ய வேண்டும்", "உடனே இயக்கவும்", "அதை முதலில் குலைக்கவும்", "துவைக்கவும்"]},
    {"question": "உபகரணங்களை பாதுகாப்பாக எப்படி பயன்படுத்த வேண்டும்?", "options": ["உற்பத்தியாளர் வழிமுறைகளின்படி உபகரணங்களை பயன்படுத்த வேண்டும்", "உருவாக்கம் போல் பயன்படுத்தவும்", "சீரற்ற முறையில் பொத்தான்களை அழுத்தவும்", "இரவில் மட்டும் பயன்படுத்தவும்"]},
    {"question": "உபகரணங்கள் சேதமடைந்தால் என்ன செய்ய வேண்டும்?", "options": ["பாதிக்கப்பட்ட உபகரணங்களை புகாரளித்து மாற்ற வேண்டும்", "அதை புறக்கணித்து தொடர்ந்து பயன்படுத்தவும்", "டேப் ஒட்டவும்", "மறைத்து வைக்கவும்"]},
    {"question": "உபகரணங்களை ஈரப்பதத்திலிருந்து எவ்வாறு பாதுகாப்பது?", "options": ["உபகரணங்களை வற்றிய மற்றும் நீர் இல்லாத இடங்களில் வைக்கவும்", "தண்ணீரில் மூழ்கடிக்கவும்", "முகே நெருக்கமாக வைக்கவும்", "பிளாஸ்டிக் போர்வையால் மூடவும்"]},
    {"question": "பயன்பாட்டில் இல்லாத போது என்ன செய்ய வேண்டும்?", "options": ["அணைத்து பிளக் அகற்ற வேண்டும்", "நிறுத்தாமல் இயக்க விடவும்", "சக்தியை நிலைநிறுத்தவும்", "மாற்று சுவிட்சை மறைக்கவும்"]}
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
              title: Text("மின் உபகரணங்களை பாதுகாப்பாக பயன்படுத்துதல் - வினா"),
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
                  child: Text("சமர்ப்பிக்கவும்"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("அனைத்து கேள்விகளுக்கும் பதில் அளிக்கவும்")),
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
          title: Text("வினா முடிவுகள்"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்களை பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/emergency_procedures_ta'); // ✅ Correct Tamil Next Topic
                },
              ),
            TextButton(
              child: Text("மீண்டும் முயற்சிக்கவும்"),
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
            if (imagePath != null) SizedBox(height: 12),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ElectricalSafetyTamil()),
            );
          },
        ),
        title: Text("மின் உபகரணங்களை பாதுகாப்பாக பயன்படுத்துதல்"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("⚡ எந்த மின் உபகரணத்தையும் பயன்படுத்துவதற்கு முன் என்ன செய்ய வேண்டும்?", "பயன்படுத்துவதற்கு முன் உபகரணங்களை ஆய்வு செய்ய வேண்டும்.", imagePath: 'assets/electrical_4.0.png'),
                  _buildQuestionAnswer("⚡ உபகரணங்களை எப்படி பாதுகாப்பாக பயன்படுத்த வேண்டும்?", "உற்பத்தியாளர் வழிமுறைகளின்படி பயன்படுத்த வேண்டும்."),
                  _buildQuestionAnswer("⚡ உபகரணங்கள் சேதமடைந்தால் என்ன செய்ய வேண்டும்?", "பாதிக்கப்பட்ட உபகரணங்களை புகாரளித்து மாற்ற வேண்டும்.", imagePath: 'assets/electrical_4.1.png'),
                  _buildQuestionAnswer("⚡ ஈரப்பதத்திலிருந்து உபகரணங்களை எவ்வாறு பாதுகாப்பது?", "உபகரணங்களை வற்றிய மற்றும் நீர் இல்லாத இடங்களில் வைக்க வேண்டும்."),
                  _buildQuestionAnswer("⚡ உபகரணத்தை பயன்படுத்தாமல் இருந்தால் என்ன செய்ய வேண்டும்?", "அணைத்து பிளக் அகற்ற வேண்டும்.", imagePath: 'assets/electrical_4.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி வினாடி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சி செய்யவும்"),
              ),
          ],
        ),
      ),
    );
  }
}
