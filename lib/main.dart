import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/welcome.dart';

// English Fire Safety Topics
import 'package:e_she_book/topics/fire_safety_english/fire_safety.dart' as fireSafety;
import 'package:e_she_book/topics/fire_safety_english/common_causes.dart' as commonCauses;
import 'package:e_she_book/topics/fire_safety_english/fire_extinguishers.dart' as fireExtinguishers;
import 'package:e_she_book/topics/fire_safety_english/fire_prevention.dart' as firePrevention;
import 'package:e_she_book/topics/fire_safety_english/fire_emergency.dart' as fireEmergency;
import 'package:e_she_book/topics/fire_safety_english/handling_extinguishers.dart' as handlingExtinguishers;
import 'package:e_she_book/topics/fire_safety_english/industrial_safety.dart' as industrialSafety;
import 'package:e_she_book/topics/fire_safety_english/first_aid.dart' as firstAid;

// English First Aid Topics (using alias to prevent name collision)
import 'package:e_she_book/topics/first_aid_english/firstaid_intro.dart' as introFA;
import 'package:e_she_book/topics/first_aid_english/bleeding_control.dart' as bleedFA;
import 'package:e_she_book/topics/first_aid_english/burns_and_scalds.dart' as burnScaldFA;
import 'package:e_she_book/topics/first_aid_english/fractures.dart' as fractureFA;
import 'package:e_she_book/topics/first_aid_english/electric_shock.dart' as electricFA;
import 'package:e_she_book/topics/first_aid_english/crp.dart' as cprAdultFA;
import 'package:e_she_book/topics/first_aid_english/crp_children.dart' as cprChildFA;
import 'package:e_she_book/topics/first_aid_english/choking.dart' as chokingFA;
import 'package:e_she_book/topics/first_aid_english/burn_injuries.dart' as burnChildFA;
import 'package:e_she_book/topics/first_aid_english/poisoning.dart' as poisonFA;

// Tamil Fire Safety Topics
import 'package:e_she_book/topics/fire_safety_tamil/fire_safety.dart' as fireSafetyTa;
import 'package:e_she_book/topics/fire_safety_tamil/common_causes.dart' as commonCausesTa;
import 'package:e_she_book/topics/fire_safety_tamil/fire_extinguishers.dart' as fireExtinguishersTa;
import 'package:e_she_book/topics/fire_safety_tamil/fire_prevention.dart' as firePreventionTa;
import 'package:e_she_book/topics/fire_safety_tamil/fire_emergency.dart' as fireEmergencyTa;
import 'package:e_she_book/topics/fire_safety_tamil/handling_extinguishers.dart' as handlingExtinguishersTa;
import 'package:e_she_book/topics/fire_safety_tamil/industrial_safety.dart' as industrialSafetyTa;
import 'package:e_she_book/topics/fire_safety_tamil/first_aid.dart' as firstAidTa;

// Tamil First Aid Topics
import 'package:e_she_book/topics/first_aid_tamil/firstaid_intro.dart' as introFATa;
import 'package:e_she_book/topics/first_aid_tamil/bleeding_control.dart' as bleedFATa;
import 'package:e_she_book/topics/first_aid_tamil/burns_and_scalds.dart' as burnScaldFATa;
import 'package:e_she_book/topics/first_aid_tamil/fractures.dart' as fractureFATa;
import 'package:e_she_book/topics/first_aid_tamil/electric_shock.dart' as electricFATa;
import 'package:e_she_book/topics/first_aid_tamil/crp.dart' as cprAdultFATa;

// English PPE Topics
import 'package:e_she_book/topics/ppe_english/ppe_intro.dart' as ppeIntro;
import 'package:e_she_book/topics/ppe_english/eye_protection.dart' as eyeProtection;
import 'package:e_she_book/topics/ppe_english/head_protection.dart' as headProtection;
import 'package:e_she_book/topics/ppe_english/foot_protection.dart' as footProtection;
import 'package:e_she_book/topics/ppe_english/respiratory_protection.dart' as respiratoryProtection;

