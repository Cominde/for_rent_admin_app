
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liliijar_system/screens/requests/request_item_builder.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class Requests extends StatefulWidget {
  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  @override
  void initState()  {
    super.initState();
    cubit.get(context).getRequests();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<cubit,States>(
      listener: (context, state) {
        // print(state.toString());
      },
      builder:(context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text('Requests'),
            centerTitle: true,
            ),


          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 50,);
                    },
                    itemCount: cubit.get(context).requests.length,
                    itemBuilder: (context, index) {
                      return requestItemBuilder(cubit.get(context).requests[index],context);
                    },
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
