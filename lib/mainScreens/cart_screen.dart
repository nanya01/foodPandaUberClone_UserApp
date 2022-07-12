import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_users_app/assistant_methods/assistant_methods.dart';
import 'package:foodpanda_users_app/assistant_methods/cart_item_counter.dart';
import 'package:foodpanda_users_app/mainScreens/address_screen.dart';
import 'package:foodpanda_users_app/widgets/app_bar.dart';
import 'package:foodpanda_users_app/widgets/cart_item_design.dart';
import 'package:foodpanda_users_app/widgets/progress_bar.dart';
import 'package:provider/provider.dart';

import '../assistant_methods/total_amont.dart';
import '../models/items.dart';
import '../widgets/text_widget_header.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;

  const CartScreen({this.sellerUID, Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    separateItemQuantityList = separateItemQuantities();
    Provider.of<TotalAmount>(context, listen: false)
        .displayTotalAmount(totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          sellerUID: widget.sellerUID,
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 10,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                heroTag: 'clearCart',
                onPressed: () {
                  clearCart(context);
                },
                label: const Text("Clear Cart", style: TextStyle(fontSize: 16)),
                backgroundColor: Colors.cyan,
                icon: const Icon(Icons.clear_all),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                heroTag: 'checkout',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressScreen(
                              totalAmount: totalAmount.toDouble(),
                              sellerUID: widget.sellerUID)));
                },
                label: const Text(
                  "Checkout",
                  style: TextStyle(fontSize: 16),
                ),
                backgroundColor: Colors.cyan,
                icon: const Icon(Icons.navigate_next),
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            // overall total amount
            SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(title: "My CartList"),
            ),

            SliverToBoxAdapter(
              child: Consumer2<TotalAmount, CartItemCounter>(
                  builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                          "Total Price: ${amountProvider.totalAmount}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                );
              }),
            ),
            // display cart items with quantity number
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("items")
                    .where("itemID", whereIn: separateItemIDs())
                    .orderBy("publishedDate", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: circularProgress(),
                          ),
                        )
                      : snapshot.data!.docs.isEmpty
                          ? Container()
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                              Items model = Items.fromJson(
                                  snapshot.data!.docs[index].data()!
                                      as Map<String, dynamic>);

                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = totalAmount +
                                    (model.price! *
                                        separateItemQuantityList![index]);
                              } else {
                                totalAmount += (model.price! *
                                    separateItemQuantityList![index]);
                              }

                              if (snapshot.data!.docs.length - 1 == index) {
                                WidgetsBinding.instance!
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .displayTotalAmount(
                                          totalAmount.toDouble());
                                });
                              }
                              return CartItemDesign(
                                model: model,
                                context: context,
                                quantityNumber:
                                    separateItemQuantityList![index],
                              );
                            },
                                  childCount: snapshot.hasData
                                      ? snapshot.data!.docs.length
                                      : 0));
                })
          ],
        ));
  }
}
