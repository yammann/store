// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/provider/cart.dart';

class CartProducts extends StatelessWidget {
  final int Index;
  const CartProducts({super.key, 
    required this.Index
  });

  @override
  Widget build(BuildContext context) {
    final Product =Provider.of<Cart>(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage("assets/${Product.CartProduct[Index].img}"),
      ),
      title: Column(
        children: [
          const Text(
            "Product Name",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(children: [
            Text(Product.CartProduct[Index].price.toString()),
            const Text("store name"),
          ],)
        ],
      ),
      trailing: IconButton(onPressed: (){
        Product.remove(Product.CartProduct[Index]);
      },icon: const Icon(Icons.remove),),
    );
  }
}
