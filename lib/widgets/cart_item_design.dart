import 'package:flutter/material.dart';

import '../models/items.dart';

class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context;
  final int? quantityNumber;

  CartItemDesign({this.model, this.context, this.quantityNumber, Key? key})
      : super(key: key);

  @override
  _CartItemDesignState createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.network(
                widget.model!.thumbnailUrl ?? "",
                width: 140,
                height: 120,
              ),
              const SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.model!.title!,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 16, fontFamily: "Kiwi"),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Row(
                    children: [
                      const Text(
                        "x ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Acne"),
                      ),
                      Text(
                        '${widget.quantityNumber}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Acne"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Price: ",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "Acne"),
                      ),
                      Text(
                        "N${widget.model!.price}",
                        style: const TextStyle(
                            color: Colors.cyan,
                            fontSize: 16,
                            fontFamily: "Acne"),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
