import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart'; 
import 'package:fokad_admin/src/api/finances/caisse_api.dart';
import 'package:fokad_admin/src/api/finances/coupure_billet_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart'; 
import 'package:fokad_admin/src/models/finances/caisse_model.dart';
import 'package:fokad_admin/src/models/finances/coupure_billet_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DetailCaisse extends StatefulWidget {
  const DetailCaisse({Key? key}) : super(key: key);

  @override
  State<DetailCaisse> createState() => _DetailCaisseState();
}

class _DetailCaisseState extends State<DetailCaisse> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;
  List<UserModel> userList = [];

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  initState() {
    getData();
    agentsRow();
    agentsColumn();
    super.initState();
  }

  UserModel? user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');

  List<CoupureBilletModel> coupureBilletList = [];
  List<CoupureBilletModel> coupureBilletFilter = [];
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId(); 
    final dataUser = await UserApi().getAllData();
    var coupureBillets = await CoupureBilletApi().getAllData();
    setState(() { 
      user = userModel;
      userList = dataUser;
      coupureBilletFilter = coupureBillets;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
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
                    child: FutureBuilder<CaisseModel>(
                        future: CaisseApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<CaisseModel> snapshot) {
                          if (snapshot.hasData) {
                            CaisseModel? data = snapshot.data;
                            coupureBilletList = coupureBilletFilter
                                .where((element) =>
                                    element.reference == data!.createdRef)
                                .toList(); 
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: p20,
                                      child: IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: "Caisse",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        controller: _controllerScroll,
                                        child: pageDetail(data!)))
                              ],
                            );
                          } else {
                            return Center(
                                child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(CaisseModel caisseModel) {
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
                  TitleWidget(title: caisseModel.typeOperation),
                  Column(
                    children: [
                      PrintWidget(
                          tooltip: 'Imprimer le document', onPressed: () {}),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm")
                              .format(caisseModel.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(caisseModel),
              SizedBox(
                height: 300,
                width: double.infinity,
                child: tableauList(),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(CaisseModel caisseModel) {
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
                child: SelectableText(caisseModel.nomComplet,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Pièce justificative :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(caisseModel.pieceJustificative,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Libellé :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(caisseModel.libelle,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Montant :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(caisseModel.montant,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          if (caisseModel.typeOperation != 'Depot')
            Divider(color: Colors.amber.shade700),
          if (caisseModel.typeOperation != 'Depot')
            Row(
              children: [
                Expanded(
                  child: Text('Département :',
                      textAlign: TextAlign.start,
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: SelectableText(caisseModel.departement,
                      textAlign: TextAlign.start, style: bodyMedium),
                )
              ],
            ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Type d\'opération :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(caisseModel.typeOperation,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Numéro d\'opération :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(caisseModel.numeroOperation,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(caisseModel.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget tableauList() {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager!.setShowColumnFilter(true);
        stateManager!.notifyListeners();
      },
      createHeader: (PlutoGridStateManager header) {
        return const TitleWidget(title: 'Coupure billets');
      },
    );
  }

  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'N°',
        field: 'id',
        type: PlutoColumnType.number(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 100,
        minWidth: 80,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Nombre',
        field: 'nombreBillet',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Coupure',
        field: 'coupureBillet',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
    ];
  }

  Future agentsRow() async {
    if (mounted) {
      setState(() {
        for (var item in coupureBilletList) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'nombreBillet': PlutoCell(value: item.nombreBillet),
            'coupureBillet': PlutoCell(value: item.coupureBillet)
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
