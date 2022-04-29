import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comptabilite/amortissement_api.dart';
import 'package:fokad_admin/src/api/comptabilite/bilan_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/api/comptabilite/valorisation_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/amortissement_model.dart';
import 'package:fokad_admin/src/models/comptabilites/bilan_model.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:fokad_admin/src/models/comptabilites/valorisation_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comptabilites/compte_dd/components/amortissement_dd.dart';
import 'package:fokad_admin/src/pages/comptabilites/compte_dd/components/bilan_dd.dart';
import 'package:fokad_admin/src/pages/comptabilites/compte_dd/components/journal_dd.dart';
import 'package:fokad_admin/src/pages/comptabilites/compte_dd/components/valorisation_admin.dart';

class CompteDD extends StatefulWidget {
  const CompteDD({ Key? key }) : super(key: key);

  @override
  State<CompteDD> createState() => _CompteDDState();
}

class _CompteDDState extends State<CompteDD> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenBudget = false;

  int amortissementCount = 0;
  int bilanCount = 0;
  int journalCount = 0;
  int valorisationCount = 0;

  @override
  initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    List<AmortissementModel?> dataListAmortissemnt =
        await AmortissementApi().getAllData();
    List<BilanModel?> dataListBilan = await BilanApi().getAllData();
    List<JournalModel?> dataListJournal = await JournalApi().getAllData();
    List<ValorisationModel?> dataListValorisation =
        await ValorisationApi().getAllData();
    setState(() {
      amortissementCount = dataListAmortissemnt
          .where((element) => element!.approbationDG == "-")
          .length;
      bilanCount = dataListBilan
          .where((element) => element!.approbationDG == "-")
          .length;
      journalCount = dataListJournal
          .where((element) => element!.approbationDG == "-")
          .length;
      valorisationCount = dataListValorisation
          .where((element) => element!.approbationDG == "-")
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppbar(
                          title: 'Comptabilités Admin',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                                color: const Color.fromARGB(255, 117, 190, 121),
                                child: ExpansionTile(
                                  leading: const Icon(Icons.folder),
                                  title: Text('Dossier amortissement',
                                      style: headline6),
                                  subtitle: Text(
                                      "Vous avez $amortissementCount dossiers necessitent votre approbation",
                                      style: bodyMedium),
                                  initiallyExpanded: false,
                                  onExpansionChanged: (val) {
                                    setState(() {
                                      isOpenBudget = !val;
                                    });
                                  },
                                  trailing: const Icon(Icons.arrow_drop_down),
                                  children: const [AmortissementDD()],
                                )),
                            Card(
                                color: const Color.fromARGB(255, 117, 190, 121),
                                child: ExpansionTile(
                                  leading: const Icon(Icons.folder),
                                  title:
                                      Text('Dossier bilan', style: headline6),
                                  subtitle: Text(
                                      "Vous avez $bilanCount dossiers necessitent votre approbation",
                                      style: bodyMedium),
                                  initiallyExpanded: false,
                                  onExpansionChanged: (val) {
                                    setState(() {
                                      isOpenBudget = !val;
                                    });
                                  },
                                  trailing: const Icon(Icons.arrow_drop_down),
                                  children: const [BilanDD()],
                                )),
                            Card(
                                color: const Color.fromARGB(255, 117, 190, 121),
                                child: ExpansionTile(
                                  leading: const Icon(Icons.folder),
                                  title:
                                      Text('Dossier journal', style: headline6),
                                  subtitle: Text(
                                      "Vous avez $journalCount dossiers necessitent votre approbation",
                                      style: bodyMedium),
                                  initiallyExpanded: false,
                                  onExpansionChanged: (val) {
                                    setState(() {
                                      isOpenBudget = !val;
                                    });
                                  },
                                  trailing: const Icon(Icons.arrow_drop_down),
                                  children: const [JournalDD()],
                                )),
                            Card(
                                color: const Color.fromARGB(255, 117, 190, 121),
                                child: ExpansionTile(
                                  leading: const Icon(Icons.folder),
                                  title: Text('Dossier valorisation',
                                      style: headline6),
                                  subtitle: Text(
                                      "Vous avez $valorisationCount dossiers necessitent votre approbation",
                                      style: bodyMedium),
                                  initiallyExpanded: false,
                                  onExpansionChanged: (val) {
                                    setState(() {
                                      isOpenBudget = !val;
                                    });
                                  },
                                  trailing: const Icon(Icons.arrow_drop_down),
                                  children: const [ValorisationDD()],
                                )),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}