import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/finances/creance_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/creances_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:routemaster/routemaster.dart';

class DetailCreanceAdmin extends StatefulWidget {
  const DetailCreanceAdmin({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<DetailCreanceAdmin> createState() => _DetailCreanceAdminState();
}

class _DetailCreanceAdminState extends State<DetailCreanceAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;
  List<UserModel> userList = [];

  bool statutAgent = false;

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;
  String? nomComplet;
  String? pieceJustificative;
  String? libelle;
  String? montant;
  String? departement;
  String? numeroOperation;
  DateTime? created;
  String? signature;
  String approbation = '';
  bool statutPaie = false;

  @override
  initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    final dataUser = await UserApi().getAllData();
    CreanceModel data = await CreanceApi().getOneData(widget.id!);
    setState(() {
      userList = dataUser;
      id = data.id;
      nomComplet = data.nomComplet;
      pieceJustificative = data.pieceJustificative;
      libelle = data.libelle;
      montant = data.montant;
      numeroOperation = data.numeroOperation;
      created = data.created;
      signature = data.signature;
      approbation = data.approbationDG;
      statutPaie = data.statutPaie;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    child: FutureBuilder<CreanceModel>(
                        future: CreanceApi().getOneData(widget.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<CreanceModel> snapshot) {
                          if (snapshot.hasData) {
                            CreanceModel? creanceModel = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: p20,
                                      child: IconButton(
                                          onPressed: () =>
                                              Routemaster.of(context).pop(),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title:
                                              creanceModel!.nomComplet,
                                        controllerMenu: () => _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: Scrollbar(
                                        controller: _controllerScroll,
                                        isAlwaysShown: true,
                                        child: pageDetail(creanceModel)))
                              ],
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(CreanceModel creanceModel) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: ListView(
            controller: _controllerScroll,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: creanceModel.libelle),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              tooltip: 'Modifier',
                              onPressed: () {},
                              icon: const Icon(Icons.edit)),
                          PrintWidget(
                              tooltip: 'Imprimer le document', onPressed: () {})
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yy").format(creanceModel.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(creanceModel),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(CreanceModel creanceModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Nom Complet :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(creanceModel.nomComplet,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Pièce justificative :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(creanceModel.pieceJustificative,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Libellé :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(creanceModel.libelle,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Montant :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(creanceModel.montant,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Numéro d\'opération :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(creanceModel.numeroOperation,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            children: [
              Expanded(
                child: Text('signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(creanceModel.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Statut :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              (creanceModel.statutPaie)
                  ? Expanded(
                      child: SelectableText('Payé',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(color: Colors.blue.shade700)),
                    )
                  : Expanded(
                      child: SelectableText('Non Payé',
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(
                              color: Colors.orange.shade700)),
                    )
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          if (creanceModel.approbationDG == '-')
            Row(
              children: [
                Expanded(
                  child: Text('Approbation :',
                      textAlign: TextAlign.start,
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                ),
                if (creanceModel.approbationDG == "Approved")
                  Expanded(
                    child: SelectableText(creanceModel.approbationDG,
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(color: Colors.blue.shade700)),
                  ),
                if (creanceModel.approbationDG == "Unapproved")
                  Expanded(
                    child: SelectableText(creanceModel.approbationDG,
                        textAlign: TextAlign.start,
                        style: bodyMedium.copyWith(color: Colors.red.shade700)),
                  ),
              ],
            ),
          // if (creanceModel.approbation == false)
          //   const SizedBox(
          //     height: p20,
          //   ),
          // (isLoading) ? loading() : approbationWidget(),
          // const SizedBox(
          //   height: p20,
          // )
        ],
      ),
    );
  }

  // Color getColor(Set<MaterialState> states) {
  //   const Set<MaterialState> interactiveStates = <MaterialState>{
  //     MaterialState.pressed,
  //     MaterialState.hovered,
  //     MaterialState.focused,
  //   };
  //   if (states.any(interactiveStates.contains)) {
  //     return Colors.orange;
  //   }
  //   return Colors.green;
  // }

  // Widget approbationWidget() {
  //   final bodyMedium = Theme.of(context).textTheme.bodyMedium;
  //   return Container(
  //     padding: const EdgeInsets.only(top: p16, bottom: p16),
  //     decoration: const BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(20)),
  //       border: Border(
  //           // bottom: BorderSide(width: 1.0),
  //           ),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Expanded(
  //             flex: 3,
  //             child: Text('Approbation',
  //                 style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
  //         Expanded(
  //           flex: 3,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Checkbox(
  //                   checkColor: Colors.white,
  //                   fillColor: MaterialStateProperty.resolveWith(getColor),
  //                   value: approbation,
  //                   onChanged: (bool? value) {
  //                     setState(() {
  //                       isLoading = true;
  //                       approbation = value!;
  //                       submit();
  //                     });
  //                   })
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> submit() async {
  //   final creanceModel = CreanceModel(
  //       id: id,
  //       nomComplet: nomComplet.toString(),
  //       pieceJustificative: pieceJustificative.toString(),
  //       libelle: libelle.toString(),
  //       montant: montant.toString(),
  //       numeroOperation: numeroOperation.toString(),
  //       created: created!,
  //       signature: signature.toString(),
  //       approbation: approbation,
  //       statutPaie: statutPaie);
  //   await CreanceApi().updateData(id!, creanceModel);
  //   Routemaster.of(context).pop();
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: const Text("Approbation effectué!"),
  //     backgroundColor: Colors.green[700],
  //   ));
  // }
}
