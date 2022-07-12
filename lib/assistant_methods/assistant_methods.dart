import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodpanda_users_app/assistant_methods/cart_item_counter.dart';
import 'package:foodpanda_users_app/global/global.dart';
import 'package:foodpanda_users_app/splashScreen/splash_screen.dart';
import 'package:provider/provider.dart';

separateItemIDs() {
  List<String> separateItemIDList = [];
  List<String> defaultItemList = [];
  int i = 1;
  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    var pos = item.lastIndexOf(":");

    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\n This is ItemID now = " + getItemId);

    separateItemIDList.add(getItemId);
  }
  print("\n This is Item list now: $separateItemIDList");
  return separateItemIDList;
}

separateItemQuantities() {
  List<int> separateItemQuantityList = [];
  List<String> defaultItemList = [];
  int i = 1;
  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quantityNumber = int.parse(listItemCharacters[1].toString());

    print("\n This is Quantity Number = " + quantityNumber.toString());

    separateItemQuantityList.add(quantityNumber);
  }
  print("\n This is Quantity list now: $separateItemQuantityList");
  return separateItemQuantityList;
}

separateOrderItemQuantities(orderIDs) {
  List<String> separateItemQuantityList = [];
  List<String> defaultItemList = [];
  int i = 1;
  defaultItemList = List<String>.from(orderIDs);

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quantityNumber = int.parse(listItemCharacters[1].toString());

    print("\n This is Quantity Number = " + quantityNumber.toString());

    separateItemQuantityList.add(quantityNumber.toString());
  }
  print("\n This is Quantity list now: $separateItemQuantityList");
  return separateItemQuantityList;
}

separateOrderItemIDs(orderIDs) {
  List<String> separateItemIDList = [];
  List<String> defaultItemList = [];
  int i = 1;
  defaultItemList = List<String>.from(orderIDs);

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    var pos = item.lastIndexOf(":");

    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\n This is ItemID now = " + getItemId);

    separateItemIDList.add(getItemId);
  }
  print("\n This is Item list now: $separateItemIDList");
  return separateItemIDList;
}

void addItemToCart(String foodItemId, BuildContext context, int itemCounter) {
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList?.add("$foodItemId: $itemCounter");

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userCart": tempList}).then((value) async {
    Fluttertoast.showToast(msg: "Items Added Successfully");
    await sharedPreferences!.setStringList("userCart", tempList!);
  });

  // update the badge
  Provider.of<CartItemCounter>(context, listen: false).cartListItemCounter;
}

clearCart(context) {
  sharedPreferences!.setStringList("userCart", ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userCart": emptyList}).then((value) {
    sharedPreferences!.setStringList("userCart", emptyList!);

    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MySplashScreen()));
    Fluttertoast.showToast(msg: "Cart has been cleared");
  });
}
