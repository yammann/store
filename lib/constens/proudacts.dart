import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/Data/item.dart';
import 'package:store/provider/cart.dart';
import 'package:store/constens/colors.dart';
import 'package:store/pages/detailes.dart';

class Proudacts extends StatelessWidget {
  final String img;
  final double price;
  final int index;
  const Proudacts(
      {super.key, required this.price, required this.img, required this.index});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Detailes(product: allProducts[index])));
      },
      child: GridTile(
        footer: GridTileBar(
            backgroundColor: const Color.fromRGBO(64, 146, 61, 0.3),
            leading: Container(
              padding: const EdgeInsets.all(17),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Text("$price"),
            ),
            title: const Text(""),
            trailing: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Consumer<Cart>(
                builder: (context, cart, child) {
                  return IconButton(
                      onPressed: () {
                        cart.add(allProducts[index]);
                      },
                      icon: const Icon(
                        Icons.add,
                        color: mainColor,
                      ));
                },
              ),
            )),
        child: Image(
          image: AssetImage("assets/$img"),
        ),
      ),
    );
  }
}
