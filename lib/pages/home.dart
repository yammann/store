import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/Data/getprofildata.dart';
import 'package:store/Data/item.dart';
import 'package:store/pages/profilepage.dart';
import 'package:store/provider/cart.dart';
import 'package:store/constens/colors.dart';
import 'package:store/constens/proudacts.dart';
import 'package:store/pages/checkout.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: allProducts.length,
        itemBuilder: (context, index) => Proudacts(
            img: allProducts[index].img,
            price: allProducts[index].price,
            index: index),
      ),
      drawer: Drawer(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Column(children: [
             const GetProfileData(),
              ListTile( 
                onTap: () {},
                title: const Text("Home"),
                leading: const Icon(Icons.home),
              ),
              ListTile(
                onTap: () {},
                title: const Text("My products"),
                leading: const Icon(Icons.add_shopping_cart_sharp),
              ),
              ListTile(
                onTap: () {},
                title: const Text("About"),
                leading: const Icon(Icons.help_center),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilPage(),
                      ));
                },
                title: const Text("Profile Page"),
                leading: const Icon(Icons.person),
              ),
              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
                title: const Text("Log out"),
                leading: const Icon(Icons.logout),
              )
            ]),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: const Text("Developed by yaman@2023"),
            ),
          ])),
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "Home",
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Stack(children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(252, 252, 252, 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    cart.CartProduct.length.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckOut(),
                          ));
                    },
                    icon: const Icon(Icons.add_shopping_cart))
              ]);
            },
          ),
          Center(
            child: Consumer<Cart>(
              builder: (context, cart, child) {
                return Text(
                  "\$ ${cart.TotalPrice}",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 8,
          )
        ],
        // leading: IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.list,
        //       size: 45,
        //     )),
      ),
    );
  }
}
