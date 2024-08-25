import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liliijar_system/models/category_model.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../../db/db.dart';
import '../../models/product_model.dart';

class AddNewItem extends StatefulWidget {
  @override
  _AddNewItemState createState() => _AddNewItemState();


}

class _AddNewItemState extends State<AddNewItem> {

  @override
  void initState() {
    super.initState();
    cubit.get(context).images.clear();
    cubit.get(context).getCategories();




  }

  final _formKey = GlobalKey<FormState>();

  var productTitleController = TextEditingController();
  var productDescriptionController = TextEditingController();
  var productPriceController = TextEditingController();
  var productTermsController = TextEditingController();
  var productCategoryIDController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit, States>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Item Data',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: productTitleController,
                        decoration: InputDecoration(
                          labelText: '* Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter item name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: productDescriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,

                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: productPriceController,
                        decoration: InputDecoration(
                          labelText: '* Price For A Day',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter item price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: productTermsController,
                        decoration: InputDecoration(
                          labelText: 'Terms',
                          border: OutlineInputBorder(),
                        ),

                      ),
                      SizedBox(height: 20),

                      DropdownButtonFormField<CategoryModel>(
                        items: cubit.get(context).categories.map<DropdownMenuItem<CategoryModel>>(
                                (value) {
                              return DropdownMenuItem<CategoryModel>(
                                value: value,
                                child: Text(value.title??''),
                              );
                            }).toList(),
                       // decoration:,
                       // style: ,
                        validator: (value) {
                          if (value == null) {
                            return 'please choose the category';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          productCategoryIDController.text = '${value?.id??''}';
                        },
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: '* Category',
                          border: OutlineInputBorder(),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '* is required',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Item Images',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: cubit.get(context).images.length + 1,
                  itemBuilder: (context, index) {
                    if(index < cubit.get(context).images.length) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(cubit.get(context).images[index]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent.shade200.withOpacity(0.4),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.redAccent,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                cubit.get(context).images.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: cubit.get(context).pickImages,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.green.shade100
                          ),
                          child: Center(
                            child: ConditionalBuilder(
                              condition:
                              state is ImagePickLoading,
                              builder: (context) {
                                // print(state);
                                return CircularProgressIndicator();
                              },
                              fallback: (context) {
                                return Icon(
                                  Icons.add_rounded,
                                  size: 50,
                                  color: Colors.green,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                cubit.get(context).loading ? CircularProgressIndicator() : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Add product to database or API call


                      cubit.get(context).addProduct(ProductModel(
                          title: productTitleController.text,
                          coverImage: cubit.get(context).images.first,
                          description: productDescriptionController.text,
                          images: cubit.get(context).images,
                          price: int.parse(productPriceController.text),
                          occupied: [],
                          terms: productTermsController.text,
                          categoryID: productCategoryIDController.text

                      ));

                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Add Product',
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
            ),
          ),
        );
      },
    );
  }
}
