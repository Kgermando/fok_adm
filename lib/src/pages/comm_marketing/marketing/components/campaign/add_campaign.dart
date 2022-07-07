import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart'; 
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart'; 
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart'; 
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/button_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class AddCampaign extends StatefulWidget {
  const AddCampaign({Key? key}) : super(key: key);

  @override
  State<AddCampaign> createState() => _AddCampaignState();
}

class _AddCampaignState extends State<AddCampaign> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  DateTimeRange? dateRange;

  TextEditingController typeProduitController = TextEditingController();
  TextEditingController dateDebutEtFinController = TextEditingController();
  TextEditingController coutCampaignController = TextEditingController();
  TextEditingController lieuCibleController = TextEditingController();
  TextEditingController promotionController = TextEditingController();
  TextEditingController objectifsController = TextEditingController();

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
    super.initState();
  }

  @override
  void dispose() {
    typeProduitController.dispose();
    dateDebutEtFinController.dispose();
    coutCampaignController.dispose();
    lieuCibleController.dispose();
    promotionController.dispose();
    objectifsController.dispose();

    super.dispose();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();  
    if(!mounted) return;
    setState(() {
      user = userModel; 
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
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ),
                          const SizedBox(width: p10),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Campagne',
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
                    const TitleWidget(title: "Nouvelle campagne"),
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
                        Expanded(child: objectifsWidget())
                      ],
                    ), 
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

  Widget coutCampaignWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: coutCampaignController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
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
              ),
            ),
            const SizedBox(width: p20),
            Expanded(
                flex: 1,
                child: Text("\$", style: Theme.of(context).textTheme.headline6))
          ],
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

  Widget objectifsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: objectifsController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'objectifs',
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
      dateDebutEtFin:
          "Du ${DateFormat('dd/MM/yyyy').format(dateRange!.start)} - Au ${DateFormat('dd/MM/yyyy').format(dateRange!.end)}",
      coutCampaign: coutCampaignController.text,
      lieuCible: lieuCibleController.text,
      promotion: promotionController.text,
      objectifs: objectifsController.text,
      observation: 'false',
      signature: user!.matricule.toString(),
      createdRef: DateTime.now(),
      created: DateTime.now(),
      approbationDG: '-',
      motifDG: '-',
      signatureDG: '-',
      approbationBudget: '-',
      motifBudget: '-',
      signatureBudget: '-',
      approbationFin: '-',
      motifFin: '-',
      signatureFin: '-',
      approbationDD: '-',
      motifDD: '-',
      signatureDD: '-',
      ligneBudgetaire: '-',
      ressource: '-'
    );

    await CampaignApi().insertData(campaignModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Document soumis chez le DG avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
