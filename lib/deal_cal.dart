import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:style_me/dealScript.dart';

enum SlotStatus { available, selected, booked, lunch }

class TimeSlot {
  final TimeOfDay time;
  SlotStatus status;

  TimeSlot({required this.time, required this.status});
}

class CustomBookingScreen1 extends StatefulWidget {
  final Map<String, dynamic> serviceDetails;
  final String locationName;

  const CustomBookingScreen1(
      {Key? key, required this.serviceDetails, required this.locationName})
      : super(key: key);

  @override
  _CustomBookingScreen1State createState() => _CustomBookingScreen1State();
}

class _CustomBookingScreen1State extends State<CustomBookingScreen1>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;
  bool isBooking = false;

  final List<TimeSlot> timeSlots = List.generate(
    16,
    (index) => TimeSlot(
      time: TimeOfDay(hour: 8 + (index ~/ 2), minute: (index % 2) * 30),
      status: (index % 4 == 0)
          ? SlotStatus.booked
          : (index == 7)
              ? SlotStatus.lunch
              : SlotStatus.available,
    ),
  );

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Calendar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                buildWeekSelector(context),
                SizedBox(height: 16),
                buildLegend(context),
                SizedBox(height: 16),
                buildTimeSlotsGrid(),
                SizedBox(height: 20),
                buildBookingButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWeekSelector(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    List<DateTime> weekDays =
        List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          DateTime weekDay = weekDays[index];
          bool isSelected = selectedDate.day == weekDay.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate =
                    DateTime(weekDay.year, weekDay.month, weekDay.day);
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? Color.fromARGB(255, 13, 106, 101)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 13, 106, 101),
                ),
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    DateFormat('E').format(weekDay),
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black),
                  ),
                  Text(
                    weekDay.day.toString(),
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        buildLegendItem(context, "Available", Colors.green),
        buildLegendItem(context, "Selected", Colors.blue),
        buildLegendItem(context, "Booked", Colors.red),
        buildLegendItem(context, "Lunch", Colors.grey),
      ],
    );
  }

  Widget buildLegendItem(BuildContext context, String text, Color color) {
    return Row(
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget buildTimeSlotsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        return GestureDetector(
          onTap: () {
            if (slot.status == SlotStatus.available) {
              selectTimeSlot(slot);
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: getColorForStatus(slot.status),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color.fromARGB(255, 13, 106, 101)),
            ),
            alignment: Alignment.center,
            child: Text(
              '${slot.time.format(context)}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void selectTimeSlot(TimeSlot slot) {
    setState(() {
      resetAllSlots();
      selectedTime = slot.time;
      slot.status = SlotStatus.selected;
    });
  }

  void resetAllSlots() {
    for (var slot in timeSlots) {
      if (slot.status == SlotStatus.selected) {
        slot.status = SlotStatus.available;
      }
    }
  }

  Widget buildBookingButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        elevation: 5,
      ),
      onPressed:
          (selectedTime != null && !isBooking) ? () => _saveBooking() : null,
      child: isBooking
          ? CircularProgressIndicator(color: Colors.white)
          : Text('BOOK', style: TextStyle(fontSize: 20, color: Colors.white)),
    );
  }

  Future<void> _saveBooking() async {
    setState(() {
      isBooking = true;
    });

    await Future.delayed(Duration(seconds: 2));

    try {
      String userEmail =
          FirebaseAuth.instance.currentUser?.email ?? 'no-email-found';

      final bookingData = {
        'date': DateFormat.yMMMd().format(selectedDate),
        'time': selectedTime != null ? formatTimeOfDay(selectedTime!) : '',
        'serviceDetails': widget.serviceDetails,
        'salonName': widget.serviceDetails['salonName'],
        'userEmail': userEmail,
        'salonEmail': widget.serviceDetails['barberEmail'],
        'locationName': widget.locationName,
      };

      // Save the booking information to Firestore
      await FirebaseFirestore.instance
          .collection('dealsbooking')
          .add(bookingData);

      setState(() {
        timeSlots.firstWhere((slot) => slot.time == selectedTime).status =
            SlotStatus.booked;
        isBooking = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              BookingReceiptScreen(bookingDetails: bookingData),
        ),
      );
    } catch (e) {
      setState(() {
        isBooking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  Color getColorForStatus(SlotStatus status) {
    switch (status) {
      case SlotStatus.available:
        return Colors.green;
      case SlotStatus.selected:
        return Colors.blue;
      case SlotStatus.booked:
        return Colors.red;
      case SlotStatus.lunch:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
