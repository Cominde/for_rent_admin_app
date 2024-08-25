
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liliijar_system/generated/assets.dart';
import 'package:liliijar_system/layout/bottom_navbar_custom.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../screens/requests/requests.dart';

class Layout extends StatefulWidget {
  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {

  @override
  void initState() {
    cubit.get(context).getRequestsLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<cubit,States>(
        listener: (context, state) {
        },
        builder:(context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      if(cubit.get(context).requestsLength > 0) IgnorePointer(
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent,
                                blurRadius: 4
                              )
                            ]
                          ),
                        ),
                      ),
                      IconButton(onPressed: () {

                        Navigator.push(context, DialogRoute(context: context, builder: (context) => Requests(),));
                      }, icon: Icon(Icons.notifications_active_rounded)),
                    ],
                  ),
                )
              ],
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Align(alignment: Alignment.topLeft, child: Text(
                      'Powered By',
                      style: TextStyle(color: Colors.grey, fontSize: 8),
                    ),),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => launchUrl(Uri.parse('https://cominde.onrender.com')),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(Assets.assetsIcon512),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Admin!',
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              'Add items to be available for rent',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: cubit.get(context).screens[cubit.get(context).screenIndex],

            bottomNavigationBar: BottomNavbarCustom(
              onChangePage: (c) {
                cubit.get(context).setNewState(() {
                  cubit.get(context).screenIndex=c;
                },);
              },
              startIndex: cubit.get(context).screenIndex,
              items: [
                NavigationBarItemCustom(
                    selectedChild: Icon(
                      Icons.home_rounded,
                      color: Colors.green,
                      size: 30,
                    ),
                    unselectedChild: Icon(
                      Icons.home_outlined,
                      color: Colors.grey.withAlpha(60),
                      size: 30,
                    )
                ),
                NavigationBarItemCustom(
                    selectedChild: Icon(
                      Icons.category,
                      color: Colors.green,
                      size: 30,
                    ),
                    unselectedChild: Icon(
                      Icons.category_outlined,
                      color: Colors.grey.withAlpha(60),
                      size: 30,
                    )
                ),
                NavigationBarItemCustom(
                  selectedChild: Icon(
                    Icons.add_business,
                    color: Colors.green,
                    size: 30,
                  ),
                  unselectedChild: Icon(
                    Icons.add_business_outlined,
                    color: Colors.grey.withAlpha(60),
                    size: 30,
                  )
                ),
              ],
            )
          );
        },
    );


  }
}
