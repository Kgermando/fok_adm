// import 'package:flutter/material.dart';
// import 'package:fokad_admin/src/api/auth/auth_api.dart';
// import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
// import 'package:fokad_admin/src/constants/app_theme.dart';
// import 'package:fokad_admin/src/constants/responsive.dart';
// import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
// import 'package:fokad_admin/src/models/users/user_model.dart';
// import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
// import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
// import 'package:fokad_admin/src/utils/loading.dart';
// import 'package:fokad_admin/src/utils/type_operation.dart';
// import 'package:fokad_admin/src/widgets/print_widget.dart';
// import 'package:fokad_admin/src/widgets/title_widget.dart';
// import 'package:intl/intl.dart';

// class UpdatePaiementSalaire extends StatefulWidget {
//   const UpdatePaiementSalaire({Key? key}) : super(key: key);

//   @override
//   State<UpdatePaiementSalaire> createState() => _UpdatePaiementSalaireState();
// }

// class _UpdatePaiementSalaireState extends State<UpdatePaiementSalaire> {
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//   final ScrollController _controllerScroll = ScrollController();
//   final _formKey = GlobalKey<FormState>();
//   bool isLoading = false;

//   final List<String> typeOperation = TypeOperation().modePayemnt;

//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }

//   UserModel? user;
//   Future<void> getData() async {
//     UserModel userModel = await AuthApi().getUserId();
//     if (!mounted) return;
//     setState(() {
//       user = userModel;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const DrawerMenu(),
//       body: SafeArea(
//           child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (Responsive.isDesktop(context))
//             const Expanded(
//               child: DrawerMenu(),
//             ),
//           Expanded(
//             flex: 5,
//             child: Padding(
//               padding: const EdgeInsets.all(p10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: p20,
//                         child: IconButton(
//                             onPressed: () => Navigator.pop(context),
//                             icon: const Icon(Icons.arrow_back)),
//                       ),
//                       const SizedBox(width: p10),
//                       Expanded(
//                           child: CustomAppbar(
//                               title: 'Feuille de paie',
//                               controllerMenu: () =>
//                                   _key.currentState!.openDrawer())),
//                     ],
//                   ),
//                   Expanded(
//                       child: Scrollbar(
//                     controller: _controllerScroll,
//                     child: updatePaiementSalaireWidget(),
//                   ))
//                 ],
//               ),
//             ),
//           ),
//         ],
//       )),
//     );
//   }

//   Widget updatePaiementSalaireWidget() {
//     return Form(
//         key: _formKey,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Card(
//               elevation: 10,
//               child: Container(
//                 margin: const EdgeInsets.all(p16),
//                 padding: const EdgeInsets.all(p16),
//                 width: (Responsive.isDesktop(context))
//                     ? MediaQuery.of(context).size.width / 2
//                     : MediaQuery.of(context).size.width / 1.5,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(p10),
//                   border: Border.all(
//                     color: Colors.blueGrey.shade700,
//                     width: 2.0,
//                   ),
//                 ),
//                 child: ListView(
//                   controller: _controllerScroll,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TitleWidget(
//                             title:
//                                 'Feuille de paie du ${DateFormat("MM-yy").format(createdAt)}'),
//                         Row(
//                           children: [PrintWidget(onPressed: () {})],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     agentWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     salaireWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     heureSupplementaireWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     supplementTravailSamediDimancheJoursFerieWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     primeWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     diversWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     congesPayeWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     maladieAccidentWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     totalDuBrutWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     deductionWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     allocationsFamilialesWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     netAPayerWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     montantPrisConsiderationCalculCotisationsINSSWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     modePaiementWidget(),
//                     const SizedBox(
//                       height: p20,
//                     ),
//                     (isLoading) ? loading() : observationWidget(),
//                     const SizedBox(
//                       height: p20,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }

//   Color getColor(Set<MaterialState> states) {
//     const Set<MaterialState> interactiveStates = <MaterialState>{
//       MaterialState.pressed,
//       MaterialState.hovered,
//       MaterialState.focused,
//     };
//     if (states.any(interactiveStates.contains)) {
//       return Colors.orange;
//     }
//     return Colors.green;
//   }