// Tamil PPE Topics
import 'package:e_she_book/topics/ppe_tamil/ppe_into.dart' as ppeIntroTa;
import 'package:e_she_book/topics/ppe_tamil/eye_protection.dart' as eyeProtectionTa;
import 'package:e_she_book/topics/ppe_tamil/foot_protection.dart' as footProtectionTa;
import 'package:e_she_book/topics/ppe_tamil/head_protection.dart' as headProtectionTa;
import 'package:e_she_book/topics/ppe_tamil/respiratory_protection.dart' as respiratoryProtectionTa;

// English Electrical Safety Topics
import 'package:e_she_book/topics/electrical_safety_english/electrical_intro.dart' as electricalIntro;
import 'package:e_she_book/topics/electrical_safety_english/common_hazards.dart' as commonHazards;
import 'package:e_she_book/topics/electrical_safety_english/shock_and_firstaid.dart' as shockFirstAid;
import 'package:e_she_book/topics/electrical_safety_english/safe_use_equipment.dart' as safeEquipment;
import 'package:e_she_book/topics/electrical_safety_english/emergency_procedures.dart' as emergencyProcedures;

// Tamil Electrical Safety Topics
import 'package:e_she_book/topics/electrical_safety_tamil/electrical_intro.dart' as electricalIntroTa;
import 'package:e_she_book/topics/electrical_safety_tamil/common_hazards.dart' as commonHazardsTa;
import 'package:e_she_book/topics/electrical_safety_tamil/shock_and_firstaid.dart' as shockFirstAidTa;
import 'package:e_she_book/topics/electrical_safety_tamil/safe_use_equipment.dart' as safeEquipmentTa;
import 'package:e_she_book/topics/electrical_safety_tamil/emergency_procedures.dart' as emergencyProceduresTa;

// English Road Safety Topics
import 'package:e_she_book/topics/road_safety_english/road_intro.dart' as roadIntro;
import 'package:e_she_book/topics/road_safety_english/traffic_signs.dart' as trafficSigns;
import 'package:e_she_book/topics/road_safety_english/pedestrian_safety.dart' as pedestrianSafety;
import 'package:e_she_book/topics/road_safety_english/vehicle_safety.dart' as vehicleSafety;
import 'package:e_she_book/topics/road_safety_english/emergency_actions.dart' as emergencyActions;

// Tamil Road Safety Topics
import 'package:e_she_book/topics/road_safety_tamil/road_intro.dart' as roadIntroTa;
import 'package:e_she_book/topics/road_safety_tamil/traffic_signs.dart' as trafficSignsTa;
import 'package:e_she_book/topics/road_safety_tamil/pedestrian_safety.dart' as pedestrianSafetyTa;
import 'package:e_she_book/topics/road_safety_tamil/vehicle_safety.dart' as vehicleSafetyTa;
import 'package:e_she_book/topics/road_safety_tamil/emergency_actions.dart' as emergencyActionsTa;

// English Kids Safety Topics
import 'package:e_she_book/topics/kids_safety_english/why_kids_safety.dart' as kidsIntro;
import 'package:e_she_book/topics/kids_safety_english/stranger_safety.dart' as strangerSafety;
import 'package:e_she_book/topics/kids_safety_english/home_safety.dart' as homeSafety;
import 'package:e_she_book/topics/kids_safety_english/outdoor_safety.dart' as outdoorSafety;
import 'package:e_she_book/topics/kids_safety_english/emergency_preparedness.dart' as emergencyPreparedness;

// Tamil Kids Safety Topics
import 'package:e_she_book/topics/kids_safety_tamil/why_kids_safety.dart' as kidsIntroTa;
import 'package:e_she_book/topics/kids_safety_tamil/stranger_safety.dart' as strangerSafetyTa;
import 'package:e_she_book/topics/kids_safety_tamil/home_safety.dart' as homeSafetyTa;
import 'package:e_she_book/topics/kids_safety_tamil/outdoor_safety.dart' as outdoorSafetyTa;
import 'package:e_she_book/topics/kids_safety_tamil/emergency_preparedness.dart' as emergencyPreparednessTa;

