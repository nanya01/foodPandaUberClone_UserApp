import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodpanda_users_app/models/sellers.dart';
import 'package:foodpanda_users_app/widgets/menus_design.dart';
import 'package:provider/provider.dart';

import '../assistant_methods/cart_item_counter.dart';
import '../models/menus.dart';
import '../widgets/my_drawer.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget_header.dart';
import 'cart_screen.dart';

class MenusScreen extends StatefulWidget {
  final Sellers model;
  const MenusScreen({required this.model, Key? key}) : super(key: key);

  @override
  _MenusScreenState createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                                  sellerUID: widget.model.sellerUID,
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
        ),
        drawer: const MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(title: "My Menus"),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("sellers")
                    .doc(widget.model.sellerUID)
                    .collection("menus")
                    .orderBy("publishedDate", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: circularProgress(),
                          ),
                        )
                      : SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 1,
                          staggeredTileBuilder: (c) =>
                              const StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                            Menus model = Menus.fromJson(
                                snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>);

                            return MenusDesignWidget(
                              context: context,
                              model: model,
                            );
                          },
                          itemCount: snapshot.data!.docs.length);
                })
          ],
        ));
  }
}
