import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/carburant_api.dart';
import 'package:fokad_admin/src/models/logistiques/carburant_model.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/detail_carburant.dart';
import 'package:fokad_admin/src/widgets/card_widget_carburant.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableCarburantDD extends StatefulWidget {
  const TableCarburantDD({Key? key}) : super(key: key);

  @override
  State<TableCarburantDD> createState() => _TableCarburantDDState();
}

class _TableCarburantDDState extends State<TableCarburantDD> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;

  double entrerEssence = 0.0;
  double sortieEssence = 0.0;

  double entrerMazoute = 0.0;
  double sortieMazoute = 0.0;

  double entrerHuilleMoteur = 0.0;
  double sortieHuilleMoteur = 0.0;

  double entrerPetrole = 0.0;
  double sortiePetrole = 0.0;

  @override
  void initState() {
    getData();
    agentsColumn();
    agentsRow();
    super.initState();
  }

  Future<void> getData() async {
    List<CarburantModel?> dataList = await CarburantApi().getAllData();
    setState(() {
      List<CarburantModel?> entreListEssence = dataList
          .where((element) =>
              element!.operationEntreSortie == "Entrer" &&
              element.typeCaburant == "Essence")
          .toList();
      List<CarburantModel?> sortieListEssence = dataList
          .where((element) =>
              element!.operationEntreSortie == "Sortie" &&
              element.typeCaburant == "Essence")
          .toList();
      for (var item in entreListEssence) {
        entrerEssence += double.parse(item!.qtyAchat);
      }
      for (var item in sortieListEssence) {
        sortieEssence += double.parse(item!.qtyAchat);
      }

      List<CarburantModel?> entrerListMazoute = dataList
          .where((element) =>
              element!.operationEntreSortie == "Entrer" &&
              element.typeCaburant == "Mazoutte")
          .toList();
      List<CarburantModel?> sortieListMazoute = dataList
          .where((element) =>
              element!.operationEntreSortie == "Sortie" &&
              element.typeCaburant == "Mazoutte")
          .toList();
      for (var item in entrerListMazoute) {
        entrerMazoute += double.parse(item!.qtyAchat);
      }
      for (var item in sortieListMazoute) {
        sortieMazoute += double.parse(item!.qtyAchat);
      }

      List<CarburantModel?> entrerListHuilleMoteur = dataList
          .where((element) =>
              element!.operationEntreSortie == "Entrer" &&
              element.typeCaburant == "Huille moteur")
          .toList();
      List<CarburantModel?> sortieListHuilleMoteur = dataList
          .where((element) =>
              element!.operationEntreSortie == "Sortie" &&
              element.typeCaburant == "Huille moteur")
          .toList();
      for (var item in entrerListHuilleMoteur) {
        entrerHuilleMoteur += double.parse(item!.qtyAchat);
      }
      for (var item in sortieListHuilleMoteur) {
        sortieHuilleMoteur += double.parse(item!.qtyAchat);
      }

      List<CarburantModel?> entrerListPetrole = dataList
          .where((element) =>
              element!.operationEntreSortie == "Entrer" &&
              element.typeCaburant == "Pétrole")
          .toList();
      List<CarburantModel?> sortieListPetrole = dataList
          .where((element) =>
              element!.operationEntreSortie == "Sortie" &&
              element.typeCaburant == "Pétrole")
          .toList();
      for (var item in entrerListPetrole) {
        entrerPetrole += double.parse(item!.qtyAchat);
      }
      for (var item in sortieListPetrole) {
        sortiePetrole += double.parse(item!.qtyAchat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Expanded(
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
            final dataList = tapEvent.row!.cells.values;
            final idPlutoRow = dataList.elementAt(0);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailCaburant(id: idPlutoRow.value)));
          },
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager!.setShowColumnFilter(true);
            stateManager!.notifyListeners();
          },
          createHeader: (PlutoGridStateManager header) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [PrintWidget(onPressed: () {})],
            );
          },
          configuration: PlutoGridConfiguration(
            columnFilterConfig: PlutoGridColumnFilterConfig(
              filters: const [
                ...FilterHelper.defaultFilters,
                // custom filter
                ClassFilterImplemented(),
              ],
              resolveDefaultColumnFilter: (column, resolver) {
                if (column.field == 'qtyEntreSortie') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'typeCaburant') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'fournisseur') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'nomeroFactureAchat') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'prixAchatParLitre') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'nomReceptioniste') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'numeroPlaque') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'dateHeureSortieAnguin') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'created') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                }
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget totalEssence() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 12.0,
      runSpacing: 12.0,
      direction: Axis.horizontal,
      children: [
        CardWidgetCarburant(
          title: 'Ravitailement Essence',
          icon: Icons.ev_station_sharp,
          qty: '$entrerEssence',
          color: Colors.green.shade700,
          colorText: Colors.white,
        ),
        CardWidgetCarburant(
          title: 'Consommation Essence',
          icon: Icons.ev_station_sharp,
          qty: '$sortieEssence',
          color: Colors.red.shade700,
          colorText: Colors.white,
        ),
        CardWidgetCarburant(
          title: 'Disponible Essence',
          icon: Icons.ev_station_sharp,
          qty: '${entrerEssence - sortieEssence}',
          color: Colors.orange.shade700,
          colorText: Colors.white,
        ),
        CardWidgetCarburant(
          title: 'Mazoute',
          icon: Icons.ev_station_sharp,
          qty: '$entrerMazoute',
          color: Colors.green.shade700,
          colorText: Colors.white,
        ),
        CardWidgetCarburant(
          title: 'Mazoute',
          icon: Icons.ev_station_sharp,
          qty: '$sortieMazoute',
          color: Colors.red.shade700,
          colorText: Colors.white,
        ),
        CardWidgetCarburant(
          title: 'Mazoute',
          icon: Icons.ev_station_sharp,
          qty: '${entrerMazoute - sortieMazoute}',
          color: Colors.orange.shade700,
          colorText: Colors.white,
        ),
        CardWidgetCarburant(
          title: 'Petrole',
          icon: Icons.ev_station_sharp,
          qty: '$entrerPetrole',
          color: Colors.green.shade700,
          colorText: Colors.white,
        ),
        CardWidgetCarburant(
          title: 'Petrole',
          icon: Icons.ev_station_sharp,
          qty: '$sortiePetrole',
          color: Colors.red.shade700,
          colorText: Colors.white,
        ),
        CardWidgetCarburant(
          title: 'Petrole',
          icon: Icons.ev_station_sharp,
          qty: '${entrerPetrole - sortiePetrole}',
          color: Colors.orange.shade700,
          colorText: Colors.white,
        ),
        CardWidgetCarburant(
          title: 'Huile Moteur',
          icon: Icons.ev_station_sharp,
          qty: '$entrerHuilleMoteur',
          color: Colors.green.shade700,
          colorText: Colors.white,
        ),
        CardWidgetCarburant(
          title: 'Huile Moteur',
          icon: Icons.ev_station_sharp,
          qty: '$sortieHuilleMoteur',
          color: Colors.red.shade700,
          colorText: Colors.white,
        ),
        CardWidgetCarburant(
          title: 'Huile Moteur',
          icon: Icons.ev_station_sharp,
          qty: '${entrerHuilleMoteur - sortieHuilleMoteur}',
          color: Colors.orange.shade700,
          colorText: Colors.white,
        )
      ],
    );
  }


  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'Id',
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
        title: 'Opération',
        field: 'operationEntreSortie',
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
        title: 'Type Caburant',
        field: 'typeCaburant',
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
        title: 'Fournisseur',
        field: 'fournisseur',
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
        title: 'Numero Facture Achat',
        field: 'nomeroFactureAchat',
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
        title: 'Prix Achat Par Litre',
        field: 'prixAchatParLitre',
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
        title: 'Nom du receptioniste',
        field: 'nomReceptioniste',
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
        title: 'Numero Plaque',
        field: 'numeroPlaque',
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
        title: 'Date Heure Sortie',
        field: 'dateHeureSortieAnguin',
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
        title: 'Date',
        field: 'created',
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
    List<CarburantModel?> dataList = await CarburantApi().getAllData();
    var data =
        dataList.toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'operationEntreSortie': PlutoCell(value: item.operationEntreSortie),
            'typeCaburant': PlutoCell(value: item.typeCaburant),
            'fournisseur': PlutoCell(value: item.fournisseur),
            'nomeroFactureAchat': PlutoCell(value: item.nomeroFactureAchat),
            'prixAchatParLitre': PlutoCell(value: item.prixAchatParLitre),
            'nomReceptioniste': PlutoCell(value: item.nomReceptioniste),
            'numeroPlaque': PlutoCell(value: item.numeroPlaque),
            'dateHeureSortieAnguin': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm")
                    .format(item.dateHeureSortieAnguin)),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
