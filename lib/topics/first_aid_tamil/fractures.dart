import 'package:e_she_book/english/first_aid_english.dart';
import 'package:e_she_book/tamil/first_aid_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FracturesAndSprainsPage extends StatefulWidget {
  @override
  _FracturesAndSprainsPageState createState() => _FracturesAndSprainsPageState();
}

class _FracturesAndSprainsPageState extends State<FracturesAndSprainsPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FracturesAndSprains";

  final Map<int, String> correctAnswers = {
    1: "எலும்பில் ஏற்படும் முறிவு அல்லது பிளவு",
    2: "வீக்கம், வலி, நகர முடியாமை, நீலமாகும் தன்மை",
    3: "தாங்கி வைத்து அங்கத்தை நிலைநிறுத்தவும்",
    4: "தேவை இல்லாமல் பாதிக்கப்பட்ட நபரை நகர்த்த வேண்டாம்",
    5: "ஆம், குறிப்பாக பாதிப்பு மிக மோசமாக இருந்தால் அல்லது மேலும் சேதம் ஏற்பட வாய்ப்பிருந்தால்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "எலும்பு முறிவு என்றால் என்ன?",
      "options": [
        "தசை கிழிப்பு",
        "எலும்பில் ஏற்படும் முறிவு அல்லது பிளவு",
        "தோலில் ஏற்பட்ட காயம்",
        "மேலே உள்ள எதுவுமில்லை"
      ]
    },
    {
      "question": "எலும்பு முறிவின் அறிகுறிகள் என்ன?",
      "options": [
        "வீக்கம், வலி, நகர முடியாமை, நீலமாகும் தன்மை",
        "இரத்தம் வருவது மட்டும்",
        "தும்மல்",
        "தலைவலி"
      ]
    },
    {
      "question": "எலும்பு முறிவை எப்படி கையாள வேண்டும்?",
      "options": [
        "தாங்கி வைத்து அங்கத்தை நிலைநிறுத்தவும்",
        "விரைவாக நபரை நகர்த்தவும்",
        "பாதிக்கப்பட்ட இடத்தில் மசாஜ் செய்யவும்",
        "லோஷன் தடவவும்"
      ]
    },
    {
      "question": "முறிவுற்ற அங்கத்தை நகர்த்த வேண்டுமா?",
      "options": [
        "ஆம், உடனே நகர்த்தவும்",
        "இல்லை, மிக அவசியமாக இருந்தால்தான் நகர்த்தவும்",
        "நெகிழ்வை சோதிக்க நகர்த்தவும்",
        "மிகவும் நகர்த்தவும்"
      ]
    },
    {
      "question": "முறிவுக்கு மருத்துவ உதவி தேவைப்படுமா?",
      "options": [
        "இல்லை, தேவையில்லை",
        "இரத்தம் வந்தால் மட்டும்",
        "ஆம், குறிப்பாக பாதிப்பு மிக மோசமாக இருந்தால் அல்லது மேலும் சேதம் ஏற்பட வாய்ப்பிருந்தால்",
        "ஒரு நாள் கழித்து மட்டும்"
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
              title: Text("Fractures and Sprains Quiz"),
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
                  Navigator.pushNamed(context, '/electric_shock_ta'); // Navigate to next topic page
                },
              ),
            TextButton(
              child: Text("Retest"),
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
          ),title: Text("எலும்பு முறிவு மற்றும் புள்ளிவலி"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Replace existing _buildQuestionAnswer(...) calls with the following Tamil version

                  _buildQuestionAnswer("🦴 எலும்பு முறிவு என்றால் என்ன?", "இது எதிர்பாராத தாக்கம் அல்லது அழுத்தத்தால் எலும்பில் ஏற்படும் முறிவு அல்லது பிளவு.", imagePath: 'assets/first_aid_4.0.png'),
                  _buildQuestionAnswer("🦴 புள்ளிவலி என்றால் என்ன?", "சுழலும் காரணமாக மூட்டுகளை சுற்றியுள்ள மூட்டந்தசுக்களுக்கு ஏற்பட்ட காயம்."),
                  _buildQuestionAnswer("🦴 எலும்பு முறிவின் அறிகுறிகள் என்ன?", "வீக்கம், நீலமாவது, வலி மற்றும் பாதிக்கப்பட்ட பகுதியை நகர்த்த முடியாமை.", imagePath: 'assets/first_aid_4.1.png'),
                  _buildQuestionAnswer("🦴 முறிவுக்கான முதன்மை முதலுதவி என்ன?", "தாங்கி அல்லது தூக்கியைப் பயன்படுத்தி அந்த பகுதியை நிலைநிறுத்த வேண்டும்."),
                  _buildQuestionAnswer("🦴 முறிவுக்கு சந்தேகமுள்ள நபரை நகர்த்தலாமா?", "மிக அவசியமான சூழ்நிலையைத் தவிர வேண்டாம். கவனமாக செயல்பட வேண்டும்.", imagePath: 'assets/first_aid_4.2.png'),
                  _buildQuestionAnswer("🦴 எலும்பை நேராக வைக்கலாமா?", "இல்லை. இது மருத்துவ நிபுணர்களின் பணி."),
                  _buildQuestionAnswer("🦴 புள்ளிவலிக்கு RICE முறை என்பது என்ன?", "RICE என்பது ஓய்வு (Rest), ஐஸ் (Ice), அழுத்தம் (Compression), உயர்த்தல் (Elevation).", imagePath: 'assets/first_aid_4.3.png'),
                  _buildQuestionAnswer("🦴 ஐஸ் எவ்வளவு நேரம் வைக்கலாம்?", "முதல் 48 மணி நேரத்தில் 2–3 மணி நேரத்திற்கு ஒருமுறை 15–20 நிமிடங்கள்."),
                  _buildQuestionAnswer("🦴 அவசர உதவி எப்போது தேவைப்படும்?", "எலும்பு வெளியில் தெரிந்தால் அல்லது அதிக இரத்தப்போக்கு இருந்தால் உடனே மருத்துவ உதவி தேவை.", imagePath: 'assets/first_aid_4.4.png'),
                  _buildQuestionAnswer("🦴 இறுக்கமான மோதிரங்கள் அல்லது கடிகாரங்களை அகற்றலாமா?", "ஆம். வீக்கம் அதிகரிக்கும் போது கட்டுப்பாடுகளைத் தடுக்கும் விதமாக அகற்ற வேண்டும்.")
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிக்கப்பட்டதாக குறிக்கவும்"),
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
