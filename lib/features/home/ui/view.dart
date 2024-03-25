// import necessary packages
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/features/api_calls/dashboard_provider.dart';
import 'package:provider/provider.dart';

// WelcomePage widget
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<SeminarProfileProvider>(context, listen: false)
          .fetchSeminars(),
      builder: (context, AsyncSnapshot<FacultySeminar> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is loading
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurred
          return Text('Error: ${snapshot.error}');
        } else {
          // Data loaded successfully
          final facultySeminar = snapshot.data!;
          return Material(
            // Wrap YourDisplayWidget with Material
            child: YourDisplayWidget(facultySeminar: facultySeminar),
          );
        }
      },
    );
  }
}

class YourDisplayWidget extends StatelessWidget {
  final FacultySeminar facultySeminar;

  const YourDisplayWidget({Key? key, required this.facultySeminar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        children: [
          Text('Faculty: ${facultySeminar.faculty.facultyName}'),
          SizedBox(height: 10),
          Text('Seminars:'),
          SizedBox(height: 5),
          Column(
            children: facultySeminar.seminars.map((seminar) {
              // Convert base64 string to Uint8List
              Uint8List bytes = base64Decode(seminar.cover_photo);

              return Column(
                children: [
                  // Image positioned above the seminar details
                  Container(
                    width: 200,
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded rectangle border
                      image: DecorationImage(
                        image:
                            MemoryImage(bytes), // Use MemoryImage for Uint8List
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(seminar.title),
                    subtitle: Text('Location: ${seminar.location}'),
                    trailing: Text('Seats: ${seminar.no_of_seats}'),
                    // You can add more information or customize the ListTile as needed
                  ),
                  SizedBox(height: 10), // Add some space between seminars
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
