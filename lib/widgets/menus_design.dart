import 'package:flutter/material.dart';
import 'package:foodpanda_users_app/mainScreens/items_screen.dart';

import '../models/menus.dart';

class MenusDesignWidget extends StatefulWidget {
  final Menus? model;
  final BuildContext? context;

  const MenusDesignWidget({this.model, this.context, Key? key})
      : super(key: key);

  @override
  _MenusDesignWidgetState createState() => _MenusDesignWidgetState();
}

class _MenusDesignWidgetState extends State<MenusDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => ItemsScreen(model: widget.model!)));
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
                widget.model!.menuTitle!,
                style: const TextStyle(
                    color: Colors.cyan, fontSize: 20, fontFamily: "Train"),
              ),
              Text(
                widget.model!.menuInfo!,
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
