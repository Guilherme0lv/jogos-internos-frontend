import 'package:flutter/material.dart';
import 'package:projeto_web/routes/router.dart';
import 'package:projeto_web/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JOGOS INTERNOS IFS',
      routes: routes,
      initialRoute: Routes.login,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      supportedLocales: const [
        Locale('pt', 'BR'), 
        Locale('en', 'US'), 
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
