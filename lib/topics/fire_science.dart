import 'package:flutter/material.dart';

class FireSciencePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fire Science")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildQuestionAnswer(
                "🔥 What is the scientific definition of fire?",
                "Fire is a rapid oxidation process known as combustion, producing heat, light, and various reaction products. It requires a combination of fuel, heat, and oxygen to sustain the chemical reaction."
            ),
            _buildQuestionAnswer(
                "🔥 What are the main components required for a fire?",
                "The three main components required for fire are:\n\n1. Fuel – A combustible material like wood, paper, or gas\n2. Heat – Enough energy to ignite the fuel\n3. Oxygen – At least 16% oxygen in the air to sustain combustion"
            ),
            _buildQuestionAnswer(
                "🔥 What is combustion?",
                "Combustion is a high-temperature exothermic chemical reaction between a fuel and an oxidant (usually oxygen), producing heat and light. It occurs in stages, including ignition, flame propagation, and heat release."
            ),
            _buildQuestionAnswer(
                "🔥 What is a flashpoint?",
                "The flashpoint is the lowest temperature at which a substance gives off enough vapor to ignite when exposed to an ignition source. Different materials have different flashpoints, determining their flammability risk."
            ),
            _buildQuestionAnswer(
                "🔥 What is spontaneous combustion?",
                "Spontaneous combustion occurs when a material self-heats due to an internal chemical reaction, reaching its ignition temperature without an external flame. Examples include oil-soaked rags and hay stacks."
            ),
            _buildQuestionAnswer(
                "🔥 Why is oxygen necessary for fire?",
                "Oxygen is essential because it acts as an oxidizer, enabling the chemical reaction that sustains combustion. Without enough oxygen, the fire cannot continue burning."
            ),
            _buildQuestionAnswer(
                "🔥 What happens when fire runs out of oxygen?",
                "When fire runs out of oxygen, the combustion reaction slows down and eventually stops, extinguishing the flames. This principle is used in fire suppression methods like smothering with blankets or CO₂ extinguishers."
            ),
            _buildQuestionAnswer(
                "🔥 How does fire spread rapidly?",
                "Fire spreads rapidly through three main methods:\n\n1. Conduction – Heat transfers through materials like walls or metal.\n2. Convection – Hot gases and smoke rise, igniting nearby surfaces.\n3. Radiation – Heat energy travels through air, warming nearby objects until they ignite."
            ),
            _buildQuestionAnswer(
                "🔥 Why does fire emit different colors?",
                "Fire emits different colors based on the temperature and the material being burned:\n\n• Red/Orange – Lower temperature flames\n• Yellow – Common for wood or paper fires\n• Blue – High-temperature flames with complete combustion\n• Green/Purple – Presence of certain chemicals or metals like copper or potassium"
            ),
            _buildQuestionAnswer(
                "🔥 What is the main danger of fire?",
                "The main dangers of fire include:\n\n1. Loss of life due to burns or smoke inhalation\n2. Destruction of property and critical infrastructure\n3. Release of toxic gases like carbon monoxide\n4. Risk of explosions from flammable substances\n5. Rapid spread leading to uncontrollable fires"
            ),
          ],
        ),
      ),
    );
  }

  // Helper function for questions and answers with justified text
  Widget _buildQuestionAnswer(String question, String answer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5),
            Text(
              answer,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
