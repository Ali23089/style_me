/*import 'package:flutter/material.dart';

class Review {
  final String text;
  final int rating;

  Review({required this.text, required this.rating});
}

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  // Dummy list of reviews for testing
  final List<Review> reviews = [
    Review(text: "Great service! Loved my haircut.", rating: 5),
    Review(text: "The staff is friendly and professional.", rating: 4),
    Review(text: "Clean and inviting atmosphere.", rating: 5),
  ];

  Widget _buildStarRating(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < rating; i++) {
      stars.add(Icon(
        Icons.star,
        color: Colors.amber,
      ));
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon Reviews'),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviews[index].text,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  _buildStarRating(reviews[index].rating),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/