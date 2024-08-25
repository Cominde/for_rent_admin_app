// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liliijar_system/cubit/cubit.dart';
import 'package:liliijar_system/db/db.dart';
import 'package:toastification/toastification.dart';

import '../../models/request_model.dart';

Widget requestItemBuilder(RequestModel model,context)  {

  var product;
  product= dbGetOne(modelName: 'categories', id: model.id!);
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),border: Border.all(color: Colors.grey,width: 2)),

    height: 200,
    padding: EdgeInsets.all(16),
    child: Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text('Name: ${model.name??''}',style:  TextStyle(fontWeight: FontWeight.w700,fontSize: 15,letterSpacing: 1),),
        Text('Phone: ${model.phone??''}',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15,letterSpacing: 1),),

        Text('Product: ${model.productName}',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15,letterSpacing: 1,overflow: TextOverflow.ellipsis),maxLines: 1,overflow: TextOverflow.ellipsis,),
        SizedBox(width: MediaQuery.of(context).size.width*0.83,child: AutoSizeText('Days: ${model.days.toString().replaceAll('[', '').replaceAll(']', '')}',style: TextStyle(fontWeight: FontWeight.w700,letterSpacing: 1),maxLines: 2, maxFontSize: 15, minFontSize: 10, overflow: TextOverflow.ellipsis,)),
        Spacer(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () {
              dbDeleteItem(modelName: 'requests', id: model.id!);
              toastification.show(
                title: Text('Request deleted'),
                autoCloseDuration: const Duration(seconds: 5),
                type: ToastificationType.error,
                style: ToastificationStyle.flatColored,
              );

            }, child: Row(
              children: [
                Icon(Icons.not_interested,color: Colors.red,),
                Text(' Cancel',style: TextStyle(color: Colors.red),),
              ],
            )),
            SizedBox(width: 10,),
            ElevatedButton(onPressed: () {

              cubit.get(context).confirmRequest(model);
            }, child: Row(
              children: [
                Icon(Icons.schedule_send,color: Colors.green,),
                Text(' Confirm',style: TextStyle(color: Colors.green),),
              ],
            )),
          ],
        )
      ],
    ),
  );
}