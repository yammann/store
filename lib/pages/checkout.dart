
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/provider/cart.dart';
import 'package:store/constens/cartproducts.dart';
import 'package:store/constens/colors.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  
  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  @override
  Widget build(BuildContext context) {
    final product=Provider.of<Cart>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(height:600,
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: product.CartProduct.length,
            itemBuilder: (context, index) {
            return CartProducts(Index: index);
          },),
        )
      ),
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "CheckOut",
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(252, 252, 252, 0.5),
                shape: BoxShape.circle,
              ),
              child: Text(
               product.CartProduct.length.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.add_shopping_cart))
          ]),
          Center(
            child: Text(
              "\$ ${product.TotalPrice}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
    );
  }
}
