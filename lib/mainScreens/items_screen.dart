import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodpanda_users_app/models/items.dart';
import 'package:foodpanda_users_app/widgets/items_design.dart';

import '../models/menus.dart';
import '../widgets/app_bar.dart';
import '../widgets/my_drawer.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget_header.dart';

class ItemsScreen extends StatefulWidget {
  final Menus model;
  const ItemsScreen({required this.model, Key? key}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          sellerUID: widget.model.sellerUID,
        ),
        drawer: const MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(
                  title: "Items of ${widget.model.menuTitle}'s Menu"),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("sellers")
                    .doc(widget.model.sellerUID)
                    .collection("menus")
                    .doc(widget.model.menuID)
                    .collection("items")
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
                            Items model = Items.fromJson(
                                snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>);

                            return ItemsDesignWidget(
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
