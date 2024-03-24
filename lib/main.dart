import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seminar_search/common/http_helper.dart';
import 'package:flutter_seminar_search/features/api_calls/dashboard_provider.dart';
import 'package:flutter_seminar_search/features/api_calls/host_provider.dart';
import 'package:flutter_seminar_search/features/api_calls/seminar_provider.dart';
import 'package:flutter_seminar_search/features/authentication/index.dart';
import 'package:flutter_seminar_search/features/login/login_component.dart';
import 'package:flutter_seminar_search/features/register/page_one.dart';
import 'package:flutter_seminar_search/features/api_calls/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  initDio();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => HostProfileProvider()),
        ChangeNotifierProvider(create: (context) => SeminarProvider()),
        ChangeNotifierProvider(create: (context) => SeminarProfileProvider()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(AuthService())),
        // Add more providers if needed
      ],
      child: MaterialApp(
        home: LoginComponent(),
      ),
    );
  }
}
