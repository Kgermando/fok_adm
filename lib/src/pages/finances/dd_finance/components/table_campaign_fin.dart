import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/detail_campaign.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableCampaignFin extends StatefulWidget {
  const TableCampaignFin({Key? key}) : super(key: key);

  @override
  State<TableCampaignFin> createState() => _TableCampaignFinState();
}

class _TableCampaignFinState extends State<TableCampaignFin> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;

  @override
  void initState() {
    agentsColumn();
    agentsRow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: PlutoGrid(
        columns: columns,
        rows: rows,
        onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
          final dataList = tapEvent.row!.cells.values;
          final idPlutoRow = dataList.elementAt(0);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailCampaign(id: idPlutoRow.value)));
        },
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager!.setShowColumnFilter(true);
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
              if (column.field == 'typeProduit') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'dateDebutEtFin') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'coutCampaign') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'lieuCible') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'promotion') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'objetctifs') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'created') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              }
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            },
          ),
        ),
      ),
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
        title: 'Type Produit',
        field: 'typeProduit',
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
        title: 'Date Debut Et Fin',
        field: 'dateDebutEtFin',
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
        title: 'Coût de la Campaign',
        field: 'coutCampaign',
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
        title: 'Lieu Ciblé',
        field: 'lieuCible',
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
        title: 'Promotion',
        field: 'promotion',
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
        title: 'Objetctifs',
        field: 'objetctifs',
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
    List<CampaignModel?> dataList = await CampaignApi().getAllData();
    var data = dataList.where((element) => element!.approbationDD == '-');

    if (mounted) {
      setState(() {
        for (var item in data) {
          id = item!.id;
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'typeProduit': PlutoCell(value: item.typeProduit),
            'dateDebutEtFin': PlutoCell(value: item.dateDebutEtFin),
            'coutCampaign': PlutoCell(value: item.coutCampaign),
            'lieuCible': PlutoCell(value: item.lieuCible),
            'promotion': PlutoCell(value: item.promotion),
            'objetctifs': PlutoCell(value: item.objetctifs),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy H:mm").format(item.created))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
