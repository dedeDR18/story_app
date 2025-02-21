import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/detail_story_provider.dart';
import 'package:story_app/static/detail_story_result_state.dart';
import 'package:geocoding/geocoding.dart' as geo;

class DetailStoryScreen extends StatefulWidget {
  final Function() onBack;
  final String idStory;
  const DetailStoryScreen(
      {super.key, required this.idStory, required this.onBack});

  @override
  State<DetailStoryScreen> createState() => _DetailStoryScreenState();
}

class _DetailStoryScreenState extends State<DetailStoryScreen> {
  geo.Placemark? placemark;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DetailStoryProvider>().getDetailStory(widget.idStory);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: widget.onBack,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "Detail Story",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<DetailStoryProvider>(builder: (context, provider, child) {
        return switch (provider.resultState) {
          DetailStoryLoadingState() => Center(
                child: const CircularProgressIndicator(
              color: Colors.pinkAccent,
            )),
          DetailStoryErrorState() =>
            Center(child: const Text("Something went wrong...")),
          DetailStoryLoadedState(detailStory: var story) =>
            SingleChildScrollView(
              child: SizedBox(
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      width: screenWidth * 0.9,
                      imageUrl: story.photoUrl,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(color: Colors.pinkAccent),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      story.name,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      story.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    if (story.lat != null && story.lon != null)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 250,
                          child: GoogleMap(
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            myLocationButtonEnabled: false,
                            onMapCreated: (_) async {
                              final info = await geo.placemarkFromCoordinates(
                                  story.lat!, story.lon!);
                              final place = info[0];
                              setState(() {
                                placemark = place;
                              });
                            },
                            markers: {
                              Marker(
                                infoWindow: InfoWindow(
                                    title: "${placemark?.street}",
                                    snippet:
                                        "${placemark?.subLocality}, ${placemark?.locality}, ${placemark?.postalCode}, ${placemark?.country}"),
                                markerId: MarkerId('story'),
                                position: LatLng(story.lat!, story.lon!),
                              )
                            },
                            initialCameraPosition: CameraPosition(
                                target: LatLng(story.lat!, story.lon!),
                                zoom: 18),
                          ),
                        ),
                      )
                    else
                      Text(
                        'Location not available',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ),
          _ => SizedBox()
        };
      }),
    );
  }
}
