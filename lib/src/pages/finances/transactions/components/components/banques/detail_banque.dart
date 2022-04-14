import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/finances/banque_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/banque_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:routemaster/routemaster.dart';

class DetailBanque extends StatefulWidget {
  const DetailBanque({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailBanque> createState() => _DetailBanqueState();
}

class _DetailBanqueState extends State<DetailBanque> {
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;
  List<UserModel> userList = [];

  bool statutAgent = false;
  
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  String? nomComplet;
  String? pieceJustificative;
  String? libelle;
  String? montant;
  List<dynamic>? coupureBillet;
  String? ligneBudgtaire; // somme d'affectation pour le budget
  String? departement;
  String? typeOperation;
  String? numeroOperation;
  DateTime? created;
  String? signature;

  @override
  initState() {
    getData();
    agentsColumn();
    agentsRow();
    super.initState();
  }

  Future<void> getData() async {
    final dataUser = await UserApi().getAllData();
    BanqueModel data = await BanqueApi().getOneData(widget.id);
    setState(() {
      userList = dataUser;
      nomComplet = data.nomComplet;
      pieceJustificative = data.pieceJustificative;
      libelle = data.libelle;
      montant = data.montant;
      coupureBillet = data.coupureBillet;
      ligneBudgtaire = data.ligneBudgtaire; // somme d'affectation pour le budget
      departement = data.departement;
      typeOperation = data.typeOperation;
      numeroOperation = data.numeroOperation;
      created = data.created;
      signature = data.signature;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: context.read<Controller>().scaffoldKey,
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
                    child: FutureBuilder<BanqueModel>(
                        future: BanqueApi().getOneData(widget.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<BanqueModel> snapshot) {
                          if (snapshot.hasData) {
                            BanqueModel? banqueModel = snapshot.data;
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
                                          title: '${banqueModel!.nomComplet} '),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: Scrollbar(
                                        controller: _controllerScroll,
                                        isAlwaysShown: true,
                                        child: pageDetail(banqueModel)))
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

  Widget pageDetail(BanqueModel banqueModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.all(p16),
            width: (Responsive.isDesktop(context))
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.5,
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
                    TitleWidget(title: banqueModel.libelle),
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
                          DateFormat("dd-MM-yy")
                              .format(banqueModel.created),
                          textAlign: TextAlign.start),
                      ],
                    )
                  ],
                ),
                dataWidget(banqueModel),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: tableauList(),
                )
              ],
            ),
          ),
        ),
      ]
    );
  }


  Widget dataWidget(BanqueModel banqueModel) {
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
                child: SelectableText(banqueModel.nomComplet,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Pièce justificative :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(banqueModel.pieceJustificative,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Libellé :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(banqueModel.libelle,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Montant :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(banqueModel.montant,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          if(banqueModel.typeOperation != 'Depot')
          Row(
            children: [
              Expanded(
                child: Text('Ligne budgtaire :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(banqueModel.ligneBudgtaire,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          if (banqueModel.typeOperation != 'Depot')
          Row(
            children: [
              Expanded(
                child: Text('Département :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(banqueModel.departement,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Type d\'opération :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(banqueModel.typeOperation,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Numéro d\'opération :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(banqueModel.numeroOperation,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(banqueModel.signature,
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
        title: 'nombreBillet',
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
        title: 'coupureBillet',
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
    // List<dynamic> dataList = list!;
    // var data = dataList;
    if (mounted) {
      setState(() {
        for (var item in coupureBillet!) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item[0]['id']),
            'nombreBillet': PlutoCell(value: item[1]['nombreBillet']),
            'coupureBillet': PlutoCell(value: item[2]['coupureBillet'])
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }

  
}
