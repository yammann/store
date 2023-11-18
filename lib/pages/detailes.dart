import 'package:flutter/material.dart';
import 'package:store/Data/item.dart';
import 'package:store/constens/colors.dart';


// ignore: must_be_immutable
class Detailes extends StatefulWidget {
  Item product;
  Detailes({super.key, 
    required this.product
  });
  @override
  State<Detailes> createState() => _DetailesState();
}

class _DetailesState extends State<Detailes> {
  
  
  bool x=true;
  String y="Show more";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                width: double.infinity,
                height: 400,
                child: Image.asset("assets/${widget.product.img}",fit:BoxFit.cover,),
                ),
            Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "${widget.product.price}",
                  style: const TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding:const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(235, 91, 91, 1),
                            shape: BoxShape.rectangle,
                            ),
                        child: const Text("NEW"),
                      ),
                      const SizedBox(width: 5),
                      const Row(
                        children: [
                          Icon(Icons.star,size: 28,color: Color.fromRGBO(248, 203, 2, 1),),
                          Icon(Icons.star,size: 28,color: Color.fromRGBO(248, 203, 2, 1),),
                          Icon(Icons.star,size: 28,color: Color.fromRGBO(248, 203, 2, 1),),
                          Icon(Icons.star,size: 28,color: Color.fromRGBO(248, 203, 2, 1),),
                          Icon(Icons.star,size: 28,color: Color.fromRGBO(248, 203, 2, 1),),
                        ],
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(Icons.edit_location),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Flower shop"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15,bottom: 15),
              child: const SizedBox(width: double.infinity,child: Text("Detailes:",style: TextStyle(fontSize: 20),),),
            ),
            Column(
              children: [
                Text("Flooer uses only natural and sustainably sourced materials in their dried flower installations, making them a more eco-friendly choice than traditional fresh flower arrangements. Dried flowers require no water, pesticides, or other harmful chemicals, making them a much more sustainable option. With Flooer, you can enjoy beautiful floral arrangements without harming the environment.Flooer offers a wide range of dried flower installations that can be customised to fit any event or space. From weddings and private parties to commercial spaces and shop windows, Flooer has a solution to fit your needs. Dried flower installations are also highly versatile and can be used in a variety of ways, from wall hangings and centrepieces to flower crowns and bouquets ",
                style: const TextStyle(fontSize: 20),
              maxLines: x?3:null,
              overflow: TextOverflow.fade,),
                TextButton(onPressed: (){
                  setState(() {
                    if(x){
                      x=false;
                      y="Show less";
                    }
                    else{
                       x=true;
                      y="Show more";
                    }
                  });
                  
                }, child: Text(y))
              ],
            )
          ],
        ),
      ),
      
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "Detailes",
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
              child: const Text(
                "8",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.add_shopping_cart))
          ]),
          const Center(
            child: Text(
              "\$ 150",
              style: TextStyle(
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
