import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/utils/country.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/fonction_occupe.dart';
import 'package:fokad_admin/src/utils/service_affectation.dart';

class UpdateAgent extends StatefulWidget {
  const UpdateAgent({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<UpdateAgent> createState() => _UpdateAgentState();
}

class _UpdateAgentState extends State<UpdateAgent> {
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  final List<String> departementList = Dropdown().departement;
  final List<String> typeContratList = Dropdown().typeContrat;
  final List<String> sexeList = Dropdown().sexe;
  final List<String> roleList = Dropdown().role;
  final List<String> world = Country().world;
  final List<String> fonctionOccupeAdminList = FonctionOccupee().adminDropdown;
  final List<String> fonctionOccupeList = FonctionOccupee().fonctionOccupeDropdown;

  final List<String> serviceAffectation =
      ServiceAffectation().serviceAffectationDropdown;
  final List<String> serviceAffectationAdmin =
      ServiceAffectation().adminDropdown;
  final List<String> serviceAffectationRH = ServiceAffectation().rhDropdown;
  final List<String> serviceAffectationFin = ServiceAffectation().finDropdown;
  final List<String> serviceAffectationEXp = ServiceAffectation().expDropdown;
  final List<String> serviceAffectationComm = ServiceAffectation().commDropdown;
  final List<String> serviceAffectationLog = ServiceAffectation().logDropdown;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController postNomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController lieuNaissanceController = TextEditingController();
 
  final TextEditingController dateDebutContratController =
      TextEditingController();
  final TextEditingController dateFinContratController =
      TextEditingController();
  final TextEditingController competanceController = TextEditingController();
  // HtmlEditorController competanceController = HtmlEditorController();

  final TextEditingController experienceController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  String matricule = "";
  String? sexe;
  String? role;
  String? nationalite;
  String? departement;
  String? typeContrat;
  String? servicesAffectation;
  String? fonctionOccupe;

  List<String> servAffectList = [];
  List<String> fonctionList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controllerScroll.dispose();

    nomController.dispose();
    postNomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    adresseController.dispose();
    matriculeController.dispose();
    dateNaissanceController.dispose();
    lieuNaissanceController.dispose();
    dateDebutContratController.dispose();
    dateFinContratController.dispose();
    competanceController.dispose();
    experienceController.dispose();
    rateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      body: SafeArea(child: Row()),
    );
  }
}
