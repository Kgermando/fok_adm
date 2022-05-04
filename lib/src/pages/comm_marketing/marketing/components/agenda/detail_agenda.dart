import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/agenda_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/agenda_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/update_agenda.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class DetailAgenda extends StatefulWidget {
  const DetailAgenda({ Key? key, required this.agendaModel, required this.color }) : super(key: key);
  final AgendaModel agendaModel;
  final Color color;

  @override
  State<DetailAgenda> createState() => _DetailAgendaState();
}

class _DetailAgendaState extends State<DetailAgenda> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

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
                                  onPressed: () =>
                                      Routemaster.of(context).pop(),
                                  icon: const Icon(Icons.arrow_back)),
                            ),
                            const SizedBox(width: p10),
                            Expanded(
                              child: CustomAppbar(
                                  title: widget.agendaModel.title,
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer()),
                            ),
                          ],
                        ),
                        Expanded(
                            child: Scrollbar(
                                controller: _controllerScroll,
                                isAlwaysShown: true,
                                child: pageDetail()))
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

   Widget pageDetail() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        color: widget.color.withOpacity(.8),
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
                  TitleWidget(title: widget.agendaModel.title),
                  Column(
                    children: [
                      Row(
                        children: [
                          editButton(),
                          deleteButton(),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(widget.agendaModel.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget() {
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
              const Icon(Icons.date_range),
              const SizedBox(height: p20),
              SelectableText(
                "Rappel le ${DateFormat("dd-MM-yyyy à HH:mm")
                    .format(widget.agendaModel.dateRappel)}",
                style: bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: p20),
          SelectableText(
            widget.agendaModel.description,
            style: bodyLarge,
          )
        ],
      ),
    );
  }

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      tooltip: "Modifiaction",
      onPressed: () async {
        if (isLoading) return;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              UpdateAgenda(agendaModel: widget.agendaModel),
        ));
      });

  Widget deleteButton() {
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
                await AgendaApi().deleteData(widget.agendaModel.id!);
                Routemaster.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "${widget.agendaModel.title} vient d'être supprimé!"),
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