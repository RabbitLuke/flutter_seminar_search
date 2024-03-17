import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_seminar_search/features/login/login_component.dart';
import 'package:flutter_seminar_search/features/register/host_page_one.dart';
import 'package:flutter_seminar_search/features/register/page_one.dart';

class HostOrUser extends StatelessWidget {
  const HostOrUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Text(
                    'Lets get started!',
                    style: TextStyle(
                      color: Color(0xFF3E3A7A),
                      fontSize: 36,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 60),
                  Text(
                    'I am looking to...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E3A7A),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PageOne()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3E3A7A),
                      minimumSize: Size(300, 50),
                      maximumSize: Size(300, 50),
                    ),
                    child: Text(
                      'Find a Seminar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HostPageOne()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3E3A7A),
                      minimumSize: Size(300, 50),
                      maximumSize: Size(300, 50),
                    ),
                    child: Text(
                      'Host a Seminar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 160),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginComponent()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 233, 233, 233),
                      minimumSize: Size(200, 50),
                      maximumSize: Size(200, 50),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ])));
  }
}
