import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/upload_provider.dart';
import 'package:story_app/services/post_upload_notifier.dart';
import 'package:story_app/widgets/border.dart';
import 'package:geocoding/geocoding.dart' as geo;

class CreateStoryScreen extends StatefulWidget {
  final Function() onStoryCreated;
  const CreateStoryScreen({super.key, required this.onStoryCreated});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  geo.Placemark? placemark;
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  final location = LatLng(-6.2297209, 106.6647053);
  final descriptiionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  

  @override
  void dispose() {
    descriptiionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: widget.onStoryCreated,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "New Story",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: SizedBox(
          width: screenWidth,
          child: Form(
            key: formKey,
            child: Column(children: [
              SizedBox(
                height: 16,
              ),
              SizedBox(
                  width: 0.8 * screenWidth,
                  height: 0.4 * screenHeight,
                  child: context.watch<UploadProvider>().imagePath == null
                      ? Icon(
                          Icons.image,
                          size: 0.8 * screenWidth,
                        )
                      : _showImage()),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      _onGalleryView();
                    },
                    child: FittedBox(
                        child: Text(
                      "Gallery",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: Colors.white),
                    )),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      _onCameraView();
                    },
                    child: FittedBox(
                        child: Text(
                      "Camera",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: Colors.white),
                    )),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                width: screenWidth * 0.8,
                child: TextFormField(
                  controller: descriptiionController,
                  maxLines: 5,
                  onSaved: (desc) {},
                  onChanged: (desc) {},
                  validator: (desc) {
                    if (desc == null || desc.isEmpty) {
                      return 'Please enter your desc.';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: "Enter your Description",
                      labelText: "Description",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: const TextStyle(color: Color(0xFF757575)),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      border: authOutlineInputBorder.copyWith(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: authOutlineInputBorder.copyWith(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: authOutlineInputBorder.copyWith(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              const BorderSide(color: Colors.pinkAccent))),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 300,
                child: GoogleMap(
                  markers: markers,
                  onLongPress: onLongPressGmap,
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                  initialCameraPosition:
                      CameraPosition(zoom: 18, target: location),
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white),
                onPressed: onMyLocationButtonPress,
                child: FittedBox(
                    child: Text(
                  "Current Location",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
                )),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _onUpload();
                  }
                },
                child: FittedBox(
                    child: Text(
                  context.watch<UploadProvider>().isUploading
                      ? "Uploading..."
                      : "Upload",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
                )),
              ),
            ]),
          ),
        )),
      ),
    );
  }

  _onGalleryView() async {
    final provider = context.read<UploadProvider>();
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<UploadProvider>();
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<UploadProvider>().imagePath;
    return Image.file(
      File(imagePath.toString()),
      fit: BoxFit.contain,
    );
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final provider = context.read<UploadProvider>();
    provider.setLocation(latLng);
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void onLongPressGmap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latLng, street, address);
  }

  _onUpload() async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);

    final provider = context.read<UploadProvider>();
    final imagePath = provider.imagePath;
    final imageFile = provider.imageFile;
    final desc = descriptiionController.text;
    if (imagePath == null || imageFile == null) return;
    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final location = provider.location;
    await provider.upload(bytes, fileName, desc, location?.latitude, location?.longitude);
    if (provider.uploadResponse != null) {
      context.read<PostUploadNotifier>().returnData(true);
      descriptiionController.clear();
      provider.setImageFile(null);
      provider.setImagePath(null);
      provider.setLocation(null);

      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(provider.message)),
      );
    }
  }
}
