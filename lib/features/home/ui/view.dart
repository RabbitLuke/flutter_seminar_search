// import necessary packages
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/common/header.dart';
import 'package:flutter_seminar_search/common/user_footer.dart';
import 'package:flutter_seminar_search/features/api_calls/dashboard_provider.dart';
import 'package:provider/provider.dart';

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
  return Stack(
    children: [
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomHeader(),
            Text('Faculty: ${facultySeminar.faculty.facultyName}'),
            SizedBox(height: 10),
            Text('Seminars:'),
            SizedBox(height: 5),
            Column(
              children: facultySeminar.seminars.map((seminar) {
                Uint8List bytes = base64Decode(seminar.cover_photo);
                return Column(
                  children: [
                    Container(
                      width: 200,
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: MemoryImage(bytes),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(seminar.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Location: ${seminar.location}'),
                          Text('Duration: ${seminar.duration} hours'),
                          Text('Date: ${seminar.date}'),
                        ],
                      ),
                      trailing: Text('Seats: ${seminar.no_of_seats}'),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: UserFooter(), // Use the Footer widget here
      ),
    ],
  );
}


}
