import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
                  child: FutureBuilder<UserModel>(
                    future: AuthApi().getUserId(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserModel? userInfo = snapshot.data;
                        if (userInfo != null) {
                          var userData = userInfo;
                          return Expanded(child: profileBody(userData));
                        }
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget profileBody(UserModel userModel) {
    final headline5 = Theme.of(context).textTheme.headline5;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    
    final String firstLettter2 = userModel.prenom[0];
    final String firstLettter = userModel.nom[0];

    return ListView(
      children: [
        Stack(
          clipBehavior: Clip.none, 
          children: [
            
            Container(
              color: Colors.amber.shade700,
              height: 200,
              width: double.infinity,
            ),
            Positioned(
              top: 20,
              left: 20,
              child: AutoSizeText("Mon Profil", 
                maxLines: 1,
              style: headline5!.copyWith(color: Colors.white),)
            ),
            Positioned(
              top: 130,
              left: 50,
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: AutoSizeText(
                    '$firstLettter2$firstLettter'.toUpperCase(),
                    maxLines: 1,
                    style: headline5.copyWith(color: Colors.orange.shade700),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: 180,
              child: AutoSizeText(
                "${userModel.prenom} ${userModel.nom}",
                maxLines: 2,
                style: headline5.copyWith(color: Colors.white)
              )
            ),

            Positioned(
              top: 155,
              right: 20,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  shape: BoxShape.circle,
                ),
              )
            )

          ],
        ),
        const SizedBox(height: p50),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                  child: AutoSizeText('Nom', maxLines: 1, 
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))
                ),
                const SizedBox(width: p20),
                Expanded(child: AutoSizeText(userModel.nom, maxLines: 1, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
           elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Prénom', maxLines: 1, 
                    style: bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child:
                        AutoSizeText(userModel.prenom, maxLines: 1, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
         elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Matricule', maxLines: 1, 
                    style: bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.matricule,
                        maxLines: 1, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Département',
                        maxLines: 1, style: bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.departement,
                        maxLines: 1, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Services d\'Affectation',
                        maxLines: 1, style: bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.servicesAffectation,
                        maxLines: 1, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Fonction Occupée',
                        maxLines: 1, style: bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.fonctionOccupe,
                        maxLines: 1, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Accréditation',
                        maxLines: 1, style: bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.role,
                        maxLines: 1, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Succursale',
                        maxLines: 1, style: bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.succursale,
                        maxLines: 1, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Date de création',
                        maxLines: 1, style: bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(
                        DateFormat("dd.MM.yy HH:mm").format(userModel.createdAt),
                        maxLines: 1, style: bodyLarge))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
