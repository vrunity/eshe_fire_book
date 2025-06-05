import 'package:e_she_book/tamil/fire_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireSafetyPage extends StatefulWidget {
  @override
  _FireSafetyPageState createState() => _FireSafetyPageState();
}

class _FireSafetyPageState extends State<FireSafetyPage> {
  bool istopic_1_Completed = false;
  int quizScore = -1;  // Default -1 means quiz not taken
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FireSafety";  // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "உயிரிழப்பு, சொத்து சேதம், சுற்றுச்சூழல் அழிவு",
    2: "புகைக் கணிப்பி மற்றும் தீ அணைப்பான் பொருத்துதல்",
    3: "வெளியேறு, வெளியே இரு, உதவிக்கு அழை",
    4: "லிப்ட் சிக்கிக்கொள்ளலாம்",
    5: "தாழ்வாக இருங்கள், உதவிக்கு சைகை செய்யவும், மூக்கு/வாயை துணியால் மூடுங்கள்",
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "தீயின் முக்கிய விளைவுகள் என்ன?",
      "options": [
        "உயிரிழப்பு, சொத்து சேதம், சுற்றுச்சூழல் அழிவு",
        "சொத்து சேதம் மட்டும்",
        "சிறிய தீ அபாயகரமல்ல",
        "மேலே எதுவும் இல்லை"
      ]
    },
    {
      "question": "பொதுவான தீ பாதுகாப்பு நடவடிக்கை எது?",
      "options": [
        "தீயுடன் விளையாடுதல்",
        "புகைக் கணிப்பி மற்றும் தீ அணைப்பான் பொருத்துதல்",
        "கதவுகளை திறந்தே விடுதல்",
        "அவசர வெளியேறும் வழிகளை புறக்கணித்தல்"
      ]
    },
    {
      "question": "தீ பாதுகாப்பில் ‘தங்கக் கோட்பு’ என்ன?",
      "options": [
        "தீயை நீங்களே அணைக்க முயலுங்கள்",
        "வெளியேறு, வெளியே இரு, உதவிக்கு அழை",
        "தீ அலாரத்தை புறக்கணிக்கவும்",
        "உதவிக்கு அழைத்து உள்ளேயே இருங்கள்"
      ]
    },
    {
      "question": "தீயில் லிப்ட் ஏன் பயன்படுத்தக்கூடாது?",
      "options": [
        "லிப்ட் சிக்கிக்கொள்ளலாம்",
        "விரைவாக வெளியேற உதவும்",
        "அவை தீயில் எரியாது",
        "மேலே எதுவும் இல்லை"
      ]
    },
    {
      "question": "எரியும் கட்டிடத்தில் சிக்கிக்கொண்டால் என்ன செய்ய வேண்டும்?",
      "options": [
        "தாழ்வாக இருங்கள், உதவிக்கு சைகை செய்யவும், மூக்கு/வாயை துணியால் மூடுங்கள்",
        "பதற்றம் கொண்டு கூச்சலிடவும்",
        "தீ எங்கே என்பதை பாராமல் ஓடுங்கள்",
        "தானாக தீ அணையும் வரை காத்திருங்கள்"
      ]
    },
  ];


  @override
  void initState() {
    super.initState();
    _load_topic_1CompletionStatus();
  }

  Future<void> _load_topic_1CompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      istopic_1_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1; // ✅ Load quiz score
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _save_topic_1_CompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_1_Completed = value;
    });

    if (value) {
      // Show quiz **after** status is saved
      Future.delayed(Duration(milliseconds: 300), () {
        _showQuizDialog();
      });
    }
  }

  Future<void> _saveQuizScore(String key,int score) async {
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
              title: Text("Fire Safety Quiz"),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("தயவுசெய்து அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
                      );
                    } else {
                      Navigator.pop(dialogContext); // ✅ Close the dialog first
                      _evaluateQuiz(); // ✅ Evaluate quiz after closing dialog
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
    _saveQuizScore("FireSafety", score); // ✅ Save the quiz score for this topic
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
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score > 3) // ✅ Show Next Topic only if score > 3
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/common_causes_ta'); // Navigate to next topic page
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
          ),title: Text("தீ பாதுகாப்பு அறிமுகம்")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer(
                    "🔥 தீ பாதுகாப்பு என்றால் என்ன? ஏன் இது முக்கியம்?",
                    "தீ பாதுகாப்பு என்பது தீ விபத்துகளை தடுப்பதற்கும் குறைப்பதற்குமான முன்னெச்சரிக்கைகளை குறிக்கும்.\n\nஇது முக்கியமானது ஏனெனில் தீ:\n\n• உயிரிழப்பு\n• சொத்த சேதம்\n• சுற்றுச்சூழல் அழிவு\n\nஇவற்றைத் தவிர்க்க தீ பாதுகாப்பு நடைமுறைகளைப் பின்பற்ற வேண்டும்.",
                    imagePath: 'assets/banner.jpg',
                  ),

                  _buildQuestionAnswer("🔥 பொதுவான தீ பாதுகாப்பு நடவடிக்கைகள் என்ன?",
                      "1. புகை கணிப்பிகள் மற்றும் தீ அணைப்பான்கள் பொருத்துதல்\n2. மின்சாதனங்களை பராமரித்தல்\n3. எரிபொருட்களை பாதுகாப்பாக சேமித்தல்\n4. தீ அவசர வெளியேறும் திட்டம் வைத்திருத்தல்\n5. தீ பயிற்சிகள் நடத்தல்",
                    ),

                  _buildQuestionAnswer("🔥 தீ பாதுகாப்பு திட்டத்தில் என்ன இருக்க வேண்டும்?",
                      "1. தெளிவான வெளியேறும் நடைமுறை\n2. குறிக்கப்பட்ட அவசர வெளியேறும் வழிகள்\n3. தீ அலாரங்கள் மற்றும் அணைப்பான்களின் இடம்\n4. அவசர சேவைகள் தொடர்பு விவரங்கள்\n5. ஒவ்வொருவரின் பொறுப்புகள்",
                      imagePath: 'assets/banner_2.jpg'),

                  _buildQuestionAnswer("🔥 வேலைத்தளங்களிலும் வீடுகளிலும் தீ அபாயங்கள் ஏன் ஏற்படுகின்றன?",
                      "1. மின்கம்பி பழுதுகள்\n2. அதிக மின்சாரம் செலுத்தும் ஸொக்கெட்டுகள்\n3. எரிபொருட்கள் அருகில் புகை பிடித்தல்\n4. தவறான எரிபொருள் சேமிப்பு\n5. தடையுள்ள தீ வெளியேறும் வழிகள்",
                    ),

                  _buildQuestionAnswer("🔥 தீ பாதுகாப்பில் ‘தங்கக் கோட்பு' என்றால் என்ன?",
                      "**'வெளியேறு, வெளியே இரு, உதவிக்கு அழை'**\n\nதீயை அணைக்க முயலாமல், பாதுகாப்பாக வெளியேறவும்.",
                      imagePath: 'assets/banner_3.png'),

                  _buildQuestionAnswer("🔥 தீ பயிற்சியின் முக்கியத்துவம் என்ன?",
                      "1. அனைவரும் வெளியேறும் நடைமுறையை அறிய\n2. தீ சம்பவத்தில் எப்படி நடந்துகொள்வது என்பதை பயிற்சி பெற\n3. தடைகளை அடையாளம் காண\n4. பாதுகாப்பு விதிமுறைகளை பின்பற்ற\n5. அவசர நிலைக்கு தயாராக இருக்க",
                      ),

                  _buildQuestionAnswer("🔥 தீ அலாரம் ஒலித்தால் என்ன செய்ய வேண்டும்?",
                      "1. உடனே அருகிலுள்ள வெளியேறும் வழியால் வெளியேற வேண்டும்\n2. அமைதியாக இருங்கள்\n3. லிப்ட் பயன்படுத்தாதீர்கள்\n4. வெளியே இருந்தபின் அவசர சேவைகளை அழைக்கவும்\n5. பிறரை உதவிக்காக அழைக்கவும்",
                      imagePath: 'assets/banner_4.jpg'),

                  _buildQuestionAnswer("🔥 தீ பாதுகாப்பில் தீ வார்டன்களின் பங்கு என்ன?",
                      "1. தீ அபாயங்களை கண்காணித்தல்\n2. தீ அவசர நிலை ஏற்பட்டால் வெளியேற உதவுதல்\n3. தேவையானால் தீ அணைப்பான் பயன்படுத்துதல்\n4. அவசர சேவையுடன் தொடர்பு கொள்ளுதல்\n5. பயிற்சி நடத்துதல்"
                  ),

                  _buildQuestionAnswer("🔥 தீ வெளியேறும் வழிகள் ஏன் சுத்தமாக வைத்திருக்க வேண்டும்?",
                      "1. தடைகள் இருப்பின் வெளியேறும் வழி முடியாது\n2. சுத்தமான வழிகள் பாதுகாப்பாக வெளியேற உதவும்\n3. குழப்பம் தீ பரவவைக்கும்\n4. மீட்புப் பணியாளர்களுக்கான அணுகல் முக்கியம்",
                      imagePath: 'assets/banner_5.jpg'),

                  _buildQuestionAnswer("🔥 தீ பாதுகாப்புக்காக தனிநபர்கள் என்ன செய்யலாம்?",
                      "1. தீ பாதுகாப்பு விதிகளை பின்பற்றுதல்\n2. தீ அணைப்பான் பயன்படுத்தக் கற்றுக்கொள்ளுதல்\n3. வெளியேறும் வழிகளை சுத்தமாக வைத்திருக்க\n4. தீ அபாயங்களை உடனே புகாரளிக்க\n5. குடும்பத்தினர், தோழர்களுக்கு விழிப்புணர்வு அளிக்க",
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: istopic_1_Completed,
              onChanged: (value) {
                _save_topic_1_CompletionStatus(value ?? false);
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


