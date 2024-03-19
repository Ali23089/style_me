import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:style_me/Appointment.dart';

class SalonCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon Categories'),
      ),
      body: Column(
        children: [
          // Salon Image
          Image.network(
            'https://img.freepik.com/premium-photo/salon-with-mirror-wall-hair-salon-chair_732812-843.jpg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Categories
          Expanded(child: Categories()),
        ],
      ),
    );
  }
}

class Categories extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Haircut',
      'image': 'assets/HairCut1.png',
      'description': 'Get the latest haircut trends!',
    },
    {
      'name': 'Facial',
      'image': 'assets/Facial.jpg',
      'description': 'Rejuvenate your skin with our facial treatments.',
    },
    {
      'name': 'Manicure & Pedicure',
      'image': 'assets/Menipedi.jpg',
      'description':
          'Pamper your hands and feet with our manicure and pedicure services.',
    },
    {
      'name': 'Makeup & Beauty',
      'image': 'assets/Makeup.jpg',
      'description': 'Enhance your beauty with our makeup and beauty services.',
    },
    {
      'name': 'Mehndi',
      'image': 'assets/Mehndi1.jpg',
      'description': 'Relax with our soothing massage therapies.',
    },
    {
      'name': 'Waxing',
      'image': 'assets/waxing.jpg',
      'description': 'Smooth and hair-free skin with our waxing services.',
    },
    {
      'name': 'Nail Art',
      'image': 'assets/NailArt.jpg',
      'description': 'Express yourself with creative nail art designs.',
    },
    {
      'name': 'Mens Grooming',
      'image': 'assets/Grooming.jpg',
      'description': 'Specialized grooming services for men.',
    },
    {
      'name': 'Beard Styling',
      'image': 'assets/Beard.jpg',
      'description': 'Perfect styling for your beard.',
    },
    {
      'name': 'Shave',
      'image': 'assets/Shave.jpg',
      'description': 'Experience a smooth and clean shave.',
    },
    // Add more categories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];

          return Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Image.asset(
                category['image'],
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
              title: Text(
                category['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(category['description']),
              onTap: () {
                // Navigate to a new screen to show details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryDetails(category: category),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CategoryDetails extends StatelessWidget {
  final Map<String, dynamic> category;

  CategoryDetails({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              category['image'],
              height: 280,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 16.0),
            Text(
              category['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              category['description'],
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16.0),
            RatingBar.builder(
              initialRating: 3,
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    // Handle any unexpected index by returning a default icon or widget.
                    return Icon(
                      Icons.star,
                      color: Colors.grey,
                    );
                }
              },
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookingCalendarDemoApp()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 13, 106, 101),
                textStyle: TextStyle(
                  fontSize: 18,
                ),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: Text(
                'Save Appointment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentButton extends StatelessWidget {
  final Map<String, dynamic> category;

  AppointmentButton({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'),
      ),
      body: Center(
        child: Text('Book an appointment for ${category['name']}'),
      ),
    );
  }
}
