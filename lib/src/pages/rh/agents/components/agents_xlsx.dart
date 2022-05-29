import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';

// External package imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

// Local import
import '/src/helpers/save_file_mobile.dart'
    if (dart.library.html) 'src/helpers/save_file_web.dart' as helper;

class AgentXlsx extends StatefulWidget {
  const AgentXlsx({Key? key}) : super(key: key);

  @override
  State<AgentXlsx> createState() => _AgentXlsxState();
}

class _AgentXlsxState extends State<AgentXlsx> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<SfDataGridState> _sfDataGridKey =
      GlobalKey<SfDataGridState>();

  List<AgentModel> _dataList = <AgentModel>[];
  late AgentDataSource _agentDataSource;

  @override
  void initState() {
    _agentDataSource = AgentDataSource(data: []);
    getData();
    super.initState();
  }

  Future<void> getData() async {
    List<AgentModel> data = await AgentsApi().getAllData();
    setState(() {
      _dataList = data;
      _agentDataSource = AgentDataSource(data: _dataList);
    });
  }

  Future<void> _exportDataGridToExcel() async {
    final Workbook workbook =
        _sfDataGridKey.currentState!.exportToExcelWorkbook();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await helper.saveAndLaunchFile(bytes, 'rh.xlsx');
  }

  Future<void> _exportDataGridToPdf() async {
    final PdfDocument document = _sfDataGridKey.currentState!
        .exportToPdfDocument(fitAllColumnsInOnePage: true);

    final List<int> bytes = document.save();
    await helper.saveAndLaunchFile(bytes, 'rh.pdf');
    document.dispose();
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: p20,
                            child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back)),
                          ),
                          const SizedBox(width: p10),
                          Expanded(
                            child: CustomAppbar(
                                title: 'Impression Agents',
                                controllerMenu: () =>
                                    _key.currentState!.openDrawer()),
                          ),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                              padding: const EdgeInsets.all(p20),
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: tableData())))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget tableData() {
    return Card(
      elevation: 10,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(12.0),
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                  width: 150.0,
                  child: MaterialButton(
                      color: Colors.green.shade700,
                      onPressed: _exportDataGridToExcel,
                      child: const Center(
                          child: Text(
                        'Export to Excel',
                        style: TextStyle(color: Colors.white),
                      ))),
                ),
                const Padding(padding: EdgeInsets.all(20)),
                SizedBox(
                  height: 40.0,
                  width: 150.0,
                  child: MaterialButton(
                      color: Colors.blue.shade700,
                      onPressed: _exportDataGridToPdf,
                      child: const Center(
                          child: Text(
                        'Export to PDF',
                        style: TextStyle(color: Colors.white),
                      ))),
                ),
              ],
            ),
          ),
          SfDataGrid(
            key: _sfDataGridKey,
            source: _agentDataSource,
            columns: <GridColumn>[
              GridColumn(
                  columnName: 'ID',
                  label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'ID',
                      ))),
              GridColumn(
                  columnName: 'Nom',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Nom'))),
              GridColumn(
                  columnName: 'Post Nom',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Post Nom',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'Prénom',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Prénom'))),
              GridColumn(
                  columnName: 'Email',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Email'))),
              GridColumn(
                  columnName: 'Téléphone',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Téléphone'))),
              GridColumn(
                  columnName: 'Adresse',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Adresse'))),
              GridColumn(
                  columnName: 'Genre',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Sexe'))),
              GridColumn(
                  columnName: 'Accreditation',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Accreditation'))),
              GridColumn(
                  columnName: 'Matricule',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Matricule'))),
              GridColumn(
                  columnName: 'Numero Securité Sociale',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Numero Securité Sociale'))),
              GridColumn(
                  columnName: 'Date Naissance',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Date Naissance'))),
              GridColumn(
                  columnName: 'Lieu Naissance',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Lieu Naissance'))),
              GridColumn(
                  columnName: 'Nationalité',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Nationalité'))),
              GridColumn(
                  columnName: 'Type Contrat',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Type Contrat'))),
              GridColumn(
                  columnName: 'Département',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Département'))),
              GridColumn(
                  columnName: 'Service Affectation',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Service Affectation'))),
              GridColumn(
                  columnName: 'Date Debut Contrat',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Date Debut Contrat'))),
              GridColumn(
                  columnName: 'Date Fin Contrat',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Date Fin Contrat'))),
              GridColumn(
                  columnName: 'Fonction Occupeée',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fonction Occupeée'))),
              GridColumn(
                  columnName: 'Formation',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Formation'))),
              GridColumn(
                  columnName: 'Experience',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Experience'))),
              GridColumn(
                  columnName: 'Statut Agent',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Statut Agent'))),
              GridColumn(
                  columnName: 'Date de Creation',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Date de Creation'))),
              GridColumn(
                  columnName: 'Photo',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Photo'))),
              GridColumn(
                  columnName: 'Salaire',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Salaire'))),
              GridColumn(
                  columnName: 'Signature',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Signature'))),
              GridColumn(
                  columnName: 'Mise à jour',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Mise à jour'))),
            ],
          ),
        ],
      ),
    );
  }
}

class AgentDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  AgentDataSource({required List<AgentModel> data}) {
    _data = data
        .map<DataGridRow>((AgentModel e) => DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'ID', value: e.id),
              DataGridCell<String>(columnName: 'Nom', value: e.nom),
              DataGridCell<String>(columnName: 'Post Nom', value: e.postNom),
              DataGridCell<String>(columnName: 'Prénom', value: e.prenom),
              DataGridCell<String>(columnName: 'Email', value: e.email),
              DataGridCell<String>(columnName: 'Téléphone', value: e.telephone),
              DataGridCell<String>(columnName: 'Adresse', value: e.adresse),
              DataGridCell<String>(columnName: 'Genre', value: e.sexe),
              DataGridCell<String>(columnName: 'Accreditation', value: e.role),
              DataGridCell<String>(columnName: 'Matricule', value: e.matricule),
              DataGridCell<String>(
                  columnName: 'Numero Securité Sociale',
                  value: e.numeroSecuriteSociale),
              DataGridCell<DateTime>(
                  columnName: 'Date Naissance', value: e.dateNaissance),
              DataGridCell<String>(
                  columnName: 'Lieu Naissance', value: e.lieuNaissance),
              DataGridCell<String>(
                  columnName: 'Nationalité', value: e.nationalite),
              DataGridCell<String>(
                  columnName: 'Type Contrat', value: e.typeContrat),
              DataGridCell<String>(
                  columnName: 'Département', value: e.departement),
              DataGridCell<String>(
                  columnName: 'Service Affectation',
                  value: e.servicesAffectation),
              DataGridCell<DateTime>(
                  columnName: 'Date Debut Contrat', value: e.dateDebutContrat),
              DataGridCell<DateTime>(
                  columnName: 'Date Fin Contrat', value: e.dateFinContrat),
              DataGridCell<String>(
                  columnName: 'Fonction Occupeée', value: e.fonctionOccupe),
              DataGridCell<String>(
                  columnName: 'Formation', value: e.competance),
              DataGridCell<String>(
                  columnName: 'Experience', value: e.experience),
              DataGridCell<bool>(
                  columnName: 'Statut Agent', value: e.statutAgent),
              DataGridCell<DateTime>(
                  columnName: 'Date de Creation', value: e.createdAt),
              DataGridCell<String>(columnName: 'Photo', value: e.photo),
              DataGridCell<String>(columnName: 'Salaire', value: e.salaire),
              DataGridCell<String>(columnName: 'Signature', value: e.signature),
              DataGridCell<DateTime>(columnName: 'Mise à jour', value: e.created)
            ]))
        .toList();
  }

  List<DataGridRow> _data = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell cell) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(cell.value.toString()),
      );
    }).toList());
  }
}