// English Construction Safety Topics
import 'package:e_she_book/topics/construction_safety_english/construction_intro.dart' as constructionIntro;
import 'package:e_she_book/topics/construction_safety_english/personal_protective.dart' as personalPPE;
import 'package:e_she_book/topics/construction_safety_english/tools_handling.dart' as toolsHandling;
import 'package:e_she_book/topics/construction_safety_english/electrical_safety.dart' as electricalSafety;
import 'package:e_she_book/topics/construction_safety_english/working_at_height.dart' as workingHeight;


// 🌱 Environment & Energy Saving (English)
import 'package:e_she_book/topics/environment_safety_english/introduction_to_environment.dart' as envIntro;
import 'package:e_she_book/topics/environment_safety_english/save_the_environment.dart' as saveEnv;
import 'package:e_she_book/topics/environment_safety_english/environmental_pollution_types.dart' as pollutionTypes;
import 'package:e_she_book/topics/environment_safety_english/daily_and_eating_habits.dart' as habits;
import 'package:e_she_book/topics/environment_safety_english/home_and_yard_practices.dart' as homeYard;
import 'package:e_she_book/topics/environment_safety_english/energy_saving_and_usage.dart' as energy;

// 🌱 Environment & Energy Saving (Tamil)
import 'package:e_she_book/topics/environment_safety_tamil/introduction_to_environment.dart' as envIntroTa;
import 'package:e_she_book/topics/environment_safety_tamil/save_the_environment.dart' as saveEnvTa;
import 'package:e_she_book/topics/environment_safety_tamil/environmental_pollution_types.dart' as pollutionTypesTa;
import 'package:e_she_book/topics/environment_safety_tamil/daily_and_eating_habits.dart' as habitsTa;
import 'package:e_she_book/topics/environment_safety_tamil/home_and_yard_practices.dart' as homeYardTa;
import 'package:e_she_book/topics/environment_safety_tamil/energy_saving_and_usage.dart' as energyTa;

import 'package:e_she_book/topics/forklift_safety_english/forklift_intro.dart' as forkliftIntro;
import 'package:e_she_book/topics/forklift_safety_english/center_of_gravity.dart' as centerOfGravity;
import 'package:e_she_book/topics/forklift_safety_english/common_accidents.dart' as commonAccidents;
import 'package:e_she_book/topics/forklift_safety_english/general_safety_precautions.dart' as safetyPrecautions;
import 'package:e_she_book/topics/forklift_safety_english/signals_and_checks.dart' as signalsAndChecks;

import 'package:e_she_book/topics/forklift_safety_tamil/forklift_intro.dart' as forkliftIntroTa;
import 'package:e_she_book/topics/forklift_safety_tamil/center_of_gravity.dart' as centerOfGravityTa;
import 'package:e_she_book/topics/forklift_safety_tamil/common_accidents.dart' as commonAccidentsTa;
import 'package:e_she_book/topics/forklift_safety_tamil/general_safety_precautions.dart' as safetyPrecautionsTa;
import 'package:e_she_book/topics/forklift_safety_tamil/signals_and_checks.dart' as signalsAndChecksTa;

 // BBS Safety - English
import 'package:e_she_book/topics/bbs_safety_english/bbs_intro.dart' as bbsIntro;
import 'package:e_she_book/topics/bbs_safety_english/core_principles.dart' as bbsPrinciples;
import 'package:e_she_book/topics/bbs_safety_english/observation_process.dart' as bbsObservation;
import 'package:e_she_book/topics/bbs_safety_english/employee_engagement.dart' as bbsEngagement;
import 'package:e_she_book/topics/bbs_safety_english/incident_prevention.dart' as bbsPrevention;

// BBS Safety - Tamil
import 'package:e_she_book/topics/bbs_safety_tamil/bbs_intro.dart' as bbsIntroTa;
import 'package:e_she_book/topics/bbs_safety_tamil/core_principles.dart' as bbsPrinciplesTa;
import 'package:e_she_book/topics/bbs_safety_tamil/observation_process.dart' as bbsObservationTa;
import 'package:e_she_book/topics/bbs_safety_tamil/employee_engagement.dart' as bbsEngagementTa;
import 'package:e_she_book/topics/bbs_safety_tamil/incident_prevention.dart' as bbsPreventionTa;





