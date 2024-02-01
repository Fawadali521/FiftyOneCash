import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:fifty_one_cash/landing-page.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/GlobalViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'src/modules/dashboard/dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalViewModel()),
      ],
      child: MaterialApp(
        title: '51CASH',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Future Medium',
          scaffoldBackgroundColor: Colors.white,
          brightness: Platform.isIOS ? Brightness.dark : Brightness.light,
          useMaterial3: true,
        ),

        //edited by MHK-MotoVlogs

        supportedLocales: const [Locale('en')],
        localizationsDelegates: const [
          CountryLocalizations.delegate,
        ],

        //end
        // home: const LandingPage()
        home:DashBoard(),
      ),
    );
  }
}
