import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/items.dart';

class OrderCard extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? separateQuantitiesList;
  const OrderCard(
      {this.itemCount,
      this.data,
      this.orderID,
      this.separateQuantitiesList,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black12, Colors.white54],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: itemCount! * 125,
        child: ListView.builder(
            itemCount: itemCount,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Items model =
                  Items.fromJson(data![index].data() as Map<String, dynamic>);
              return placeOrderDesignWidget(
                  model, context, separateQuantitiesList![index]);
            }),
      ),
    );
  }
}

Widget placeOrderDesignWidget(
    Items model, BuildContext context, separateQuantitiesList) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.grey[200],
    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl!,
          width: 120,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(model.title!),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "N",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  model.price.toString(),
                  style: const TextStyle(color: Colors.blue, fontSize: 10.0),
                )
              ],
            ),
            Row(
              children: [
                const Text(
                  "x ",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                Expanded(
                    child: Text(
                  separateQuantitiesList,
                  style: const TextStyle(
                      color: Colors.black54, fontSize: 30, fontFamily: "Acme"),
                ))
              ],
            )
          ],
        ))
      ],
    ),
  );
}
