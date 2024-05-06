// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'package:todo_list/cubit/app_states.dart';
import '../modules/archive_tasks/archive_task_screen.dart';
import '../modules/done_tasks/done_task_screen.dart';
import '../modules/new_tasks/new_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  // for image
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource sor) async {
    final pickedImage = await picker.pickImage(source: sor);
    if (pickedImage != null) {
      imageFile = File(pickedImage.path);
      // print(imageFile);
      // print(pickedImage);
    } else {
      print('Not fond image');
    }
    emit(UploadeImage());
  }

  // for bottom vavigation
  int currentPage = 0;
  // list of screen
  List<Widget> screensPage = [
    const NewTaskScreen(),
    const DoneTaskScreen(),
    const ArchiveTaskScreen(),
  ];
  List<String> titleScreen = [
    'New Screen',
    'Done Screen',
    'Archive Screen',
  ];
  //change in the bottom bar
  void changeBottom(int index) {
    currentPage = index;
    emit(AppBottomNabBarChangeState());
  }

  // change in the icon and the ............
  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShowe,
    required IconData icon,
  }) {
    isBottomSheetShow = isShowe;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  //s--------------Database---------------//

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  // initializ the database
  late Database database;
  // create the database
  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('databae created new !!');
        // title ,time ,date , status
        database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT,description TEXT, time TEXT, date TEXT, status TEXT,image VARCHAR)')
            .then((value) {
          print('Table created ');
        }).catchError((error) {
          print('Error when create table :> ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataBase(database);
        print('open database new ??');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseStates());
    });
  }

  // insert in to the database
  insertDataBase({
    required String title,
    required String time,
    required String date,
    required String description,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Tasks(title, description , time ,date, status,image) VALUES("$title","$description","$time","$date","new","${imageFile.toString()}")')
          .then((value) {
        print('Insert saccessfully $value');
        emit(AppInsertDatabaseStates());
        // get the database

        getDataBase(database);
      }).catchError((error) {
        print('Error when create insert new Record :> ${error.toString()}');
      });
    });
  }

  void getDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    // ------------------list of elements-----------------//
    emit(AppGetLoadingDatabaseStates());
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      print(' Data :=> $value');
      value.forEach(
        (element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archiveTasks.add(element);
          }
        },
      );
      emit(AppGetDatabaseStates());
    });
  }

  // updatethe function
  void updateDatabase({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE Tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataBase(database);
      emit(AppUpdateDatabaseStates());
    });
  }

  // to delete fromw database by the id

  void deleteDatabase({required int id}) {
    database.rawDelete(
      'DELETE FROM Tasks WHERE id= ?',
      [id],
    ).then((value) {
      getDataBase(database);
      emit(AppDeleteDatabaseStates());
    });
  }
}
