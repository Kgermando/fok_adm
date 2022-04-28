import 'package:flutter/material.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';

class DetailCart extends StatefulWidget {
  const DetailCart({Key? key, required this.cart}) : super(key: key);
  final CartModel cart;

  @override
  State<DetailCart> createState() => _DetailCartState();
}

class _DetailCartState extends State<DetailCart> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
