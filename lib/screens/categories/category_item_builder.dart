import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liliijar_system/db/db.dart';
import 'package:liliijar_system/models/category_model.dart';
import 'package:liliijar_system/models/product_model.dart';
import 'package:liliijar_system/models/request_model.dart';
import 'package:liliijar_system/screens/add_new_item/add_new_item.dart';
import 'package:liliijar_system/screens/categories/category_functions.dart';

import '../../cubit/cubit.dart';

Widget categoryItemBuilder(CategoryModel model,context,index)
{
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),border: Border.all(color: Colors.grey,width: 2)),

      height: 60,

      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Text(model.title??'',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,),maxLines: 1,overflow:TextOverflow.ellipsis ,),
          Spacer(),
          ElevatedButton.icon(onPressed: () {
            showDialog(context: context, builder: (context) => categoryFunctions(context, 'Update', model: model,));

          }, label: Icon(Icons.edit)),
          SizedBox(width: 10,),
          ElevatedButton.icon(onPressed: () async {

            dbDeleteItem(modelName: 'categories', id: int.parse(model.id!));
            List<ProductModel> items = [];
            var data = await supabase
                .from("products")
                .select("id")
                .eq('categoryID', model.id!);
            await data.forEach((item) {
              items.add(ProductModel.fromJson(item));
            });

            items.forEach((item) async {
              dbDeleteItem(modelName: 'products', id: item.id!);

              List<RequestModel> requests = [];
              var data = await supabase
                  .from("requests")
                  .select("id")
                  .eq('productID', item.id!);
              await data.forEach((item) {
                requests.add(RequestModel.fromJson(item));
              });

              requests.forEach((req) => dbDeleteItem(modelName: 'requests', id: req.id!),);
            });

            cubit.get(context).setNewState(() {
              cubit.get(context).categories.removeAt(index);
            },);
          }, label: Icon(Icons.delete)),
        ],
      ),
    ),
  );
}