import 'package:flutter/material.dart';

class AddCompteResultat extends StatefulWidget {
  const AddCompteResultat({ Key? key }) : super(key: key);

  @override
  State<AddCompteResultat> createState() => _AddCompteResultatState();
}

class _AddCompteResultatState extends State<AddCompteResultat> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerActifList = ScrollController();
  final ScrollController _controllerPassifList = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController titleBilanController = TextEditingController();
  List<String> comptesActifControllerList = [];
  List<String> comptesPassifControllerList = [];
  List<TextEditingController> montantActifControllerList = [];
  List<TextEditingController> montantPassifControllerList = [];
  bool statut = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}