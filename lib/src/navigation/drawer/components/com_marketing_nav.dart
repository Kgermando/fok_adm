import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class ComMarketing extends StatefulWidget {
  const ComMarketing({ Key? key, required this.pageCurrente }) : super(key: key);
  final String pageCurrente;

  @override
  State<ComMarketing> createState() => _ComMarketingState();
}

class _ComMarketingState extends State<ComMarketing> {
  bool isOpenComMarketing1 = false;
  bool isOpenComMarketing2 = false;

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    return ExpansionTile(
      leading: const Icon(Icons.fact_check, size: 30.0),
      title: AutoSizeText('Comm. & Marketing', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenComMarketing1 = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        DrawerWidget(
          selected: widget.pageCurrente == ComMarketingRoutes.comMarketingDashboard,
          icon: Icons.dashboard,
          sizeIcon: 20.0,
          title: 'Dashboard',
          style: bodyText1!,
          onTap: () {
            Routemaster.of(context).replace(
              ComMarketingRoutes.comMarketingDashboard,
            );
            // Routemaster.of(context).pop();
          }),
          DrawerWidget(
            selected:
                widget.pageCurrente == ComMarketingRoutes.comMarketingDD,
            icon: Icons.manage_accounts,
            sizeIcon: 20.0,
            title: 'Directeur de Département',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(
                ComMarketingRoutes.comMarketingDD,
              );
              // Routemaster.of(context).pop();
            }),
         ExpansionTile(
            leading: const Icon(Icons.visibility, size: 20.0),
            title: Text('Marketing', style: bodyText1),
            initiallyExpanded: false,
            onExpansionChanged: (val) {
              setState(() {
                isOpenComMarketing2 = !val;
              });
            },
            children: [
        
              DrawerWidget(
                selected:
                    widget.pageCurrente == ComMarketingRoutes.comMarketingAnnuaire,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Annuaire',
                style: bodyText2!,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingAnnuaire);
                  // Routemaster.of(context).pop();
                }),
              DrawerWidget(
                selected: widget.pageCurrente == ComMarketingRoutes.comMarketingAgenda,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Agenda',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingAgenda);
                  // Routemaster.of(context).pop();
                }
              ),
              DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingCampaign,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Campaigns',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingCampaign);
                  // Routemaster.of(context).pop();
                }),
            ],
          ),
        ExpansionTile(
          leading: const Icon(Icons.store, size: 20.0),
          title: Text('Commercial', style: bodyText1),
          initiallyExpanded: false,
          onExpansionChanged: (val) {
            setState(() {
              isOpenComMarketing2 = !val;
            });
          },
          children: [
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingProduitModel,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Produit modèle',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingProduitModel);
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingStockGlobal,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Stocks global',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingStockGlobal);
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingSuccursale,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Succursale',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingSuccursale);
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingAchat,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Achats',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingAchat);
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingBonLivraison,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Bon de livraison',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingBonLivraison);
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingRestitution,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Restitution du produit',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingRestitution);
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingFacture,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Factures',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingFacture);
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingCreance,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Factures créance',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingCreance);
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == ComMarketingRoutes.comMarketingVente,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Ventes',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingVente);
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingcart,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Panier',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingcart);
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingHistoryRavitaillement,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Historique de ravitaillement',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context).replace(
                      ComMarketingRoutes.comMarketingHistoryRavitaillement);
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingHistoryLivraison,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Historique de livraison',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(ComMarketingRoutes.comMarketingHistoryLivraison);
                  // Routemaster.of(context).pop();
                }),
          ],
        )
      ],
    );
  }
}