void main() {
  runApp(FireSafetyApp());
}

class FireSafetyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fire Safety Class',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF2F2F2),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFF0000),
          elevation: 5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: FireSafetyBackground(child: Welcome()),
      routes: {
        // 🔥 English Fire Safety
        '/fire_safety_en': (context) => fireSafety.FireSafetyPage(),
        '/common_causes_en': (context) => commonCauses.CommonCausesPage(),
        '/fire_extinguishers_en': (context) => fireExtinguishers.FireExtinguishersPage(),
        '/fire_prevention_en': (context) => firePrevention.FirePreventionPage(),
        '/fire_emergency_en': (context) => fireEmergency.FireEmergencyPage(),
        '/handling_extinguishers_en': (context) => handlingExtinguishers.HandlingExtinguishersPage(),
        '/industrial_safety_en': (context) => industrialSafety.IndustrialSafetyPage(),
        '/first_aid_en': (context) => firstAid.FirstAidPage(),

        // 🩹 English First Aid
        '/introduction_to_firstaid_en': (context) => introFA.IntroductionToFirstAidPage(),
        '/bleeding_control_en': (context) => bleedFA.BleedingControlPage(),
        '/burns_and_scalds_en': (context) => burnScaldFA.BurnsAndScaldsPage(),
        '/fractures_and_sprains_en': (context) => fractureFA.FracturesAndSprainsPage(),
        '/electric_shock_en': (context) => electricFA.ElectricShockPage(),
        '/cpr_for_adults_en': (context) => cprAdultFA.CPRForAdultsPage(),
        '/cpr_for_children_en': (context) => cprChildFA.CPRForChildrenPage(),
        '/choking_firstaid_en': (context) => chokingFA.ChokingFirstAidPage(),
        '/burn_injuries_children_en': (context) => burnChildFA.BurnInjuriesChildrenPage(),
        '/poisoning_firstaid_en': (context) => poisonFA.PoisoningFirstAidPage(),



        // 🔥 Tamil Fire Safety
        '/fire_safety_ta': (context) => fireSafetyTa.FireSafetyPage(),
        '/common_causes_ta': (context) => commonCausesTa.CommonCausesPage(),
        '/fire_extinguishers_ta': (context) => fireExtinguishersTa.FireExtinguishersPage(),
        '/fire_prevention_ta': (context) => firePreventionTa.FirePreventionPage(),
        '/fire_emergency_ta': (context) => fireEmergencyTa.FireEmergencyPage(),
        '/handling_extinguishers_ta': (context) => handlingExtinguishersTa.HandlingExtinguishersPage(),
        '/industrial_safety_ta': (context) => industrialSafetyTa.IndustrialSafetyPage(),
        '/first_aid_ta': (context) => firstAidTa.FirstAidPage(),

        // 🩹 Tamil First Aid
        '/introduction_to_firstaid_ta': (context) => introFATa.IntroductionToFirstAidPage(),
        '/bleeding_control_ta': (context) => bleedFATa.BleedingControlPage(),
        '/burns_and_scalds_ta': (context) => burnScaldFATa.BurnsAndScaldsPage(),
        '/fractures_and_sprains_ta': (context) => fractureFATa.FracturesAndSprainsPage(),
        '/electric_shock_ta': (context) => electricFATa.ElectricShockPage(),
        '/cpr_for_adults_ta': (context) => cprAdultFATa.CPRForAdultsPage(),

        // 🛡️ English PPE Topics
        '/ppe_into_en': (context) => ppeIntroTa.IntroductionToPPEPage(),
        '/eye_protection_en': (context) => eyeProtection.EyeProtectionPage(),
        '/foot_protection_en': (context) => footProtection.FootProtectionPage(),
        '/head_protection_en': (context) => headProtection.HeadProtectionPage(),
        '/respiratory_protection_en': (context) => respiratoryProtection.RespiratoryProtectionPage(),

// 🛡️ Tamil PPE Topics
        '/ppe_intro_ta': (context) => ppeIntroTa.IntroductionToPPEPage(),
        '/eye_protection_ta': (context) => eyeProtectionTa.EyeProtectionPage(),
        '/foot_protection_ta': (context) => footProtectionTa.FootProtectionPageTamil(),
        '/head_protection_ta': (context) => headProtectionTa.HeadProtectionPage(),
        '/respiratory_protection_ta': (context) => respiratoryProtectionTa.RespiratoryProtectionPage(),

// ⚡ English Electrical Safety
        '/electrical_intro_en': (context) => electricalIntro.ElectricalIntroPage(),
        '/common_hazards_en': (context) => commonHazards.CommonHazardsPage(),
        '/shock_and_firstaid_en': (context) => shockFirstAid.ShockAndFirstAidPage(),
        '/safe_use_equipment_en': (context) => safeEquipment.SafeUseEquipmentPage(),
        '/emergency_procedures_en': (context) => emergencyProcedures.EmergencyProceduresPage(),

        // ⚡ Tamil Electrical Safety
        '/electrical_intro_ta': (context) => electricalIntroTa.ElectricalIntroPageTamil(),
        '/common_hazards_ta': (context) => commonHazardsTa.CommonHazardsPageTamil(),
        '/shock_and_firstaid_ta': (context) => shockFirstAidTa.ShockAndFirstAidPageTamil(),
        '/safe_use_equipment_ta': (context) => safeEquipmentTa.SafeUseEquipmentPageTamil(),
        '/emergency_procedures_ta': (context) => emergencyProceduresTa.EmergencyProceduresPageTamil(),
// 🚗 English Road Safety
        '/road_intro_en': (context) => roadIntro.RoadIntroPage(),
        '/traffic_signs_en': (context) => trafficSigns.TrafficSignsPage(),
        '/pedestrian_safety_en': (context) => pedestrianSafety.PedestrianSafetyPage(),
        '/vehicle_safety_en': (context) => vehicleSafety.VehicleSafetyPage(),
        '/emergency_actions_en': (context) => emergencyActions.EmergencyActionsPage(),
// 🚗 Tamil Road Safety
        '/road_intro_ta': (context) => roadIntroTa.RoadIntroPageTamil(),
        '/traffic_signs_ta': (context) => trafficSignsTa.TrafficSignsPageTamil(),
        '/pedestrian_safety_ta': (context) => pedestrianSafetyTa.PedestrianSafetyPage(),
        '/vehicle_safety_ta': (context) => vehicleSafetyTa.VehicleSafetyPageTamil(),
        '/emergency_actions_ta': (context) => emergencyActionsTa.EmergencyActionsPageTamil(),
// 👶 English Kids Safety
        '/why_kids_safety_en': (context) => kidsIntro.WhyKidsSafetyPage(),
        '/stranger_danger_en': (context) => strangerSafety.StrangerSafetyPage(),
        '/home_safety_en': (context) => homeSafety.HomeSafetyPage(),
        '/outdoor_safety_en': (context) => outdoorSafety.OutdoorSafetyPage(),
        '/emergency_preparedness_en': (context) => emergencyPreparedness.EmergencyPreparednessPage(),
// 👶 Tamil Kids Safety
        '/why_kids_safety_ta': (context) => kidsIntroTa.WhyKidsSafetyTamilPage(),
        '/stranger_danger_ta': (context) => strangerSafetyTa.StrangerSafetyTamilPage(),
        '/home_safety_ta': (context) => homeSafetyTa.HomeSafetyTamilPage(),
        '/outdoor_safety_ta': (context) => outdoorSafetyTa.OutdoorSafetyTamilPage(),
        '/emergency_preparedness_ta': (context) => emergencyPreparednessTa.EmergencyPreparednessTamilPage(),

// 🏗️ English Construction Safety Topics
        '/construction_intro_en': (context) => constructionIntro.ConstructionIntroPage(),
        '/personal_protective_en': (context) => personalPPE.PersonalProtectivePage(),
        '/tools_handling_en': (context) => toolsHandling.ToolsHandlingPage(),
        '/working_at_height_en': (context) => workingHeight.WorkingAtHeightPage(),
        '/electrical_safety_en': (context) => electricalSafety.ElectricalSafetyPage(),

// 🌱 Environment & Energy Saving (English)
        '/introduction_to_environment_en': (context) => envIntro.IntroductionToEnvironmentPage(),
        '/save_the_environment_en': (context) => saveEnv.SaveTheEnvironmentPage(),
        '/environmental_pollution_types_en': (context) => pollutionTypes.EnvironmentalPollutionTypesPage(),
        '/daily_and_eating_habits_en': (context) => habits.DailyAndEatingHabitsPage(),
        '/home_and_yard_practices_en': (context) => homeYard.HomeAndYardPracticesPage(),

        // 🌱 Environment & Energy Saving (Tamil)
        '/introduction_to_environment_ta': (context) => envIntroTa.IntroductionToEnvironmentTamilPage(),
        '/save_the_environment_ta': (context) => saveEnvTa.SaveTheEnvironmentTamilPage(),
        '/environmental_pollution_types_ta': (context) => pollutionTypesTa.EnvironmentalPollutionTypesTamilPage(),
        '/daily_and_eating_habits_ta': (context) => habitsTa.DailyAndEatingHabitsTamilPage(),
        '/home_and_yard_practices_ta': (context) => homeYardTa.HomeAndYardPracticesTamilPage(),

        // 🚧 Forklift Safety (English)
        '/forklift_intro_en': (context) => forkliftIntro.ForkliftIntroPage(),
        '/center_of_gravity_en': (context) => centerOfGravity.CenterOfGravityPage(),
        '/common_accidents_en': (context) => commonAccidents.CommonAccidentsPage(),
        '/safety_precautions_en': (context) => safetyPrecautions.SafetyPrecautionsPage(),
        '/signals_and_checks_en': (context) => signalsAndChecks.SignalsAndChecksPage(),

        // 🚧 Forklift Safety (Tamil)
        '/forklift_intro_ta': (context) => forkliftIntroTa.ForkliftIntroTamilPage(),
        '/center_of_gravity_ta': (context) => centerOfGravityTa.CenterOfGravityTamilPage(),
        '/common_accidents_ta': (context) => commonAccidentsTa.CommonAccidentsTamilPage(),
        '/safety_precautions_ta': (context) => safetyPrecautionsTa.SafetyPrecautionsTamilPage(),
        '/signals_and_checks_ta': (context) => signalsAndChecksTa.SignalsAndChecksTamilPage(),

// 📘 BBS Safety (English)
        '/bbs_intro_en': (context) => bbsIntro.BBSIntroPage(),
        '/core_principles_en': (context) => bbsPrinciples.CorePrinciplesPage(),
        '/observation_process_en': (context) => bbsObservation.ObservationProcessPage(),
        '/employee_engagement_en': (context) => bbsEngagement.EmployeeEngagementPage(),
        '/incident_prevention_en': (context) => bbsPrevention.IncidentPreventionPage(),

// 📘 BBS Safety (Tamil)
        '/bbs_intro_ta': (context) => bbsIntroTa.BBSIntroPageTamil(),
        '/core_principles_ta': (context) => bbsPrinciplesTa.CorePrinciplesPageTamil(),
        '/observation_process_ta': (context) => bbsObservationTa.ObservationProcessPageTamil(),
        '/employee_engagement_ta': (context) => bbsEngagementTa.EmployeeEngagementPageTamil(),
        '/incident_prevention_ta': (context) => bbsPreventionTa.IncidentPreventionPageTamil(),

      },
    );
  }
}

class FireSafetyBackground extends StatelessWidget {
  final Widget child;
  FireSafetyBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Color(0xFFF2F2F2)),
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/logo.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
        child,
      ],
    );
  }
}
