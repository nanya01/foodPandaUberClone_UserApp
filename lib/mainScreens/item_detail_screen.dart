import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodpanda_users_app/widgets/app_bar.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import '../assistant_methods/assistant_methods.dart';
import '../models/items.dart';

class ItemDetailScreen extends StatefulWidget {
  final Items model;
  const ItemDetailScreen({required this.model, Key? key}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    separateItemIDs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        sellerUID: widget.model.sellerUID,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.model.thumbnailUrl.toString()),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: NumberInputPrefabbed.roundedButtons(
                controller: counterTextEditingController,
                incDecBgColor: Colors.amber,
                min: 1,
                max: 9,
                initialValue: 1,
                buttonArrangement: ButtonArrangement.incRightDecLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model.title.toString(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "N " + widget.model.price.toString(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  int itemCounter =
                      int.parse(counterTextEditingController.text);
                  List<String> separateItemIDsList = separateItemIDs();
                  separateItemIDsList.contains(widget.model.itemID)
                      ? Fluttertoast.showToast(
                          msg: "Item is already added in cart")
                      // add to cart
                      : addItemToCart(
                          widget.model.itemID ?? "", context, itemCounter);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.cyan, Colors.amber],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp)),
                  child: const Center(
                    child: Text("Add to Cart",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
