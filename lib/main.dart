import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_note/features/record_note/cubit/records_cubit.dart';
import 'package:mr_note/features/text_note/presentation/screens/home_page.dart';
import '/features/text_note/business_logic/bloc_observer.dart';
import '/features/text_note/business_logic/note_bloc/note_cubit.dart';
import 'constants/colors.dart';
import 'package:mr_note/features/record_note/presentation/screens/add_record_note.dart';
import 'features/record_note/presentation/screens/records_screen.dart';


void main() {
  runApp(const MyApp());
  Bloc.observer=MyBlocObserver();
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context)=>NoteCubit()..createDatabase(),
        ),
        BlocProvider(
          create: (context)=>RecordsNotesCubit()..initRecorder()..getRecordsFromDatabase(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
              systemOverlayStyle:SystemUiOverlayStyle(
                  statusBarColor:defaultWhite,
                  statusBarIconBrightness:Brightness.dark
              ),
              elevation: 0,
              color: defaultWhite,
              actionsIconTheme:const IconThemeData(
                size:33,
              ),
              iconTheme: IconThemeData(
                color: myBlack,
              ),
              titleTextStyle: TextStyle(
                  color:myBlack
              ),
              toolbarHeight:70,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor:defaultColor,
              elevation: 0,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              unselectedItemColor: Colors.grey,
              selectedItemColor: Colors.white,
              backgroundColor: defaultColor,
              selectedIconTheme:const IconThemeData(
                color:Colors.white,
                size:30.0,
              ),
              showUnselectedLabels: true,
              unselectedIconTheme:const IconThemeData(
                color:Colors.grey,
              ),
            ),
            iconTheme: IconThemeData(
              color: defaultColor,
            ),
            tabBarTheme: TabBarTheme(
                labelColor:Colors.white,
                unselectedLabelColor: Colors.grey,
                indicator:BoxDecoration(
                  color:defaultColor,
                  borderRadius:BorderRadius.circular(5.5),
                )
            )
        ),
        home:HomeScreen(),
      ),
    );
  }
}