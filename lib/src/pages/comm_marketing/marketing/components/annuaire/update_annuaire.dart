import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/annuaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';


class UpdateAnnuaire extends StatefulWidget {
  const UpdateAnnuaire({Key? key})
      : super(key: key); 

  @override
  State<UpdateAnnuaire> createState() => _UpdateAnnuaireState();
}

class _UpdateAnnuaireState extends State<UpdateAnnuaire> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  TextEditingController nomPostnomPrenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobile1Controller = TextEditingController();
  TextEditingController mobile2Controller = TextEditingController();
  TextEditingController secteurActiviteController = TextEditingController();
  TextEditingController nomEntrepriseController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController adresseEntrepriseController = TextEditingController();

  int? id;
  String? categorie;

  @override
  void initState() {
    getData(); 
    super.initState();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  void dispose() {
    nomPostnomPrenomController.dispose();
    emailController.dispose();
    mobile1Controller.dispose(); 
    mobile2Controller.dispose();
    secteurActiviteController.dispose();
    nomEntrepriseController.dispose();
    gradeController.dispose();
    adresseEntrepriseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AnnuaireColor annuaireColor =
        ModalRoute.of(context)!.settings.arguments as AnnuaireColor;
    id = annuaireColor.annuaireModel.id;
    categorie = annuaireColor.annuaireModel.categorie;
    nomPostnomPrenomController =
        TextEditingController(text: annuaireColor.annuaireModel.nomPostnomPrenom);
    emailController = TextEditingController(text: annuaireColor.annuaireModel.email);
    mobile1Controller =
        TextEditingController(text: annuaireColor.annuaireModel.mobile1);
    mobile2Controller =
        TextEditingController(text: annuaireColor.annuaireModel.mobile2);
    secteurActiviteController =
        TextEditingController(text: annuaireColor.annuaireModel.secteurActivite);
    nomEntrepriseController =
        TextEditingController(text: annuaireColor.annuaireModel.nomEntreprise);
    gradeController = TextEditingController(text: annuaireColor.annuaireModel.grade);
    adresseEntrepriseController =
        TextEditingController(text: annuaireColor.annuaireModel.adresseEntreprise);  

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
                                  title: 'Modification du contact',
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        TitleWidget(title: "Modification contact"),
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    categorieField(),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                            child: nomPostnomPrenomField(),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            child: emailField(),
                          )
                        ],
                      ),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(child: mobile1Field()),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Expanded(child: mobile2Field()),
                        ],
                      ),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(child: secteurActiviteField()),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Expanded(child: nomEntrepriseField()),
                        ],
                      ),
                    if (!Responsive.isDesktop(context)) nomPostnomPrenomField(),
                    if (!Responsive.isDesktop(context)) emailField(),
                    if (!Responsive.isDesktop(context)) mobile1Field(),
                    if (!Responsive.isDesktop(context)) mobile2Field(),
                    if (!Responsive.isDesktop(context)) secteurActiviteField(),
                    if (!Responsive.isDesktop(context)) nomEntrepriseField(),
                    if (!Responsive.isDesktop(context)) gradeField(),
                    if (!Responsive.isDesktop(context))
                      adresseEntrepriseField(),
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

  Widget categorieField() {
    List<String> categorieList = ['Fournisseur', 'Client'];
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type de contact',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: categorie,
        isExpanded: true,
        items: categorieList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            categorie = value;
          });
        },
      ),
    );
  }

  Widget nomPostnomPrenomField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: nomPostnomPrenomController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Nom complet',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est obligatoire';
          }
          return null;
        },
      ),
    );
  }

  Widget emailField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'Ce champ est obligatoire';
        //   }
        //   return null;
        // },
      ),
    );
  }

  Widget mobile1Field() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: mobile1Controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'T??l??phone 1',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est obligatoire';
          }
          return null;
        },
      ),
    );
  }

  Widget mobile2Field() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: mobile2Controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'T??l??phone 2',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'Ce champ est obligatoire';
        //   }
        //   return null;
        // },
      ),
    );
  }

  Widget secteurActiviteField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: secteurActiviteController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Secteur d\'activit??',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value != null && value.isEmpty) {
        //     return 'Ce champs est obligatoire';
        //   } else {
        //     return null;
        //   }
        // },
      ),
    );
  }

  Widget nomEntrepriseField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: nomEntrepriseController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Entreprise ou business',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value != null && value.isEmpty) {
        //     return 'Ce champs est obligatoire';
        //   } else {
        //     return null;
        //   }
        // },
      ),
    );
  }

  Widget gradeField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: gradeController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Grade ou fonction',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value != null && value.isEmpty) {
        //     return 'Ce champs est obligatoire';
        //   } else {
        //     return null;
        //   }
        // },
      ),
    );
  }

  Widget adresseEntrepriseField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: adresseEntrepriseController,
        keyboardType: TextInputType.text,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: 'Adresse',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    final annuaireModel = AnnuaireModel(
      id: id!,
        categorie: categorie.toString(),
        nomPostnomPrenom: nomPostnomPrenomController.text,
        email: emailController.text,
        mobile1: mobile1Controller.text,
        mobile2: mobile2Controller.text,
        secteurActivite: secteurActiviteController.text,
        nomEntreprise: nomEntrepriseController.text,
        grade: gradeController.text,
        adresseEntreprise: adresseEntrepriseController.text,
        succursale: user!.succursale,
        signature: user!.matricule,
        created: DateTime.now());

    await AnnuaireApi().updateData(annuaireModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succ??s!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