//   Widget observationWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         border: Border(
//             // bottom: BorderSide(width: 1.0),
//             ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Observation',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//             flex: 3,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Checkbox(
//                     checkColor: Colors.white,
//                     fillColor: MaterialStateProperty.resolveWith(getColor),
//                     value: observation,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         isLoading = true;
//                         observation = value!;
//                         submit();
//                       });
//                     })
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget agentWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Matricule',
//                 style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               width: p10,
//             ),
//             Expanded(
//                 child: SelectableText(
//               matricule.toString(),
//               style: bodyMedium,
//             ))
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Numéro de securité sociale',
//                 style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               width: p10,
//             ),
//             Expanded(
//                 child: SelectableText(
//               numeroSecuriteSociale.toString(),
//               style: bodyMedium,
//             ))
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Nom',
//                 style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               width: p10,
//             ),
//             Expanded(
//                 child: SelectableText(
//               nom.toString(),
//               style: bodyMedium,
//             ))
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Prénom',
//                 style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               width: p10,
//             ),
//             Expanded(
//                 child: SelectableText(
//               prenom.toString(),
//               style: bodyMedium,
//             ))
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Téléphone',
//                 style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               width: p10,
//             ),
//             Expanded(
//                 child: SelectableText(
//               telephone.toString(),
//               style: bodyMedium,
//             ))
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Adresse',
//                 style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               width: p10,
//             ),
//             Expanded(
//                 child: SelectableText(
//               adresse.toString(),
//               style: bodyMedium,
//             ))
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'departement',
//                 style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               width: p10,
//             ),
//             Expanded(
//                 child: SelectableText(
//               departement.toString(),
//               style: bodyMedium,
//             ))
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Services d\'affectation',
//                 style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               width: p10,
//             ),
//             Expanded(
//                 child: SelectableText(
//               servicesAffectation.toString(),
//               style: bodyMedium,
//             ))
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Salaire',
//                 style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               width: p10,
//             ),
//             Expanded(
//                 child: SelectableText(
//               '$salaireField USD',
//               style: bodyMedium.copyWith(color: Colors.blueGrey),
//             ))
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Approbation',
//                 style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               width: p10,
//             ),
//             Expanded(
//                 child: (approbation)
//                     ? SelectableText(
//                         'Approuvé',
//                         style:
//                             bodyMedium.copyWith(color: Colors.green.shade700),
//                       )
//                     : SelectableText(
//                         'Non approuvé',
//                         style: bodyMedium.copyWith(color: Colors.red.shade700),
//                       ))
//           ],
//         ),
//       ],
//     );
//   }

//   Widget modePaiementWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Mode de paiement',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(flex: 3, child: modePaiementFieldWidget()),
//         ],
//       ),
//     );
//   }

//   Widget modePaiementFieldWidget() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: p10, left: p5),
//       child: DropdownButtonFormField<String>(
//         decoration: InputDecoration(
//           labelText: 'Mode de paiement',
//           labelStyle: const TextStyle(),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
//         ),
//         value: modePaiement,
//         isExpanded: true,
//         items: typeOperation.map((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value),
//           );
//         }).toList(),
//         onChanged: (value) {
//           setState(() {
//             modePaiement = value!;
//           });
//         },
//       ),
//     );
//   }

//   Widget salaireWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Salaires',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//             flex: 3,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                     flex: 3,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Durée',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           tauxJourHeureMoisSalaire.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text('%', style: bodySmall),
//                         SelectableText(
//                           joursHeuresPayeA100PourecentSalaire.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text('Total dû', style: bodySmall),
//                         SelectableText(
//                           totalDuSalaire.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     ))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget heureSupplementaireWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           // top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Heure supplementaire',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//             flex: 3,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                     flex: 3,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Nombre Heure',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           nombreHeureSupplementaires.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Taux',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           tauxHeureSupplementaires.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Total dû',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           totalDuHeureSupplementaires.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     ))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget supplementTravailSamediDimancheJoursFerieWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           // top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text(
//                   'Supplement dû travail du samedi, du dimanche et jours ferié',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//               flex: 3,
//               child: Column(
//                 children: [
//                   Text(
//                     'Supplement dû travail',
//                     style: bodySmall,
//                   ),
//                   SelectableText(
//                     supplementTravailSamediDimancheJoursFerie.toString(),
//                     style: bodyMedium,
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }

//   Widget primeWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           // top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Prime',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//               flex: 3,
//               child: Column(
//                 children: [
//                   Text(
//                     'Prime',
//                     style: bodySmall,
//                   ),
//                   SelectableText(
//                     prime.toString(),
//                     style: bodyMedium,
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }

//   Widget diversWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           // top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Divers',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//               flex: 3,
//               child: Column(
//                 children: [
//                   Text(
//                     'Divers',
//                     style: bodySmall,
//                   ),
//                   SelectableText(
//                     divers.toString(),
//                     style: bodyMedium,
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }

//   Widget congesPayeWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           // top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Congés Payé',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//             flex: 3,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                     flex: 3,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Jours',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           joursCongesPaye.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Taux',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           tauxCongesPaye.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Total dû',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           totalDuHeureSupplementaires.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     ))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget maladieAccidentWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           // top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Maladie ou Accident',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//             flex: 3,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                     flex: 3,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Jours Payé',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           jourPayeMaladieAccident.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Taux',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           tauxJournalierMaladieAccident.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Total dû',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           totalDuMaladieAccident.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     ))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget totalDuBrutWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           // top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Total brut dû',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//               flex: 3,
//               child: Column(
//                 children: [
//                   Text(
//                     'Total',
//                     style: bodySmall,
//                   ),
//                   SelectableText(
//                     totalDuBrut.toString(),
//                     style: bodyMedium,
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }

