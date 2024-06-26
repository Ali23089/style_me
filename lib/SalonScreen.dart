import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_me/Barbers.dart';
import 'package:style_me/Categories.dart';
import 'package:style_me/Details.dart';

class SalonScreen extends StatefulWidget {
  final String salonEmail;
  final String salonName; // Added to receive the salon name
  final String locationName; // Add this parameter

  const SalonScreen({
    Key? key,
    required this.salonEmail,
    required this.salonName,
    required this.locationName,
  }) : super(key: key);

  @override
  State<SalonScreen> createState() => _SalonScreenState();
}

class _SalonScreenState extends State<SalonScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  final List<String> screenNames = [
    'Categories',
    'Details',
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
    double buttonWidth = MediaQuery.of(context).size.width / screenNames.length;

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
                    width: buttonWidth,
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
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: current == index
                              ? Color.fromARGB(255, 13, 106, 101)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  current = index;
                });
              },
              children: [
                Categories(
                  salonEmail: widget.salonEmail,
                  salonName: widget.salonName,
                  locationName: widget.locationName,
                ),
                Details(
                  salonEmail: widget.salonEmail,
                ),
                // Barbers(
                //   salonEmail: widget.salonEmail,
                //   locationName: widget.locationName, // Pass locationName here if needed
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
