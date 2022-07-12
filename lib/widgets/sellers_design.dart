import 'package:flutter/material.dart';

import '../mainScreens/menus_screen.dart';
import '../models/sellers.dart';

class SellersDesignWidget extends StatefulWidget {
  final Sellers? model;
  final BuildContext? context;

  const SellersDesignWidget({this.model, this.context, Key? key})
      : super(key: key);

  @override
  _SellersDesignWidgetState createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => MenusScreen(model: widget.model!)));
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
                widget.model!.sellerAvatarUrl!,
                height: 210.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 1.0,
              ),
              Text(
                widget.model!.sellerName!,
                style: const TextStyle(
                    color: Colors.cyan, fontSize: 20, fontFamily: "Train"),
              ),
              Text(
                widget.model!.sellerEmail!,
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
