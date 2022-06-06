import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/archives/archive_api.dart';
import 'package:fokad_admin/src/api/archives/archive_folderapi.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableArchive extends StatefulWidget {
  const TableArchive({Key? key}) : super(key: key);

  @override
  State<TableArchive> createState() => _TableArchiveState();
}

class _TableArchiveState extends State<TableArchive> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;
  ArchiveFolderModel? archiveFolder;

  @override
  void initState() {
    agentsColumn();
    agentsRow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    archiveFolder =
        ModalRoute.of(context)!.settings.arguments as ArchiveFolderModel;

    return Scaffold(
    key: _key,
    drawer: const DrawerMenu(),
    floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, ArchiveRoutes.addArchives,
              arguments: archiveFolder);
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
                child: FutureBuilder<ArchiveFolderModel>(
                    future:
                        ArchiveFolderApi().getOneData(archiveFolder!.id!),
                    builder: (BuildContext context,
                        AsyncSnapshot<ArchiveFolderModel> snapshot) {
                      if (snapshot.hasData) {
                        ArchiveFolderModel? archiveModel = snapshot.data;
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
                                      title: archiveModel!.folderName,
                                      controllerMenu: () =>
                                          _key.currentState!.openDrawer()),
                                ),
                              ],
                            ),
                            Expanded(
                                child: PlutoGrid(
                              columns: columns,
                              rows: rows,
                              onRowDoubleTap:
                                  (PlutoGridOnRowDoubleTapEvent tapEvent) {
                                final dataList = tapEvent.row!.cells.values;
                                final idPlutoRow = dataList.elementAt(0);
                                Navigator.pushNamed(
                                    context, ArchiveRoutes.archivesDetail,
                                    arguments: idPlutoRow.value);
                              },
                              onLoaded: (PlutoGridOnLoadedEvent event) {
                                stateManager = event.stateManager;
                                stateManager!.setShowColumnFilter(true);
                              },
                              createHeader: (PlutoGridStateManager header) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              ArchiveRoutes.archiveTable);
                                        },
                                        icon: const Icon(Icons.refresh)),
                                    PrintWidget(onPressed: () {})
                                  ],
                                );
                              },
                              configuration: PlutoGridConfiguration(
                                columnFilterConfig:
                                    PlutoGridColumnFilterConfig(
                                  filters: const [
                                    ...FilterHelper.defaultFilters,
                                    // custom filter
                                    ClassFilterImplemented(),
                                  ],
                                  resolveDefaultColumnFilter:
                                      (column, resolver) {
                                    if (column.field == 'id') {
                                      return resolver<
                                              ClassFilterImplemented>()
                                          as PlutoFilterType;
                                    } else if (column.field ==
                                        'nomDocument') {
                                      return resolver<
                                              ClassFilterImplemented>()
                                          as PlutoFilterType;
                                    } else if (column.field ==
                                        'departement') {
                                      return resolver<
                                              ClassFilterImplemented>()
                                          as PlutoFilterType;
                                    } else if (column.field ==
                                        'signature') {
                                      return resolver<
                                              ClassFilterImplemented>()
                                          as PlutoFilterType;
                                    } else if (column.field == 'created') {
                                      return resolver<
                                              ClassFilterImplemented>()
                                          as PlutoFilterType;
                                    }
                                    return resolver<
                                            PlutoFilterTypeContains>()
                                        as PlutoFilterType;
                                  },
                                ),
                              ),
                            ))
                          ],
                        );
                      } else {
                        return Center(child: loading());
                      }
                    })),
          ),
        ],
      ),
    ));
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
        title: 'Nom du document',
        field: 'nomDocument',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Département',
        field: 'departement',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Signature',
        field: 'signature',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
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
        width: 200,
        minWidth: 150,
      ),
    ];
  }

  Future agentsRow() async {
    List<ArchiveModel?> dataList = await ArchiveApi().getAllData();
    var data = dataList.where((element) =>
        element!.departement == archiveFolder!.departement &&
        element.folderName == archiveFolder!.folderName);

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'nomDocument': PlutoCell(value: item.nomDocument),
            'departement': PlutoCell(value: item.departement),
            'signature': PlutoCell(value: item.signature),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created)),
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
