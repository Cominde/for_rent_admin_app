
import 'package:flutter/material.dart';
import 'package:liliijar_system/models/category_model.dart';

import '../../cubit/cubit.dart';
import '../../db/db.dart';


  final _formKey = GlobalKey<FormState>();

  var categoryTitleController = TextEditingController();


  Widget categoryFunctions (BuildContext context,String function,{CategoryModel? model}) {
    if (function=='Update')
      {
        categoryTitleController=TextEditingController(text: model?.title);
      }
    return AlertDialog(

      title: Row(
        children: [
          Expanded(child: SizedBox()),
          Text("${function} category"),
          Expanded(child: Align(alignment: Alignment.centerRight, child: IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(context),
          ),))
        ],
      ),
      actions:[ Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*0.7,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: categoryTitleController,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),

                      ),

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter category name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Add product to database or API call
                if(function=='Add'){
                  cubit.get(context).addCategory(categoryTitleController.text);
                  Navigator.pop(context);

                }
                else if(function=='Update'){
                  cubit.get(context).editCategory(int.parse(model!.id!),categoryTitleController.text);
                  Navigator.pop(context);

                }
            }
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                '${function} Category',
                style: TextStyle(color: Colors.white),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),]
    );
  }

