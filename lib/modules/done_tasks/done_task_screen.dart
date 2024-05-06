import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../update_screen.dart';

import '../../constant/model_screen.dart';
import '../../cubit/app_cubit.dart';
import '../../cubit/app_states.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInsertDatabaseStates) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        List task = AppCubit.get(context).doneTasks;
        return ConditionalBuilder(
          condition: task.isNotEmpty,
          fallback: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.menu_open_outlined,
                  size: 60.0,
                  color: Colors.grey,
                ),
                Text(
                  LocalizeAndTranslate.translate('notTasks'),
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateScreen(
                      model: task[index],
                    ),
                  ),
                );
              },
              child: builedtItem(
                task[index],
                context,
              ),
            ),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20.0,
                end: 20.0,
              ),
              child: Container(
                height: 1.0,
                color: Colors.black45,
                width: double.infinity,
              ),
            ),
            itemCount: task.length,
          ),
        );
      },
    );
  }
}
