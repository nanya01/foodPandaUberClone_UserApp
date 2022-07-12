import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodpanda_users_app/global/global.dart';
import 'package:foodpanda_users_app/models/address.dart';
import 'package:foodpanda_users_app/widgets/simple_app_bar.dart';
import 'package:foodpanda_users_app/widgets/text_field.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({Key? key}) : super(key: key);

  @override
  _SaveAddressScreenState createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _flatNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _completeAddressController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Placemark>? placeMarks;
  Position? position;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    Position? newPosition = await _determinePosition();

    position = newPosition;

    placeMarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMark = placeMarks![0];

    String completeAddress =
        '${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';

    print('Address $completeAddress');
    _locationController.text = completeAddress;
    _flatNumberController.text =
        '${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}, ${pMark.postalCode}';
    _cityController.text =
        '${pMark.subAdministrativeArea}, ${pMark.administrativeArea}';
    _stateController.text = ' ${pMark.country}';
    _completeAddressController.text = completeAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            final model = Address(
                    name: _nameController.text.trim().toString(),
                    phoneNumber: _phoneNumberController.text.trim().toString(),
                    fullAddress:
                        _completeAddressController.text.trim().toString(),
                    flatNumber: _flatNumberController.text.trim().toString(),
                    city: _cityController.text.trim().toString(),
                    state: _stateController.text.toString(),
                    lat: position!.latitude,
                    lng: position!.longitude)
                .toJson();

            FirebaseFirestore.instance
                .collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("userAddress")
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set(model)
                .then((value) {
              Fluttertoast.showToast(
                  msg: "New Address has been saved successfully");
              formKey.currentState!.reset();
              _locationController.clear();
            });
          }
        },
        label: const Text("Save Now"),
        backgroundColor: Colors.cyan,
        icon: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 6,
            ),
            const Align(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Save New Address",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_pin_circle,
                color: Colors.black,
                size: 35,
              ),
              title: SizedBox(
                width: 250,
                child: TextField(
                  controller: _locationController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                      hintText: "What is your address?",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            ElevatedButton.icon(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Colors.cyan)))),
                onPressed: () {
                  getUserLocation();
                },
                icon: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                label: const Text("Get my Location")),
            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Name",
                    controller: _nameController,
                  ),
                  MyTextField(
                    hint: "Phone Number",
                    controller: _phoneNumberController,
                  ),
                  MyTextField(
                    hint: "City",
                    controller: _cityController,
                  ),
                  MyTextField(
                    hint: "State / Country",
                    controller: _stateController,
                  ),
                  MyTextField(
                    hint: "Address Line",
                    controller: _flatNumberController,
                  ),
                  MyTextField(
                    hint: "Complete Address",
                    controller: _completeAddressController,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
