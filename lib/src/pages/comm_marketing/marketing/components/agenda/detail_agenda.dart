import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/agenda_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/agenda_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/update_agenda.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailAgenda extends StatefulWidget {
  const DetailAgenda({Key? key}) : super(key: key);

  @override
  State<DetailAgenda> createState() => _DetailAgendaState();
}

class _DetailAgendaState extends State<DetailAgenda> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;
  bool isLoadingDelete = false;

  @override
  Widget build(BuildContext context) {
    AgendaColor agendaColor =
        ModalRoute.of(context)!.settings.arguments as AgendaColor;

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
                                  title: agendaColor.agendaModel.title,
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer()),
                            ),
                          ],
                        ),
                        Expanded(
                            child: Scrollbar(
                                controller: _controllerScroll,
                                child: pageDetail(agendaColor)))
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(AgendaColor agendaColor) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        color: agendaColor.color.withOpacity(.8),
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
                  TitleWidget(title: agendaColor.agendaModel.title),
                  Column(
                    children: [
                      Row(
                        children: [
                          editButton(agendaColor),
                          deleteButton(agendaColor),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm")
                              .format(agendaColor.agendaModel.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(agendaColor),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(AgendaColor agendaColor) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: p10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.date_range, color: agendaColor.color),
              const SizedBox(height: p20),
              SelectableText(
                "Rappel le ${DateFormat("dd-MM-yyyy à HH:mm").format(agendaColor.agendaModel.dateRappel)}",
                style: bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: p20),
          SelectableText(
            agendaColor.agendaModel.description,
            style: bodyLarge,
          )
        ],
      ),
    );
  }

  Widget editButton(AgendaColor agendaColor) => IconButton(
      icon: const Icon(Icons.edit_outlined),
      tooltip: "Modifiaction",
      onPressed: () async {
        if (isLoading) return;
        Navigator.of(context).pushNamed(
            ComMarketingRoutes.comMarketingAgendaUpdate,
            arguments: AgendaColor(
                agendaModel: agendaColor.agendaModel,
                color: agendaColor.color));
      });

  Widget deleteButton(AgendaColor agendaColor) {
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: "Suppression",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de supprimé ceci?'),
          content:
              const Text('Cette action permet de supprimer définitivement.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoadingDelete = true;
                });
                await AgendaApi().deleteData(agendaColor.agendaModel.id!).then((value) {
                  setState(() {
                    isLoadingDelete = false;
                  });
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "${agendaColor.agendaModel.title} vient d'être supprimé!"),
                  backgroundColor: Colors.red[700],
                ));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
