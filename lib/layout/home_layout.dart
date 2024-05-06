// ignore_for_file: must_be_immutable, avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:todo_list/constant/constant_screen.dart';
import 'package:todo_list/cubit/app_cubit.dart';
import 'package:todo_list/cubit/app_states.dart';

class HomeLayout extends StatelessWidget {
  //

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({super.key});

  //
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          var imageCubit = AppCubit.get(context).imageFile;
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                LocalizeAndTranslate.translate('appTitle'),
                style: const TextStyle(color: Colors.white),
                //cubit.titleScreen[cubit.currentPage],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  // insert in the database
                  if (formKey.currentState!.validate()) {
                    cubit.insertDataBase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                      description: descriptionController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[100],
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // for addres
                                    TextFormField(
                                      controller: titleController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText:
                                            LocalizeAndTranslate.translate(
                                                "title-new"),
                                        prefixIcon:
                                            const Icon(Icons.text_fields),
                                        border: const OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return LocalizeAndTranslate.translate(
                                              "not-Field");
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10.0),
                                    // for description
                                    TextFormField(
                                      controller: descriptionController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText:
                                            LocalizeAndTranslate.translate(
                                                "description-new"),
                                        prefixIcon:
                                            const Icon(Icons.text_fields),
                                        border: const OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return LocalizeAndTranslate.translate(
                                              "not-Field");
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10.0),
                                    // for time
                                    TextFormField(
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                          print(value.format(context));
                                        });
                                      },
                                      controller: timeController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        labelText:
                                            LocalizeAndTranslate.translate(
                                                "Time-new"),
                                        prefixIcon: const Icon(
                                            Icons.timelapse_outlined),
                                        border: const OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return LocalizeAndTranslate.translate(
                                              "not-Field");
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10.0),
                                    // for date
                                    TextFormField(
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2010),
                                          lastDate: DateTime(2025),
                                        ).then((value) {
                                          // علشان تقدر تعمل فورمات للتاريخ هتنزل مكتبه تانيه
                                          // intel
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      },
                                      controller: dateController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        labelText:
                                            LocalizeAndTranslate.translate(
                                                "Date-new"),
                                        prefixIcon: const Icon(
                                          Icons.calendar_today_rounded,
                                        ),
                                        border: const OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return LocalizeAndTranslate.translate(
                                              "not-Field");
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: Text(
                                              LocalizeAndTranslate.translate(
                                                  "chooseImage")),
                                          content: SizedBox(
                                            height: 150.0,
                                            child: Column(
                                              children: [
                                                const Divider(
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(height: 10.0),
                                                Container(
                                                  width: 300.0,
                                                  color: color3,
                                                  child: ListTile(
                                                    leading: const Icon(
                                                      Icons.image,
                                                      color: color1,
                                                    ),
                                                    title: Text(
                                                      LocalizeAndTranslate
                                                          .translate(
                                                        "ImageGallery",
                                                      ),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17.0,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      cubit.getImage(
                                                          ImageSource.gallery);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 10.0),
                                                Container(
                                                  width: 300.0,
                                                  color: color3,
                                                  child: ListTile(
                                                    leading: const Icon(
                                                      Icons.camera_alt,
                                                      color: color1,
                                                    ),
                                                    title: Text(
                                                      LocalizeAndTranslate
                                                          .translate(
                                                              "ImageCamera"),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17.0,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      cubit.getImage(
                                                          ImageSource.camera);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(LocalizeAndTranslate
                                                  .translate("canselAdd")),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 110.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: color2,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        LocalizeAndTranslate.translate(
                                            "addImage"),
                                        style: const TextStyle(
                                          color: color1,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  // for image
                                  if (imageCubit != null)
                                    Container(
                                      width: 100.0,
                                      height: 90.0,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: FileImage(imageCubit),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  // when image == null
                                  if (imageCubit == null)
                                    Container(
                                      width: 100.0,
                                      height: 90.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Not Found',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                      isShowe: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetState(
                    isShowe: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
                color: Colors.white,
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetLoadingDatabaseStates,
              builder: (context) => cubit.screensPage[cubit.currentPage],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentPage,
              elevation: 0.0,
              onTap: (index) {
                cubit.changeBottom(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tackes',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archive',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
