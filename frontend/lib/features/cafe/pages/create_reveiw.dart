import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/models/cafe.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewFormPage extends StatefulWidget {
  final Cafe cafe;

  ReviewFormPage({required this.cafe});

  @override
  _ReviewFormPageState createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  late MapZoomPanBehavior _zoomPanBehavior;
  double rating = 3.0; // Default rating
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = MapZoomPanBehavior(
      focalLatLng: MapLatLng(
        double.parse(widget.cafe.latitude),
        double.parse(widget.cafe.longitude),
      ),
      zoomLevel: 16.0,
      maxZoomLevel: 20.0,
    );
  }

  void _submitReview() {
    // Implement the logic to submit the review
    // You can use 'rating' and 'commentController.text' to get the user's input
    // For example, you can send this data to your backend API.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cafe.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: SfMaps(
                layers: <MapLayer>[
                  MapTileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    zoomPanBehavior: _zoomPanBehavior,
                    initialMarkersCount: 1,
                    markerBuilder: (BuildContext context, int index) {
                      return MapMarker(
                        latitude: double.parse(widget.cafe.latitude),
                        longitude: double.parse(widget.cafe.longitude),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(widget.cafe.name),
                                  content: Text(widget.cafe.address),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            child: Icon(Icons.location_pin, size: 60),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rate this cafe:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40.0,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      setState(() {
                        rating = newRating;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Write a comment:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write your comment here...',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _submitReview();
                    },
                    child: Text('Submit Review'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
