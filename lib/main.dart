import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instacopy/responsive/mobile_screen_layout.dart';
import 'package:instacopy/responsive/responsive_layout.dart';
import 'package:instacopy/responsive/web_screen_layout.dart';
import 'package:instacopy/screens/login_screen.dart';
import 'package:instacopy/utils/colors.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: "AIzaSyAeSSIDu6tB_IK2GZhaY_K3si82sGsib7w",
  authDomain: "instaclone-d46ac.firebaseapp.com",
  projectId: "instaclone-d46ac",
  storageBucket: "instaclone-d46ac.appspot.com",
  messagingSenderId: "992072050246",
  appId: "1:992072050246:web:3fa7064354057b8b850c47"),
  );
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
