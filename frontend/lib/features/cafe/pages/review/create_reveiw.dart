import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/api/api_service.dart';
import 'package:full_stack_project/features/cafe/models/cafe.dart';
import 'package:full_stack_project/features/cafe/models/review.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  List<Review> _reviews = []; // List to store reviews

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = MapZoomPanBehavior(
      focalLatLng: MapLatLng(
        widget.cafe.latitude,
       widget.cafe.longitude,
      ),
      zoomLevel: 16.0,
      maxZoomLevel: 20.0,
    );

    // Fetch initial reviews when the widget is initialized
    _loadReviews();
  }

  // Method to fetch reviews
// Method to fetch reviews
Future<void> _loadReviews() async {
  try {
    // Convert cafe_id to int
    final cafeId = int.tryParse(widget.cafe.cafe_id) ?? 1;

    final reviews = await getReviews(cafeId);
    print('Fetched reviews: $reviews');
    setState(() {
      _reviews = reviews;
    });
  } catch (e) {
    print('Error fetching reviews: $e');
  }
}


Future<void> _submitReview() async {
  print('Submitting review...');
  final reviewApi = createReviewApi('localhost:3000/api/create/review');
  final Map<String, dynamic> reviewData = {
    'cafe_id': widget.cafe.cafe_id,
    'rating': rating,
    'comment': commentController.text,
  };

  try {
    final response = await reviewApi.postHttpResponse(reviewData);
    print('Response body: ${response.body}');
    print('Response type: ${response.body.runtimeType}');

    if (response.statusCode == 200) {
      // Wait for the reviews to be updated before proceeding
      await _loadReviews();

      print('Review submitted successfully');
    } else {
      print('Failed to submit review. Server returned status ${response.statusCode}');
    }
  } catch (e) {
    print('Error during HTTP request: $e');
  }
}



  Future<List<Review>> getReviews(int cafeId) async {
    try {
      final getReviewEachCafe = GetReviewEachCafe('localhost:3000/api/review/$cafeId');
      final response = await getReviewEachCafe.getHttpResponse();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['ok'] == true) {
          final List<dynamic> data = responseData['data'];
          final List<Review> reviews = data.map((reviewData) {
            return Review(
              review_id: reviewData['review_id'],
              cafe_id: reviewData['cafe_id'],
              rating: reviewData['rating'],
              comment: reviewData['comment'],
            );
          }).toList();
          return reviews;
        } else {
          // Handle the case where 'ok' is false
          print('Failed to fetch reviews. Server returned: ${responseData['msg']}');
          throw Exception('Failed to fetch reviews. Server returned: ${responseData['msg']}');
        }
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to fetch reviews. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }

Future<void> _editReview(Review review, int reviewId) async {
  TextEditingController updatedCommentController = TextEditingController(text: review.comment);
  double updatedRating = review.rating.toDouble(); // Convert int to double

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Review'),
        content: Column(
          children: [
            Text('Edit your rating:'),
            RatingBar.builder(
              initialRating: updatedRating,
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
                updatedRating = newRating;
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: updatedCommentController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Edit your comment here...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              // Implement logic to update the review
              // You can use the updatedRating and updatedCommentController.text

              // Update the review on the server
              final modifyReviewApi = ModifyReview('localhost:3000/api/modify' + '/${review.review_id}');
              final Map<String, dynamic> modifiedReviewData = {
                'rating': updatedRating,
                'comment': updatedCommentController.text,
              };

              try {
                final response = await modifyReviewApi.putHttpResponse(modifiedReviewData);


                if (response.statusCode == 200) {
                  print('Review modified successfully');
                  Navigator.of(context).pop(); // Close the dialog
                  _loadReviews(); // Reload the reviews list
                } else {
                  print('Failed to modify review. Server returned status ${response.statusCode}');
                }
              } catch (e) {
                print('Error during HTTP request: $e');
              }
            },
            child: Text('수정'),
          ),
        ],
      );
    },
  );
}

Future<void> _deleteReview(int reviewId) async {
  // Show a confirmation dialog before deleting
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Review'),
        content: Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              // Call the DeleteReview API here
              final deleteReviewApi = DeleteReview('localhost:3000'); // Replace with your actual base URL

              try {
                final response = await deleteReviewApi.deleteReview(reviewId.toString());

                if (response.statusCode == 200) {
                  print('Review deleted successfully');
                  _loadReviews(); // Reload the reviews list
                } else {
                  print('Failed to delete review. Server returned status ${response.statusCode}');
                }
              } catch (e) {
                print('Error during HTTP request: $e');
              }
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
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
                        latitude: widget.cafe.latitude,
                        longitude: widget.cafe.longitude,
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
                    'Your Rating:',
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
                    '리뷰 생성하기',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: commentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write your comment here...',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
Center(
  child: ElevatedButton(
    onPressed: () {
      _submitReview();
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text('Submit'),
    ),
  ),
),
                  Text(
                    'Reviews:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: _reviews.map((review) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text('Rating: ${review.rating}'),
                          subtitle: Text('${review.comment}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editReview(review, review.review_id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete Review'),
                                        content: Text('Are you sure you want to delete this review?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _deleteReview(review.review_id);
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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

