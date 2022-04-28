import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/produit_model_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/button_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class AddCampaign extends StatefulWidget {
  const AddCampaign({Key? key, this.campaignModel}) : super(key: key);
  final CampaignModel? campaignModel;

  @override
  State<AddCampaign> createState() => _AddCampaignState();
}

class _AddCampaignState extends State<AddCampaign> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  DateTimeRange? dateRange;

  int? id;
  List<ProductModel> produitModelList = [];
  List<AgentModel> agentAffectesList = [];
  List<String> multiChecked = []; // Multi checkbox

  TextEditingController typeProduitController = TextEditingController();
  TextEditingController dateDebutEtFinController = TextEditingController();
  TextEditingController coutCampaignController = TextEditingController();
  TextEditingController lieuCibleController = TextEditingController();
  TextEditingController promotionController = TextEditingController();
  TextEditingController objetctifsController = TextEditingController();

  String getPlageDate() {
    if (dateRange == null) {
      return 'Date de Debut et Fin';
    } else {
      return '${DateFormat('dd/MM/yyyy').format(dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(dateRange!.end)}';
    }
  }

  @override
  initState() {
    getData();
    id = widget.campaignModel!.id;
    typeProduitController =
        TextEditingController(text: widget.campaignModel!.typeProduit);
    dateDebutEtFinController = TextEditingController(text: getPlageDate());
    multiChecked = widget.campaignModel!.agentAffectes;
    coutCampaignController =
        TextEditingController(text: widget.campaignModel!.coutCampaign);
    lieuCibleController =
        TextEditingController(text: widget.campaignModel!.lieuCible);
    promotionController =
        TextEditingController(text: widget.campaignModel!.promotion);
    objetctifsController =
        TextEditingController(text: widget.campaignModel!.objetctifs);

    super.initState();
  }

  @override
  void dispose() {
    _controllerScroll.dispose();

    typeProduitController.dispose();
    dateDebutEtFinController.dispose();
    coutCampaignController.dispose();
    lieuCibleController.dispose();
    promotionController.dispose();
    objetctifsController.dispose();

    super.dispose();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var agents = await AgentsApi().getAllData();
    var produitModel = await ProduitModelApi().getAllData();
    setState(() {
      user = userModel;
      agentAffectesList = agents;
      produitModelList = produitModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                            width: 20.0,
                            child: IconButton(
                                onPressed: () {
                                  Routemaster.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Nouvelle campaign',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addPageWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: SizedBox(
                width: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width,
                child: ListView(
                  controller: _controllerScroll,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [PrintWidget(onPressed: () {})],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(child: typeProduitWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: dateDebutEtFinWidget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: coutCampaignWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: lieuCibleWidget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: promotionWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: objetctifsWidget())
                      ],
                    ),
                    agentAffectesWidget(),
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
        ],
      ),
    );
  }

  Widget typeProduitWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: typeProduitController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Type de Produit',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget dateDebutEtFinWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: ButtonWidget(
        text: getPlageDate(),
        onClicked: () => setState(() {
          pickDateRange(context);
          FocusScope.of(context).requestFocus(FocusNode());
        }),
      ),
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }

  Widget agentAffectesWidget() {
    final List<String> multiChoises =
        agentAffectesList.map((e) => e.matricule).toSet().toList();
    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        height: 200,
        child: ListView.builder(
            itemCount: multiChoises.length,
            itemBuilder: (context, i) {
              return ListTile(
                  title: Text(multiChoises[i]),
                  leading: Checkbox(
                    value: multiChecked.contains(multiChoises[i]),
                    onChanged: (val) {
                      if (val == true) {
                        setState(() {
                          multiChecked.add(multiChoises[i]);
                        });
                      } else {
                        setState(() {
                          multiChecked.remove(multiChoises[i]);
                        });
                      }
                    },
                  ));
            }));
  }

  Widget coutCampaignWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: coutCampaignController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Coût Campaign',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget lieuCibleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: lieuCibleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Lieu Ciblé',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget promotionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: promotionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Promotion',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget objetctifsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: objetctifsController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Objetctifs',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Future<void> submit() async {
    final campaignModel = CampaignModel(
        typeProduit: typeProduitController.text,
        dateDebutEtFin: dateDebutEtFinController.text,
        agentAffectes: multiChecked,
        coutCampaign: coutCampaignController.text,
        lieuCible: lieuCibleController.text,
        promotion: promotionController.text,
        objetctifs: objetctifsController.text,
        ligneBudgtaire: '-',
        resources: '-',
        approbationDG: '-',
        signatureDG: '-',
        signatureJustificationDG: '-',
        approbationFin: '-',
        signatureFin: '-',
        signatureJustificationFin: '-',
        approbationBudget: '-',
        signatureBudget: '-',
        signatureJustificationBudget: '-',
        approbationDD: '-',
        signatureDD: '-',
        signatureJustificationDD: '-',
        signature: user!.matricule.toString(),
        created: DateTime.now());

    if (id != null) {
      await CampaignApi().updateData(id!, campaignModel);
    } else {
      await CampaignApi().insertData(campaignModel);
    }
    
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}