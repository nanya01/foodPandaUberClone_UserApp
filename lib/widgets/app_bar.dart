import 'package:flutter/material.dart';
import 'package:foodpanda_users_app/mainScreens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../assistant_methods/cart_item_counter.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final String? sellerUID;
  const MyAppBar({this.bottom, this.sellerUID, Key? key}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        "IFood",
        style: TextStyle(fontSize: 45, fontFamily: "Lobster"),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyan, Colors.amber],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => CartScreen(
                              sellerUID: widget.sellerUID,
                            )));
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.cyan,
              ),
            ),
            Positioned(
              child: Stack(
                children: [
                  const Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green,
                  ),
                  Positioned(
                      top: 3,
                      right: 4,
                      child: Consumer<CartItemCounter>(
                          builder: (context, counter, c) {
                        return Text(
                          '${Provider.of<CartItemCounter>(context).count}',
                          //counter.count.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        );
                      }))
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
