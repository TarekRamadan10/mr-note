import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_note/features/record_note/presentation/screens/records_screen.dart';
import 'package:mr_note/features/text_note/presentation/screens/all_notes_screen.dart';
import '../../../../utils/ui_models.dart';
import '../../data_layer/repos/local_data_repo.dart';
import '../../presentation/screens/favorites_screen.dart';
import 'note_states.dart';

class NoteCubit extends Cubit<NoteState>{
  NoteCubit():super(NoteInitialState());

  List<AppBarModel> notesAppBar=[
    AppBarModel(title: 'Mr.Note',actions: []),
    AppBarModel(title:'Records', actions:[]),
    AppBarModel(title:'Favorites', actions:[]),
  ];

  List<Widget>screens=const [
    AllNotesScreen(),
    RecordsScreen(),
    FavoriteNotesScreen()
  ];


  int currentIndex=0;

  void navigationBarChange(int index)
  {
    currentIndex=index;
    emit(NoteChangeNavBarState());
  }

  bool isSearch=false;

  void changeHomeBar()
  {
    isSearch =! isSearch;
    if(!isSearch)
    {
      searchResult=[];
    }
    emit(ChangeHomeBarState());
  }

  void createDatabase()async
  {
      LocalDataRepo.createDatabase().then((value){
       emit(CreateDatabaseSuccessState());
       getDataFromDatabase();
     }).catchError((error){
       if (kDebugMode) {
         print(error.toString());
       }
       emit(CreateDatabaseErrorState());
     });
  }

  void insertToDatabase(String title, body, type,favorite)async
  {
    LocalDataRepo.insertToDatabase(title, body, type,favorite).then((value){
      emit(InsertToDatabaseSuccessState());
      getDataFromDatabase();
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(InsertToDatabaseErrorState());
    });
  }

  List<Map<String,dynamic>> notes=[];
  List<Map<String,dynamic>> searchResult=[];
  List<Map<String,dynamic>> favorites=[];

  void getDataFromDatabase()async
  {
    notes=[];
    favorites=[];
    LocalDataRepo.getDataFormDatabase().then((value){
      value?.forEach((element) {
        if(element['type']=='note')
          {
            notes.add(element);
          }

        if(element['fav']=='yes')
          {
            favorites.add(element);
          }
      });
      emit(GetDataFromDatabaseSuccessState());
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetDataFromDatabaseErrorState());
    });

  }

  void updateFavoritesInDatabase(int id ,String isFav)
  {
    LocalDataRepo.updateFavorites(id, isFav).then((value){
      emit(UpdateFavDataSuccessState());
      getDataFromDatabase();
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(UpdateFavDataErrorState());
    });
  }

  void deleteDataFromDatabase(int id)async
  {
    LocalDataRepo.deleteDataFromDatabase(id).then((value){
      emit(DeleteDataFromDatabaseSuccessState());
      getDataFromDatabase();
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(DeleteDataFromDatabaseErrorState());
    });
  }

 void updateData({required int id,required String title,body})
 {
   LocalDataRepo.updateData(id, title, body).then((value){
     emit(UpdateDataInDatabaseSuccessState());
     getDataFromDatabase();
   }).catchError((error){
     if (kDebugMode) {
       print(error.toString());
     }
     emit(UpdateDataInDatabaseErrorState());
   });
 }

 void search(String title)
 {
   searchResult=notes.where((element) => element['title'].toString().toLowerCase().startsWith(title)).toList();
   emit(SearchState());

   if(title.isEmpty)
   {
     searchResult=[];
   }
 }
}