import 'package:flutter/material.dart';
import 'package:foodpanda_users_app/mainScreens/item_detail_screen.dart';
import 'package:foodpanda_users_app/models/items.dart';

class ItemsDesignWidget extends StatefulWidget {
  final Items? model;
  final BuildContext? context;

  const ItemsDesignWidget({this.model, this.context, Key? key})
      : super(key: key);

  @override
  _ItemsDesignWidgetState createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetailScreen(model: widget.model!)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 285,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 210.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 1.0,
              ),
              Text(
                widget.model!.title!,
                style: const TextStyle(
                    color: Colors.cyan, fontSize: 20, fontFamily: "Train"),
              ),
              Text(
                widget.model!.shortInfo!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
