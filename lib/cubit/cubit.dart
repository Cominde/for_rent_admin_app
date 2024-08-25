import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liliijar_system/models/request_model.dart';
import 'package:toastification/toastification.dart';
import '../../cubit/states.dart';
import '../../db/db.dart';
import '../../screens/add_new_item/add_new_item.dart';
import '../../screens/home/home_screen.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../screens/categories/Categories_Screen.dart';
import 'package:http/http.dart' as http;
class cubit extends Cubit<States>{
  cubit(): super(InitialState()) ;
  static cubit get(context)=>BlocProvider.of(context);

  List<String> images = [];
  final picker = ImagePicker();

  bool loading = false;

  int screenIndex=0;
  List<Widget> screens=[
    HomeScreen(),

    Categories(),
    AddNewItem(),
  ];

  List<CategoryModel>categories=[];
  List<ProductModel>products=[];
  List<RequestModel>requests=[];
  int requestsLength = 0;
  ProductModel product=ProductModel();




  void pickImages() async {

    emit(ImagePickLoading());

    final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {

          pickedFiles.map((pickedFile) => File(pickedFile.path))
            .forEach((img) async {

              await uploadImage(img);

              emit(ImagePickSuccess());
          });

      } else {

        emit(ImagePickFailed());
      }

  }

  Future getCategories()async{
    emit(GetCategoriesLoading());
    categories.clear();
    try
    {
      var data = await dbGetAll(modelName: 'categories');
      await data.forEach((item) => {
            categories.add(CategoryModel.fromJson(item)),
          });
      emit(GetCategoriesSuccess());
    }
    catch(err){
      emit(GetCategoriesFailed());
    }
    return ;
  }

  Future<void> getProducts()async{
    products.clear();
    emit(GetProductsLoading());
    // print('ya mosahel');
    try{
      var data = await dbGetAll(
          modelName: "products", columns: 'id,title,price,coverImage');
      await data.forEach((item) {
        products.add(ProductModel.fromJson(item));
      });

      // print('done');
    }
    catch(err){
      emit(GetProductsFailed());
     // print('a7a');
      // print (err.toString());
    }

    emit(GetProductsSuccess());
  }

  Future<void> getProduct(int id)async{
     product=ProductModel();
    emit(GetProductLoading());
   // print('ya mosahel');
    try{
      var data = await dbGetOne(
          modelName: "products", id:id );
        product= ProductModel.fromJson(data);
        // print(product.title);
    }
    catch(err){
      emit(GetProductFailed());
      // print('a7a');
      // print (err.toString());
    }


    emit(GetProductSuccess());
  }

  Future searchProducts(String searchQuery)async{
    emit(SearchProductsLoading());
    products.clear();
    try
    {
      var data = await dbSearch(modelName: 'products', searchQuery: searchQuery,columns: 'id,title,price,coverImage');
      await data.forEach((item) {
        products.add(ProductModel.fromJson(item));
      });
      // print(data);
      emit(SearchProductsSuccess());
    }
    catch(err){
      emit(SearchProductsFailed());
    }
    return ;
  }

  Future<void> addCategory(String title) async {

    loading = true;
   emit(AddCategoryLoading());
   try {
      var data = await dbInsert('categories', {
        "title": title,
      });
      loading = false;
      toastification.show(
        title: Text('New category added successfully'),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
      );
       categories.add(CategoryModel.fromJson(data[0]));
      // print(categories.last.title.toString());
      emit(AddCategorySuccess());
   }
   catch(err){
     loading = false;
     // print (err);
     emit(AddCategoryFailed());
   }

  }
  Future<void> addProduct(ProductModel model) async {
    loading = true;

   emit(AddProductLoading());
   try {
      var data = await dbInsert('products', model.toMap());

      loading = false;
      toastification.show(
        title: Text('New item added successfully'),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
      );
      screenIndex = 0;
      emit(AddProductSuccess());

      //await reload();
   }
   catch(err){
     loading = false;
     // print (err);
     emit(AddProductFailed());
   }

  }

  Future<void> editCategory(int id,String title) async {

   emit(EditCategoryLoading());
   try {
      var data = await dbUpdate(
          modelName: 'categories',
          updates:  {
            "title": title,
          },
          id: id
      );

      toastification.show(
        title: Text('Category edited successfully'),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
      );
      emit(EditCategorySuccess());

      await reload();
   }
   catch(err){
     // print (err);
     emit(EditCategoryFailed());
   }

  }

  Future<void> getRequests() async{
    // print('ya mosahel');
    requests.clear();
    emit(GetRequestsLoading());
    try {
       await dbGetAll(modelName: "requests", ).then((data) async {
          data.forEach((item)   async {
           var request=RequestModel.fromJson(item);

           await dbGetOne(modelName: 'products', id: request.productID!,columns: 'title')
               .then((onValue){
             request.productName=onValue['title'];
             requests.add(request);
           });

           emit(GetRequestsSuccess());
         });
       }

    );



      // print('done');


    }
    catch(err){
      emit(GetRequestsFailed());
      // print('a7a');
      // print (err.toString());
    }
    
  }

  Future<void> getRequestsLength() async{
    // print('ya mosahel');
    requestsLength = 0;
    emit(GetRequestsLengthLoading());
    try {
      await dbGetAll(modelName: "requests", ).then((data) async {
        // print(data.length);
        requestsLength = data.length;
        emit(GetRequestsLengthSuccess());
      }

      );



      // print('done');


    }
    catch(err){
      emit(GetRequestsFailed());
      // print('a7a');
      // print (err.toString());
    }

  }

  Future<void> confirmRequest(RequestModel model) async {
    emit(ConfirmRequestsLoading());
    try{
      var data = await dbGetOne(modelName: 'products', id: model.productID!);
      var requestProduct = ProductModel.fromJson(data);
      model.days.forEach((item){
        requestProduct.occupied.add(DateTime.parse(item));
      });
      data = await dbUpdate(
          modelName: 'products',
          id: requestProduct.id!,
          updates: requestProduct.toMap());
      await dbDeleteItem(modelName: 'requests', id: model.id!)
          .then((onValue){

          });

      toastification.show(
        title: Text('Request confirmed'),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
      );
    emit(ConfirmRequestsSuccess());

    await reload();
    }
    catch(err){
      // print (err);
      emit(ConfirmRequestsFailed());

    }

  }

  Future<void> uploadImage(imageFile)
  async {
   try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Create POST request
      final response = await http.post(
        Uri.parse(
            'https://api.imgbb.com/1/upload?key=69b37913be03c5785235757de05f1099'),
        body: {
          'image': base64Image,
        },
      ).then((onValue){
        if(onValue.statusCode==200) {
          // print('shagalaa');
          // print(jsonDecode(onValue.body)['data']['display_url']);

          images.add(jsonDecode(onValue.body)['data']['display_url']);
        }
      });
    }
    catch(err){
     // print ('bazet khales');
     // print (err.toString());
    }
  }

  Future<void> reload () async {
    categories.clear();
    products.clear();
    requests.clear();
    requestsLength = 0;

    await getCategories();
    await getProducts();
    await getRequests();
    await getRequestsLength();
  }

  Future<void> setNewState (Function() fun) async {
    fun();
    emit(NewState());
  }

}
