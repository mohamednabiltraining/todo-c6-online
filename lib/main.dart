import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_c6_online/firebase_options.dart';
import 'package:todo_c6_online/home/home_screen.dart';
import 'package:todo_c6_online/my_theme_data.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  FirebaseFirestore.instance.disableNetwork();
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes:{
        HomeScreen.routeName :(_)=>HomeScreen()
      } ,
      initialRoute: HomeScreen.routeName,
      theme: MyTheme.lightTheme,
    );
  }
}