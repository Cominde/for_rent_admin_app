import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'db/db.dart';
import 'layout/layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//liliijar_cominde_122333
Future <void> main() async{

  await dotenv.load(fileName: ".env");


  await dbConnect();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (context) => cubit(),
        child: BlocConsumer<cubit,States>(
              listener: (context, state) {
              },
              builder: (context, state) {
                return  ToastificationWrapper(
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Clothes and Decoration Rental',
                    theme: ThemeData(
                      primarySwatch: Colors.green,
                      colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
                    ),
                    home:Layout(),
                  ),
                );
              },
        ),
    );
  }
}


