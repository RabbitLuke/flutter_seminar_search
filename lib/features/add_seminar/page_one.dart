import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_seminar_search/features/add_seminar/page_two.dart';
import 'package:flutter_seminar_search/features/api_calls/seminar_provider.dart';
import 'package:provider/provider.dart';

class SeminarPageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final seminarProvider = Provider.of<SeminarProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: seminarProvider.seminarProfile.seminarTitle,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: seminarProvider.seminarProfile.seminarDuration,
              decoration: InputDecoration(labelText: 'Duration'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextFormField(
              controller: seminarProvider.seminarProfile.seminarLocation,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextFormField(
              controller: seminarProvider.seminarProfile.seminarNo_of_seats,
              decoration:
                  InputDecoration(labelText: 'Number of seats available'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SeminarPageTwo()));
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
