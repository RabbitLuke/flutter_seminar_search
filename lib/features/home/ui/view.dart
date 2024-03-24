// import necessary packages
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
          return YourDisplayWidget(facultySeminar: facultySeminar);
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
    // Here you can use the facultySeminar data to display UI
    return Column(
      children: [
        Text('Faculty: ${facultySeminar.faculty.facultyName}'),
        // Display seminars or any other data as needed
      ],
    );
  }
}
