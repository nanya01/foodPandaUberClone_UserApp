import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_users_app/assistant_methods/address_changer.dart';
import 'package:provider/provider.dart';

import '../mainScreens/place_order_screen.dart';
import '../maps/maps.dart';
import '../models/address.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;

  const AddressDesign(
      {this.model,
      this.currentIndex,
      this.value,
      this.addressID,
      this.totalAmount,
      this.sellerUID,
      Key? key})
      : super(key: key);

  @override
  _AddressDesignState createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: Colors.cyan.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                    value: widget.value!,
                    groupValue: widget.currentIndex,
                    activeColor: Colors.amber,
                    onChanged: (val) {
                      Provider.of<AddressChanger>(context, listen: false)
                          .displayResult(val);
                    }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Text(
                              "Name: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(widget.model!.name.toString())
                          ]),
                          TableRow(children: [
                            const Text(
                              "phone Number: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.model!.phoneNumber.toString())
                          ]),
                          TableRow(children: [
                            const Text(
                              "Flat Number: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.model!.flatNumber.toString())
                          ]),
                          TableRow(children: [
                            const Text(
                              "City: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(widget.model!.city.toString())
                          ]),
                          TableRow(children: [
                            const Text(
                              "State: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(widget.model!.state.toString())
                          ]),
                          TableRow(children: [
                            const Text(
                              "Full Address:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(widget.model!.fullAddress.toString())
                          ])
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                MapsUtils.openMapWithPosition(
                    widget.model!.lat ?? 0, widget.model!.lng ?? 0);
              },
              child: const Text("Check on Maps"),
              style: ElevatedButton.styleFrom(primary: Colors.black54),
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => PlaceOrderScreen(
                                  addressID: widget.addressID,
                                  totalAmount: widget.totalAmount,
                                  sellerUID: widget.sellerUID)));
                    },
                    child: const Text("Proceed"),
                    style: ElevatedButton.styleFrom(primary: Colors.green))
                : Container()
          ],
        ),
      ),
    );
  }
}
