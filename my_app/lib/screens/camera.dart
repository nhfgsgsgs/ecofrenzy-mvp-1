import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_app/models/challenge.dart';
import 'package:my_app/service/challenge_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../providers/challenge_notifier.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.fromLTRB(15, 52, 15, 30),
      width:  double.infinity,
      decoration:  BoxDecoration (
        color:  Colors.black,
      ),
      child:  
        Column(
          crossAxisAlignment:  CrossAxisAlignment.center,
          children:[
            //Camera Space
            Container(
              margin:  EdgeInsets.only(bottom: 15),
              width:  double.infinity,
              height:  547,
              decoration:  BoxDecoration (
                color:  Color(0xffffffff),
                borderRadius:  BorderRadius.circular(30),
              ),
              child: Align(alignment: Alignment.center, child: Text('Camera')),
            ),
            Container(
              margin:  EdgeInsets.only(bottom: 18),
              padding:  EdgeInsets.fromLTRB(20, 11, 91, 11),
              width:  double.infinity,
              height:  82,
              decoration:  BoxDecoration (
                borderRadius:  BorderRadius.circular(25),
                //change to gradient
                color: Colors.white,
                boxShadow:  [
                  BoxShadow(
                    color:  Color(0x19000000),
                    offset:  Offset(0, 0),
                    blurRadius:  0,
                  ),
                  BoxShadow(
                    color:  Color(0x19000000),
                    offset:  Offset(0, 2),
                    blurRadius:  2,
                  ),
                  BoxShadow(
                    color:  Color(0x16000000),
                    offset:  Offset(0, 8),
                    blurRadius:  4,
                  ),
                  BoxShadow(
                    color:  Color(0x0c000000),
                    offset:  Offset(0, 18),
                    blurRadius:  5.5,
                  ),
                  BoxShadow(
                    color:  Color(0x02000000),
                    offset:  Offset(0, 33),
                    blurRadius:  6.5,
                  ),
                  BoxShadow(
                    color:  Color(0x00000000),
                    offset:  Offset(0, 51),
                    blurRadius:  7,
                  ),
                ],
              ),
              child:  
                Row(
                  crossAxisAlignment:  CrossAxisAlignment.center,
                  children:[
                    Container(
                      margin:  EdgeInsets.only(right: 17),
                      padding:  EdgeInsets.fromLTRB(6, 9, 7, 10),
                      height:  double.infinity,
                      decoration:  BoxDecoration (
                        color:  Color(0xffffffff),
                        borderRadius:  BorderRadius.circular(50),
                      ),


                      // Icon of chosen Challenge
                      // child: Center(
                      //     child: SizedBox(
                      //         width: 47,
                      //         height: 41,
                      //         child: Image.asset(
                      //           getIcon(challenge.category),
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //   ),



                    ),

                    // Challenge Name and Category
                    // Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             challenge.name,
                    //             style: const TextStyle(
                    //                 fontSize: 21,
                    //                 color: Colors.white,
                    //                 fontFamily: "Ridley Grotesk",
                    //                 fontWeight: FontWeight.bold),
                    //           ),
                    //           Text(
                    //             challenge.category,
                    //             style: const TextStyle(
                    //                 fontSize: 13,
                    //                 color: Colors.white,
                    //                 fontFamily: "Ridley Grotesk"),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                  ],
                ),
            ),
            Container(
              margin:  EdgeInsets.fromLTRB(21.01, 0, 26, 0),
              width:  double.infinity,
              child:  
                Row(
                  crossAxisAlignment:  CrossAxisAlignment.center,
                  children:  [
                    Container(
                      margin:  EdgeInsets.fromLTRB(0, 0, 67.99, 18),
                      width:  41,
                      height:  36.75,
                      child: Image.asset(
                        'assets/images/library.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin:  EdgeInsets.only(right: 68),
                      width:  100,
                      height:  100,
                      child: Image.asset(
                          "assets/images/capture.png",
                          width:  100,
                          height:  100,
                        ),
                    ),
                    Container(
                      margin:  EdgeInsets.only(bottom: 23),
                      width:  36,
                      height:  41,
                      child: Image.asset(
                          "assets/images/lightoff.png",
                          width:  36,
                          height:  41,
                        ),
                    ),
                  ],
                ),
              ),
            ],
        ),
        );
  }
}