import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: AuthApi().getuserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel? userInfo = snapshot.data;
          if (userInfo != null) {
            var userData = userInfo;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    profileBody(userData),
                  ],
                ),
              ),
            );
          }
        }
        return Container();
      },
    );
  }

  Widget header() {
    final headline3 = Theme.of(context).textTheme.headline3;
    final headline5 = Theme.of(context).textTheme.headline5;
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Responsive.isDesktop(context)
            ? Text('Mon Profil', style: headline3)
            : Text('Mon Profil', style: headline5),
      ),
    );
  }


  Widget profileBody(UserModel userModel) {
    final headline5 = Theme.of(context).textTheme.headline5;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    return Responsive.isDesktop(context)
      ? ListBody(
          children: [
            // SizedBox(
            //   height: 100,
            //   width: 100,
            //   child: CachedNetworkImage(
            //     imageUrl: userData.logo!,
            //     placeholder: (context, url) => const CircularProgressIndicator(),
            //     errorWidget: (context, url, error) => const Icon(Icons.error),
            //   ),
            // ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('Nom',
                    style: GoogleFonts.poppins(textStyle: headline5)),
                trailing: Text(userModel.nom,
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.poppins(
                        textStyle: headline5, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('Post-Nom',
                    style: GoogleFonts.poppins(textStyle: headline5)),
                trailing: Text(userModel.postNom,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: headline5, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('Prénom',
                    style: GoogleFonts.poppins(textStyle: headline5)),
                trailing: Text(userModel.prenom,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: headline5, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: Text('Email',
                    style: GoogleFonts.poppins(textStyle: headline5)),
                trailing: Text(userModel.email,
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.poppins(
                        textStyle: headline5, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: Text('Téléphone',
                    style: GoogleFonts.poppins(textStyle: headline5)),
                trailing: Text(userModel.telephone,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: headline5, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.place),
                title: Text('Nationalité',
                    style: GoogleFonts.poppins(textStyle: headline5)),
                trailing: Text(userModel.nationalite,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: headline5, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_city_rounded),
                title: Text('Adresse',
                    style: GoogleFonts.poppins(textStyle: headline5)),
                trailing: Text(userModel.adresse,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: headline5, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.play_arrow_rounded),
                title: Text('Accréditation',
                    style: GoogleFonts.poppins(textStyle: headline5)),
                trailing: Text(userModel.role,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: headline5, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time_filled_sharp),
                title: Text('Date de création',
                    style: GoogleFonts.poppins(textStyle: headline5)),
                trailing: Text(
                    DateFormat("dd.MM.yy HH:mm").format(userModel.createdAt),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: headline5, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CachedNetworkImage(
            //   imageUrl: userModel.logo!,
            //   placeholder: (context, url) => const CircularProgressIndicator(),
            //   errorWidget: (context, url, error) => const Icon(Icons.error),
            // ),
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nom', style: bodyText2),
                      Text(userModel.nom,
                          overflow: TextOverflow.clip, style: bodyText1),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Post-Nom', style: bodyText2),
                      Text(userModel.postNom,
                          overflow: TextOverflow.clip, style: bodyText1),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
                height: 16.0,
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prénom', style: bodyText2),
                        Text(userModel.prenom,
                            overflow: TextOverflow.clip, style: bodyText1),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email', style: bodyText2),
                      Text(userModel.email,
                          overflow: TextOverflow.clip, style: bodyText1),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Téléphone', style: bodyText2),
                      Text(userModel.telephone,
                          overflow: TextOverflow.clip, style: bodyText1),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nationalité', style: bodyText2),
                      Text(userModel.nationalite,
                          overflow: TextOverflow.clip, style: bodyText1),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Adresse', style: bodyText2),
                      Text(userModel.adresse,
                          overflow: TextOverflow.clip, style: bodyText1),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date de création', style: bodyText2),
                      Text(
                          DateFormat("dd.MM.yy HH:mm")
                              .format(userModel.createdAt),
                          overflow: TextOverflow.clip,
                          style: bodyText1),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        );
  }
}
