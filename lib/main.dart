import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:record_admin/firebase_options.dart';
import 'package:record_admin/helpers/AppTheme.dart';
import 'package:record_admin/providers/auth_provider.dart';
import 'package:record_admin/providers/media_provider.dart';
import 'package:record_admin/providers/themeProvider.dart';
import 'package:record_admin/screens/auth/auth_screen.dart';
import 'package:record_admin/screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MediaProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, value, child) {
        return GetMaterialApp(
          title: 'Khaire Admin',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: value.darkMode ? ThemeMode.dark : ThemeMode.light,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) =>
                snapshot.hasData ? const Dashboard() : const AuthScreen(),
          ),
        );
      }),
    );
  }
}
