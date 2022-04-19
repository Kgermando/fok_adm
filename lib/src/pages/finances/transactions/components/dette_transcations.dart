import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/dette_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/components/dettes/table_dette.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class DetteTransactions extends StatefulWidget {
  const DetteTransactions({Key? key}) : super(key: key);

  @override
  State<DetteTransactions> createState() => _DetteTransactionsState();
}

class _DetteTransactionsState extends State<DetteTransactions> {
  final controller = ScrollController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final TextEditingController nomCompletController = TextEditingController();
  final TextEditingController pieceJustificativeController =
      TextEditingController();
  final TextEditingController libelleController = TextEditingController();
  final TextEditingController montantController = TextEditingController();

  int numberItem = 0;

  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }

  String? matricule;

  Future<void> getData() async {
    final userModel = await AuthApi().getUserId();
    final data = await DetteApi().getAllData();
    setState(() {
      matricule = userModel.matricule;
      numberItem = data.length;
    });
  }

  @override
  void dispose() {
    nomCompletController.dispose();
    pieceJustificativeController.dispose();
    libelleController.dispose();
    montantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red.shade700,
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                transactionsDialogDette();
              });
            }),
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
                    children: const [
                      CustomAppbar(title: 'Dettes'),
                      Expanded(child: TableDette())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  transactionsDialogDette() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(p8),
                ),
                backgroundColor: Colors.transparent,
                child: Form(
                  key: _formKey,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(p16),
                      child: SizedBox(
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.width,
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TitleWidget(title: 'Ajout dette'),
                                PrintWidget(onPressed: () {})
                              ],
                            ),
                            const SizedBox(
                              height: p20,
                            ),
                            Row(
                              children: [
                                Expanded(child: nomCompletWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: pieceJustificativeWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: libelleWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: montantWidget())
                              ],
                            ),
                            const SizedBox(
                              height: p20,
                            ),
                            BtnWidget(
                                title: 'Soumettre',
                                isLoading: isLoading,
                                press: () {
                                  final form = _formKey.currentState!;
                                  if (form.validate()) {
                                    submit();
                                    form.reset();
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  Widget nomCompletWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomCompletController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom complet',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget pieceJustificativeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: pieceJustificativeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'N° de la pièce justificative',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget libelleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: libelleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Libellé',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget montantWidget() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: TextFormField(
                controller: montantController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Montant',
                ),
                keyboardType: TextInputType.text,
                validator: (value) => value != null && value.isEmpty
                    ? 'Ce champs est obligatoire.'
                    : null,
                style: const TextStyle(),
              ),
            ),
            const SizedBox(width: p20),
            Expanded(
                flex: 1,
                child: Text(
                  "\$",
                  style: headline6!,
                ))
          ],
        ));
  }

  Future submit() async {
    final detteModel = DetteModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text,
        created: DateTime.now(),
        numeroOperation: 'FOKAD-Dette-${numberItem + 1}',
        signature: matricule.toString(),
        approbation: false,
        statutPaie: false);
    await DetteApi().insertData(detteModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