//   Widget deductionWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           // top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Deduction',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//             flex: 3,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Pension',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           pensionDeduction.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Indemnité compensatrices',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           indemniteCompensatricesDeduction.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Avances',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           avancesDeduction.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Divers',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           diversDeduction.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Retenues fiscales',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           retenuesFiscalesDeduction.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     ))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget allocationsFamilialesWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           // top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Allocations familiales',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//             flex: 3,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Nombre des enfants béneficaire',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           nombreEnfantBeneficaireAllocationsFamiliales
//                               .toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Nombre des Jours',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           nombreDeJoursAllocationsFamiliales.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Taux journalier',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           tauxJoursAllocationsFamiliales.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Total à payer',
//                           style: bodySmall,
//                         ),
//                         SelectableText(
//                           totalAPayerAllocationsFamiliales.toString(),
//                           style: bodyMedium,
//                         ),
//                       ],
//                     ))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget netAPayerWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           // top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text('Net à payer',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//               flex: 3,
//               child: Column(
//                 children: [
//                   Text(
//                     'Total à payer',
//                     style: bodySmall,
//                   ),
//                   SelectableText(
//                     netAPayer.toString(),
//                     style: bodyMedium,
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }

//   Widget montantPrisConsiderationCalculCotisationsINSSWidget() {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;
//     final bodySmall = Theme.of(context).textTheme.bodySmall;
//     return Container(
//       padding: const EdgeInsets.only(top: p16, bottom: p16),
//       decoration: const BoxDecoration(
//         border: Border(
//           // top: BorderSide(width: 1.0),
//           bottom: BorderSide(width: 1.0),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 3,
//               child: Text(
//                   'Montant pris en consideration pour le calcul des cotisations INSS',
//                   style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//               flex: 3,
//               child: Column(
//                 children: [
//                   Text(
//                     'Montant pris pour la Cotisations INSS',
//                     style: bodySmall,
//                   ),
//                   SelectableText(
//                     montantPrisConsiderationCalculCotisationsINSS.toString(),
//                     style: bodyMedium,
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }

//   Future<void> submit() async {
//     final paiementSalaireModel = PaiementSalaireModel(
//       id: widget.id,
//       nom: nom.toString(),
//       postNom: postNom.toString(),
//       prenom: prenom.toString(),
//       telephone: telephone.toString(),
//       adresse: adresse.toString(),
//       ligneBudgtaire: ligneBudgtaire.toString(),
//       resources: resources.toString(),
//       departement: departement.toString(),
//       numeroSecuriteSociale: numeroSecuriteSociale.toString(),
//       matricule: matricule.toString(),
//       servicesAffectation: servicesAffectation.toString(),
//       salaire: salaireField.toString(),
//       observation: observation, // Finance
//       modePaiement: modePaiement.toString(),
//       createdAt: DateTime.now(),
//       tauxJourHeureMoisSalaire: tauxJourHeureMoisSalaire.toString(),
//       joursHeuresPayeA100PourecentSalaire:
//           joursHeuresPayeA100PourecentSalaire.toString(),
//       totalDuSalaire: totalDuSalaire.toString(),
//       nombreHeureSupplementaires: nombreHeureSupplementaires.toString(),
//       tauxHeureSupplementaires: tauxHeureSupplementaires.toString(),
//       totalDuHeureSupplementaires: totalDuHeureSupplementaires.toString(),
//       supplementTravailSamediDimancheJoursFerie:
//           supplementTravailSamediDimancheJoursFerie.toString(),
//       prime: prime.toString(),
//       divers: divers.toString(),
//       joursCongesPaye: joursCongesPaye.toString(),
//       tauxCongesPaye: tauxCongesPaye.toString(),
//       totalDuCongePaye: totalDuCongePaye.toString(),
//       jourPayeMaladieAccident: jourPayeMaladieAccident.toString(),
//       tauxJournalierMaladieAccident: tauxJournalierMaladieAccident.toString(),
//       totalDuMaladieAccident: totalDuMaladieAccident.toString(),
//       pensionDeduction: pensionDeduction.toString(),
//       indemniteCompensatricesDeduction:
//           indemniteCompensatricesDeduction.toString(),
//       avancesDeduction: avancesDeduction.toString(),
//       diversDeduction: diversDeduction.toString(),
//       retenuesFiscalesDeduction: retenuesFiscalesDeduction.toString(),
//       nombreEnfantBeneficaireAllocationsFamiliales:
//           nombreEnfantBeneficaireAllocationsFamiliales.toString(),
//       nombreDeJoursAllocationsFamiliales:
//           nombreDeJoursAllocationsFamiliales.toString(),
//       tauxJoursAllocationsFamiliales: tauxJoursAllocationsFamiliales.toString(),
//       totalAPayerAllocationsFamiliales:
//           totalAPayerAllocationsFamiliales.toString(),
//       netAPayer: netAPayer.toString(),
//       montantPrisConsiderationCalculCotisationsINSS:
//           montantPrisConsiderationCalculCotisationsINSS.toString(),
//       totalDuBrut: totalDuBrut.toString(),
//       signature: signature.toString(),
//     );
//     await PaiementSalaireApi().updateData(widget.id, paiementSalaireModel);
//     Navigator.of(context).pop();
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: const Text("Enregistrer avec succès!"),
//       backgroundColor: Colors.green[700],
//     ));
//   }
// }
