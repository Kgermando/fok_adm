import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/banque_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/utils/departement.dart';
import 'package:fokad_admin/src/utils/pluto_grid.dart';
import 'package:fokad_admin/src/utils/type_operation.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class BanqueTransactions extends StatefulWidget {
  const BanqueTransactions({Key? key}) : super(key: key);

  @override
  State<BanqueTransactions> createState() => _BanqueTransactionsState();
}

class _BanqueTransactionsState extends State<BanqueTransactions> {
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
  String? departement;
  String? typeOperation;

  final List<String> typeCaisse = TypeOperation().typeCaisse;
  final List<String> departementList = DepartementList().departement;

  late int count;

  @override
  void initState() {
    setState(() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        floatingActionButton: speedialWidget(),
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
                      const CustomAppbar(title: 'Transactions Banque'),
                      Expanded(
                          child: Scrollbar(
                        controller: controller,
                        child: ListView(
                          controller: controller,
                          children: [
                            const SizedBox(
                              height: p20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Livre de banque',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                PrintWidget(onPressed: (() {})),
                              ],
                            ),
                            const SizedBox(
                              height: p10,
                            ),
                            const ColumnFilteringScreen()
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

  SpeedDial speedialWidget() {
    return SpeedDial(
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.upload),
          foregroundColor: Colors.black,
          backgroundColor: Colors.yellow.shade700,
          label: 'Retrait',
          onPressed: () {
            setState(() {
              transactionsDialogRetrait();
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.file_download),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Dépôt',
          onPressed: () => transactionsDialogDepot(),
        ),
      ],
    );
  }

  transactionsDialogDepot() {
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
                              const TitleWidget(title: 'Bordereau de versement'),
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
                          ligneBudgtaireWidget(),
                          Row(
                            children: [
                              Expanded(child: deperatmentWidget()),
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
                                            final coupureBillet = TextEditingController();
                                            final nombreBillet = TextEditingController();
                                            nombreBilletControllerList.add(nombreBillet);
                                            coupureBilletControllerList.add(coupureBillet);
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

  transactionsDialogRetrait() {
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
                              const TitleWidget(title: 'Bordereau de retrait'),
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
                          ligneBudgtaireWidget(),
                          Row(
                            children: [
                              Expanded(child: deperatmentWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: typeOperationWidget())
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SelectableText('Coupure de billet', style: Theme.of(context).textTheme.bodyText2),
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

  Widget deperatmentWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Département',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: departement,
        isExpanded: true,
        items: departementList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            departement = value!;
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
    final caisseModel = BanqueModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text,
        coupureBillet: [],
        ligneBudgtaire: ligneBudgtaire.toString(),
        departement: departement.toString(),
        typeOperation: typeOperation.toString(),
        date: DateTime.now(),
        numeroOperation: 'FOKAD-banque-01');
  }
}
