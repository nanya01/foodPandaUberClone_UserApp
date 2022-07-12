import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_users_app/mainScreens/save_address_screen.dart';
import 'package:foodpanda_users_app/widgets/address_design.dart';
import 'package:foodpanda_users_app/widgets/progress_bar.dart';
import 'package:foodpanda_users_app/widgets/simple_app_bar.dart';
import 'package:provider/provider.dart';

import '../assistant_methods/address_changer.dart';
import '../global/global.dart';
import '../models/address.dart';

class AddressScreen extends StatefulWidget {
  final double? totalAmount;
  final String? sellerUID;
  const AddressScreen({this.totalAmount, this.sellerUID, Key? key})
      : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SaveAddressScreen()));
        },
        label: const Text("Add New Address"),
        backgroundColor: Colors.cyan,
        icon: const Icon(Icons.add_location),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Select Address:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          Consumer<AddressChanger>(builder: (context, address, child) {
            return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("userAddress")
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: circularProgress(),
                            )
                          : snapshot.data!.docs.isEmpty
                              ? Container()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    return AddressDesign(
                                      currentIndex: address.count,
                                      value: index,
                                      addressID: snapshot.data!.docs[index].id,
                                      totalAmount: widget.totalAmount,
                                      sellerUID: widget.sellerUID,
                                      model: Address.fromJson(
                                          snapshot.data!.docs[index].data()!
                                              as Map<String, dynamic>),
                                    );
                                  });
                    }));
          })
        ],
      ),
    );
  }
}
