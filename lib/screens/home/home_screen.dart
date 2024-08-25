
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../itemProfile/item_builder.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    cubit.get(context).getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit,States>(
      listener: (context, state) {
      },
      builder:(context, state) {

    return   Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),

            child: TextFormField(

              onFieldSubmitted: (value) {
                cubit.get(context).searchProducts(value);
              },
              decoration: InputDecoration(
                prefix: Icon(Icons.search_rounded),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintText: "Search...",
              ),


            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: 20,);
              },
              itemCount: cubit.get(context).products.length,
              itemBuilder: (context, index) {
                return ItemBuilder(

                  id:cubit.get(context).products[index].id,
                  imageUrl: cubit.get(context).products[index].coverImage,
                  price: cubit.get(context).products[index].price,
                  title: cubit.get(context).products[index].title,
                  index: index,

                );
              },
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}
