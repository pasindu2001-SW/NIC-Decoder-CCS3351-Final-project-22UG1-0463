import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Entry point of the Flutter application
void main() {
  runApp(const MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Hides debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Sets the home screen
    );
  }
}

// Controller class using GetX for state management
class NICController extends GetxController {
  var nicNumber = ''.obs; // Observable variable for NIC number
  var birthDate = ''.obs; // Observable variable for birth date
  var age = 0.obs; // Observable variable for age
  var gender = ''.obs; // Observable variable for gender
  var weekDay = ''.obs; // Observable variable for weekday of birth
  var format = ''.obs; // Observable variable for NIC format (old/new)

  // Function to decode the NIC number
  void decodeNIC(String nic) {
    if (nic.length == 10) {
      format.value = "Old Format"; // Identifies old format
      String year = "19${nic.substring(0, 2)}"; // Extracts year
      int dayOfYear = int.parse(nic.substring(2, 5)); // Extracts day count
      extractDetails(year, dayOfYear); // Extracts details from NIC
    } else if (nic.length == 12) {
      format.value = "New Format"; // Identifies new format
      String year = nic.substring(0, 4); // Extracts year
      int dayOfYear = int.parse(nic.substring(4, 7)); // Extracts day count
      extractDetails(year, dayOfYear); // Extracts details from NIC
    } else {
      // Displays error message for invalid NIC
      Get.snackbar("Error", "Invalid NIC number",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  // Function to extract birth details based on NIC
  void extractDetails(String year, int dayOfYear) {
    bool isFemale = dayOfYear > 500; // Identifies gender
    if (isFemale) dayOfYear -= 500; // Adjusts day count for females

    // Calculates date of birth
    DateTime dob = DateTime(int.parse(year)).add(Duration(days: dayOfYear - 2));
    birthDate.value = DateFormat('yyyy-MM-dd').format(dob);
    age.value = DateTime.now().year - int.parse(year);
    gender.value = isFemale ? "Female" : "Male"; // Assigns gender
    weekDay.value = DateFormat('EEEE').format(dob); // Gets weekday
    Get.to(() => ResultScreen()); // Navigates to result screen
  }
}

// Home screen where the user inputs NIC number
class HomeScreen extends StatelessWidget {
  final TextEditingController _nicController = TextEditingController();
  final NICController nicController =
      Get.put(NICController()); // Injects controller

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NIC Decoder"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade200
            ], // Background gradient
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Input field for NIC number
                      TextField(
                        controller: _nicController,
                        decoration: InputDecoration(
                          labelText: "Enter NIC Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Decode button
                      ElevatedButton(
                        onPressed: () {
                          nicController.decodeNIC(_nicController.text.trim());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Button color
                          foregroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        child: Text("Decode"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Result screen that displays NIC details
class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NICController nicController = Get.put(NICController());

    return Scaffold(
      appBar: AppBar(
        title: Text("NIC Details"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity, // Expands container to full width
        height: double.infinity, // Expands container to full height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade200
            ], // Background gradient
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Displays NIC details
                  Text("Format: ${nicController.format.value}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Date of Birth: ${nicController.birthDate.value}",
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text("Age: ${nicController.age.value}",
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text("Gender: ${nicController.gender.value}",
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text("Weekday: ${nicController.weekDay.value}",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
