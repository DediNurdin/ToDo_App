import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constant/constant_screen.dart';

class UpdateScreen extends StatelessWidget {
  final dynamic model;
  const UpdateScreen({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    String nwImage = '';
    String nnnn = '';
    if (model['image'] != null) {
      nwImage = model['image'];
      nnnn = nwImage.substring(8, nwImage.length - 1);
      if (kDebugMode) {
        print("After remove ==> $nnnn");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${model['title']}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.archive_outlined),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 300.0,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(23),
                bottomRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: FileImage(File(nnnn)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 40.0,
              //color: Colors.yellow,
              child: Text(
                '${model['title']}',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              height: 260.0,
              // color: Colors.green,
              child: Text(
                '${model['description']},',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: color4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.date_range_rounded,
                      color: color1,
                    ),
                    // the time and the date
                    Text(
                      '${model['time']}' '  ${model['date']}',
                      style: const TextStyle(
                        color: color1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
