import 'package:a_daliy_plan/widgets/pageViewWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/taskWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  ///app头部按键组件
  Widget topContainer(){
    return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const Icon(Icons.menu, size: 32,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const Icon(Icons.add, size: 32,),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment:Alignment.center,
          children: [
            pageViewWidget(),
            Positioned(
                top: 20.h,
                child:topContainer(),
            ),
          ],
        ),
      ),
    );
  }
}