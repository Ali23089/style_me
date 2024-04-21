import 'package:flutter/material.dart';
import 'package:style_me/Barbers.dart';
import 'package:style_me/Categories.dart';
import 'package:style_me/Details.dart';

class SalonScreen extends StatefulWidget {
  final String salonEmail; // Define the salon email here

  const SalonScreen({Key? key, required this.salonEmail})
      : super(key: key); // Modify the constructor to accept it

  @override
  State<SalonScreen> createState() => _SalonScreenState();
}

class _SalonScreenState extends State<SalonScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  final List<String> screenNames = [
    'Categories',
    'Details',
    'Barbers',
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
    // Dynamically calculate the button width based on the number of items
    double buttonWidth = MediaQuery.of(context).size.width / screenNames.length;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 13, 106, 101),
      appBar: AppBar(
        title: Text('Salon Screen'),
        //backgroundColor: Colors.teal,
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
                    width: buttonWidth, // Dynamically set width
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
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  current = index;
                });
              },
              children: [
                Categories(
                    salonEmail:
                        widget.salonEmail), // Pass the salonEmail to Categories
                Details(
                    salonEmail:
                        widget.salonEmail), // Pass the salonEmail to Details
                //Barbers(salonEmail: widget.salonEmail), // You might want to pass the salonEmail to Barbers as well if it's needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
