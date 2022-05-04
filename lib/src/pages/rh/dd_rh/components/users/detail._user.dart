import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/components/users/update_user.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:routemaster/routemaster.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class DetailUser extends StatefulWidget {
  const DetailUser({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;
  List<UserModel> userList = [];

  bool statutAgent = false;

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    getData();
    super.initState();
  }

  UserModel? user;
  Future<void> getData() async {
    var userModel = await UserApi().getOneData(widget.id);
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logo.png'),
          fit: BoxFit.cover,
          // opacity: .4
        ),
      ),
      child: Scaffold(
          key: _key,
          drawer: const DrawerMenu(),
          floatingActionButton: speedialWidget(),
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
                      child: FutureBuilder<UserModel>(
                          future: UserApi().getOneData(widget.id),
                          builder: (BuildContext context,
                              AsyncSnapshot<UserModel> snapshot) {
                            if (snapshot.hasData) {
                              UserModel? data = snapshot.data;
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
                                            title: "Matricule ${data!.matricule}",
                                            controllerMenu: () =>
                                                _key.currentState!.openDrawer()),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                      child: Scrollbar(
                                          controller: _controllerScroll,
                                          isAlwaysShown: true,
                                          child: pageDetail(data)))
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
          )),
    );
  }

  Widget pageDetail(UserModel data) {
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
                  Row(
                    children: [
                      TitleWidget(title: "Matricule ${data.matricule}"),
                    ],
                  ),
                  Column(
                    children: [
                      PrintWidget(
                              tooltip: 'Imprimer le document', onPressed: () {}),
                      SelectableText(
                          DateFormat("dd-MM-yy").format(data.createdAt),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dialogWidget() {
    return const Dialog(
      child: AlertDialog(
        title: Text("data"),
        content: Text("data"),
      ),
    );
  }

  Widget dataWidget(UserModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.nom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Prenom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.prenom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Matricule :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.matricule,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Département :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.departement,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Services d\'Affectation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.servicesAffectation,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Fonction Occupée :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.fonctionOccupe,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Accreditation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.role,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          // if (data.succursale != '-')
          Row(
            children: [
              Expanded(
                child: Text('Succursale :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.succursale,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }

  SpeedDial speedialWidget() {
    return SpeedDial(
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.check_box_outline_blank),
          foregroundColor: Colors.black,
          backgroundColor: Colors.green.shade700,
          label: 'Supprimer l\'accès',
          onPressed: () => deletteAccesUser(),
        ),
        SpeedDialChild(
          child: const Icon(Icons.check_box),
          foregroundColor: Colors.white,
          backgroundColor: Colors.orange.shade700,
          label: 'Mettre à jour',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UpdateUser(userModel: user!)));
          },
        )
      ],
    );
  }

    Widget deletteAccesUser() {
    return IconButton(
      color: Colors.red,
      icon: const Icon(Icons.person_off),
      tooltip: 'Supprimer l\'accès cet utilisateur',
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de vouloir restituer la quantité?'),
          content: const Text(
              'Cette action permet de restitutuer la quantité chez l\'expediteur.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Annuler'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                  await UserApi().deleteData(user!.id!);
                    Routemaster.of(context).pop();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                      content: const Text(
                          "Compte supprimé avec succès!"),
                      backgroundColor: Colors.red.shade700,
                    ));
                Routemaster.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

}
