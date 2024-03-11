import 'package:flutter/material.dart';
import 'package:style_me/Barbers.dart';
import 'package:style_me/Categories.dart';
import 'package:style_me/DatePicker.dart';
import 'package:style_me/Description.dart';
import 'package:style_me/Details.dart';
import 'package:style_me/Reviews.dart';

class SalonScreen extends StatefulWidget {
  const SalonScreen({Key? key}) : super(key: key);

  @override
  State<SalonScreen> createState() => _SalonScreenState();
}

class _SalonScreenState extends State<SalonScreen>
    with SingleTickerProviderStateMixin {
  // used for animation
  int currentIndex = 0;

  final List<String> screenNames = [
    'Categories',
    //'Description',
    'Details',
    'Barbers',
    //'Reviews',
  ];

  int current = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: current);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width *
        0.2; // Set the width as a percentage of the screen width

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 13, 106, 101),
      appBar: AppBar(
        title: Text('Salon Screen'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: screenNames.length,
              itemBuilder: (ctx, index) {
                // callback function
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      current = index;
                      pageController.animateToPage(
                        current,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    width: buttonWidth, // Set the width of the button
                    height: 45,
                    decoration: BoxDecoration(
                      color: current == index ? Colors.white70 : Colors.white54,
                      borderRadius: current == index
                          ? BorderRadius.circular(15)
                          : BorderRadius.circular(10),
                      border: current == index
                          ? Border.all(
                              color: Color.fromARGB(255, 13, 106, 101),
                              width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        screenNames[index],
                        style: TextStyle(
                          fontFamily: "times new roman",
                          fontWeight: FontWeight.w500,
                          color: current == index
                              ? Colors.black
                              : const Color.fromARGB(221, 76, 76, 76),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            // used to make the PageView take up all available vertical space within its parent widget.
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  current = index;
                });
              },
              children: [
                Categories(),
                //Description(),
                Details(),
                Barbers(),
                // Reviews(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
