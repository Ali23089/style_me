import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:style_me/Confirmation.dart'; // Adjust the import path if necessary.
import 'package:firebase_auth/firebase_auth.dart';

enum SlotStatus { available, selected, booked, lunch }

enum ServiceType { salon, home }

class TimeSlot {
  final TimeOfDay time;
  SlotStatus status;
  ServiceType? serviceType;

  TimeSlot({required this.time, required this.status, this.serviceType});
}

class CustomBookingScreen extends StatefulWidget {
  final Map<String, dynamic> serviceDetails;

  const CustomBookingScreen({Key? key, required this.serviceDetails})
      : super(key: key);

  @override
  _CustomBookingScreenState createState() => _CustomBookingScreenState();
}

class _CustomBookingScreenState extends State<CustomBookingScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;
  ServiceType? selectedServiceType;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Calendar')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 16),
            buildWeekSelector(context),
            SizedBox(height: 16),
            buildLegend(context),
            SizedBox(height: 16),
            buildTimeSlotsGrid(),
            SizedBox(height: 16),
            buildServiceTypeSelector(),
            SizedBox(height: 20),
            buildBookingButton(),
          ],
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
            child: Container(
              width: 60,
              decoration: isSelected
                  ? BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(50),
                    )
                  : null,
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
            ),
            alignment: Alignment.center,
            child: Text('${slot.time.format(context)}',
                style: TextStyle(color: Colors.white)),
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

  Widget buildServiceTypeSelector() {
    return Visibility(
      visible: selectedTime != null, // Only show if a time has been selected
      child: Wrap(
        spacing: 8.0, // gap between adjacent chips
        children: ServiceType.values
            .map((type) => ChoiceChip(
                  label: Text(type == ServiceType.salon ? "Salon" : "Home"),
                  selected: selectedServiceType == type,
                  onSelected: (selected) {
                    setState(() {
                      selectedServiceType = type;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget buildBookingButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        elevation: 5,
      ),
      onPressed:
          (selectedTime != null && selectedServiceType != null && !isBooking)
              ? () => _saveBooking()
              : null,
      child: isBooking
          ? CircularProgressIndicator(color: Colors.white)
          : Text('BOOK', style: TextStyle(fontSize: 20, color: Colors.white)),
    );
  }

  Future<void> _saveBooking() async {
    setState(() {
      isBooking = true;
    });

    await Future.delayed(
        Duration(seconds: 2)); // Mock delay to simulate async operation

    try {
      // Retrieve the current user's email
      String userEmail =
          FirebaseAuth.instance.currentUser?.email ?? 'no-email-found';

      final bookingData = {
        'date': selectedDate.toIso8601String(),
        'time': selectedTime != null ? formatTimeOfDay(selectedTime!) : null,
        'serviceType': selectedServiceType.toString(),
        'serviceDetails': widget.serviceDetails,
        'salonName': widget.serviceDetails['salonName'],
        'userEmail': userEmail, // Include the user email in the booking data
      };

      // Save the booking information to Firestore
      await FirebaseFirestore.instance.collection('Bookings').add(bookingData);

      setState(() {
        timeSlots.firstWhere((slot) => slot.time == selectedTime).status =
            SlotStatus.booked;
        isBooking = false;
      });

      // Navigate to the confirmation screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              BookingConfirmationScreen(bookingDetails: bookingData),
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
