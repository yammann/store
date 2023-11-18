// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:store/Data/item.dart';

class Cart with ChangeNotifier{
  List CartProduct=[

  ];
  
  double TotalPrice=0;
  add(Item product){
    CartProduct.add(product);
    TotalPrice+=product.price.round();
    notifyListeners();
  }
  remove(Item Product){
    CartProduct.remove(Product);
    TotalPrice-=Product.price.round();
    notifyListeners();
  }
  
}