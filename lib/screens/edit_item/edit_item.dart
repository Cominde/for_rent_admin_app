import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../../db/db.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../shared/custom_calender_2.dart';
import '../../shared/custom_calender_widget.dart';

class EditItem extends StatefulWidget {
  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  var productTitleController = TextEditingController();
  var productDescriptionController = TextEditingController();
  var productPriceController = TextEditingController();
  var productTermsController = TextEditingController();
  var productCategoryIDController = TextEditingController();

  List<Widget> occupiedDays = [];

  @override
  void initState() {
    super.initState();


    cubit.get(context).getCategories();
    cubit.get(context).images.clear();

    productTitleController =
        TextEditingController(text: cubit.get(context).product.title);
    productDescriptionController =
        TextEditingController(text: cubit.get(context).product.description);
    productPriceController =
        TextEditingController(text: '${cubit.get(context).product.price}');
    productTermsController =
        TextEditingController(text: cubit.get(context).product.terms);
    productCategoryIDController =
        TextEditingController(text: cubit.get(context).product.categoryID.toString());


    cubit.get(context).product.occupied.forEach((day){
      occupiedDays.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter day date',
              border: OutlineInputBorder(),
            ),
          initialValue: "${day.day}-${day.month}-${day.year}"
        ),
      ));
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit, States>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: productTitleController,
                          decoration: InputDecoration(
                            labelText: 'Product Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: productDescriptionController,
                          decoration: InputDecoration(
                            labelText: 'Product Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: productPriceController,
                          decoration: InputDecoration(
                            labelText: 'Product Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product price';
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
                            labelText: 'Product Terms',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product terms';
                            }
                            return null;
                          },
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



                          onChanged: (value) {
                            productCategoryIDController.text = '${value?.id??''}';
                          },
                          autofocus: false,
                        ),

                        SizedBox(height: 20),




                      ],
                    ),
                  ),
                ),
            GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: cubit.get(context).product.images.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(cubit.get(context).product.images[index]),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                );
              },
            ),
                ElevatedButton(
                  onPressed: cubit.get(context).pickImages,
                  child: Text(
                    'Pick Imaged',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ConditionalBuilder(
                  condition:
                  state is ImagePickLoading || state is ImagePickFailed,
                  builder: (context) {
                    return Center(child: CircularProgressIndicator());
                  },
                  fallback: (context) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: cubit.get(context).images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(cubit.get(context).images[index]),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Add product to database or API call

                      dbUpdate(
                          modelName: 'products',
                          id: cubit.get(context).product.id!,
                          updates: ProductModel(
                            title: productTitleController.text,
                            coverImage: cubit.get(context).product.images.first,
                            description: productDescriptionController.text,
                            images: cubit.get(context).product.images+cubit.get(context).images,
                            price: int.parse(productPriceController.text),
                            occupied: cubit.get(context).product.occupied,
                            terms: productTermsController.text,
                            categoryID: productCategoryIDController.text
                          ).toMap(),
                      ).then((onValue){

                        cubit.get(context).product=ProductModel.fromJson(onValue[0]);
                        toastification.show(
                          title: Text('Item edited successfully'),
                          autoCloseDuration: const Duration(seconds: 5),
                          type: ToastificationType.success,
                          style: ToastificationStyle.flatColored,
                        );
                        Navigator.pop(context);

                      });

                    }
                  },
                  child: Text(
                    'Update Product',
                    style: TextStyle(color: Colors.white),
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
