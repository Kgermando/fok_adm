import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/fin_exterieur_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/fin_exterieur_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/components/fin_exterieur/table_fin_exterieur.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/type_operation.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class FinExterneTransactions extends StatefulWidget {
  const FinExterneTransactions({Key? key}) : super(key: key);

  @override
  State<FinExterneTransactions> createState() => _FinExterneTransactionsState();
}

class _FinExterneTransactionsState extends State<FinExterneTransactions> {
  final controller = ScrollController();
  final ScrollController _controllerBillet = ScrollController();

  bool isLoading = false;

  final TextEditingController nomCompletController = TextEditingController();
  final TextEditingController pieceJustificativeController =
      TextEditingController();
  final TextEditingController libelleController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController deperatmentController = TextEditingController();

  List<TextEditingController> coupureBilletControllerList = [];
  List<TextEditingController> nombreBilletControllerList = [];
  String? ligneBudgtaire;
  String? typeOperation;

  final List<String> typeCaisse = TypeOperation().typeCaisse;

  late int count;
  

  @override
  void initState() {
    setState(() {
      getData();
      count = 0;
    });

    super.initState();
  }

  @override
  void dispose() {
    nomCompletController.dispose();
    pieceJustificativeController.dispose();
    libelleController.dispose();
    montantController.dispose();
    deperatmentController.dispose();
    for (final controller in coupureBilletControllerList) {
      controller.dispose();
    }
    for (final controller in nombreBilletControllerList) {
      controller.dispose();
    }
    super.dispose();
  }

  String? matricule;
  int numberItem = 0;

  Future<void> getData() async {
    final userModel = await AuthApi().getUserId();
    final data = await FinExterieurApi().getAllData();

    setState(() {
      matricule = userModel.matricule;
      numberItem = data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal.shade700,
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                transactionsDialogDonation();
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
                      CustomAppbar(title: 'Fin. Externe'),
                      Expanded(
                          child: TableFinExterieur()
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  transactionsDialogDonation() {
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
                              const TitleWidget(title: 'Nouvelle donation'),
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
                          Row(
                            children: [
                              Expanded(child: ligneBudgtaireWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: typeOperationWidget())
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SelectableText('Coupure de billet',
                                  style: Theme.of(context).textTheme.bodyText2),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          final coupureBillet =
                                              TextEditingController();
                                          final nombreBillet =
                                              TextEditingController();
                                          nombreBilletControllerList
                                              .add(nombreBillet);
                                          coupureBilletControllerList
                                              .add(coupureBillet);
                                          count++;
                                        });
                                      },
                                      icon: const Icon(Icons.add)),
                                  if (count > 0)
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            final coupureBillet =
                                                TextEditingController();
                                            final nombreBillet =
                                                TextEditingController();
                                            nombreBilletControllerList
                                                .remove(nombreBillet);
                                            coupureBilletControllerList
                                                .remove(coupureBillet);
                                            count--;
                                          });
                                        },
                                        icon: const Icon(Icons.close)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: coupureBilletWidget()),
                          const SizedBox(
                            height: p20,
                          ),
                          BtnWidget(
                              title: 'Soumettre',
                              isLoading: isLoading,
                              press: () {})
                        ],
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
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
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
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
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
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
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
                validator: (val) {
                  return 'Ce champs est obligatoire';
                },
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

  Widget coupureBilletWidget() {
    return Scrollbar(
      controller: _controllerBillet,
      isAlwaysShown: true,
      child: ListView.builder(
          controller: _controllerBillet,
          itemCount: count,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(bottom: p20),
                        child: TextFormField(
                          controller: nombreBilletControllerList[index],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: '${index + 1}. Nombre',
                          ),
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            return 'Ce champs est obligatoire';
                          },
                          style: const TextStyle(),
                        ))),
                const SizedBox(width: p10),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(bottom: p20),
                        child: TextFormField(
                          controller: coupureBilletControllerList[index],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: '${index + 1}. Coupure billet',
                          ),
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            return 'Ce champs est obligatoire';
                          },
                          style: const TextStyle(),
                        )))
              ],
            );
          }),
    );
  }

  Widget ligneBudgtaireWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Ligne Budgetaire',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: ligneBudgtaire,
        isExpanded: true,
        items: typeCaisse.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            ligneBudgtaire = value!;
          });
        },
      ),
    );
  }

  Widget typeOperationWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type d\'Operation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: typeOperation,
        isExpanded: true,
        items: typeCaisse.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            typeOperation = value!;
          });
        },
      ),
    );
  }

  Future submit() async {
    final financeExterieurModel = FinanceExterieurModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text,
        coupureBillet: [],
        ligneBudgtaire: ligneBudgtaire.toString(),
        typeOperation: typeOperation.toString(),
        created: DateTime.now(),
        numeroOperation: 'FOKAD-Fin-Ext-${numberItem + 1}',
        signature: matricule.toString());

    await FinExterieurApi().insertData(financeExterieurModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
