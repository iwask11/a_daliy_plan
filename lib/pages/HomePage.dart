import 'package:a_daliy_plan/custom/circleProgressIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final Widget list_svg = SvgPicture.asset('image/svg/align-justify.svg',);
  late double valued;
  int endTask = 0;
  int allTask = 0;
  late bool isend;
  late List _taskList;

  void initState(){
    super.initState();
    _taskList = [
      {"text": "文本1" ,"isend": true},
      {"text": "文本2" ,"isend": true},
      {"text": "文本3" ,"isend": true},
      {"text": "文本4" ,"isend": true},
      {"text": "文本5" ,"isend": true},
      {"text": "文本6" ,"isend": false},
      {"text": "文本7" ,"isend": false},
      {"text": "文本8" ,"isend": false},
      {"text": "文本9" ,"isend": false},
      {"text": "文本10" ,"isend": false},
      {"text": "文本11" ,"isend": false},
      {"text": "文本12" ,"isend": false},
    ];

    for(int i= 0;i<_taskList.length;i++){
      if(_taskList[i]['isend']!=null && _taskList[i]['isend'] == true){
        endTask++;
      }else{
        print("00");
      }
    }

    allTask = _taskList.length;
    valued = (endTask/allTask);
   }

  void dispose() {
    super.dispose();
  }

  ///app头部按键组件
  Widget topContainer(){
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.h,),
            alignment: Alignment.topLeft,
            child: SizedBox(child: list_svg,width: 75.w,height: 75.w),
          ),
          const Icon(Icons.add,),
        ],
      )
    );
  }

  ///卡片任务标题
  Widget CardTitle(){
    return Text.rich(
        TextSpan(
          text: "今天",
          style: TextStyle(
            color: Colors.black,
            fontSize: 44.sp,
          ),
          children:<TextSpan>[
            TextSpan(text: "  任务完成度",
                style: TextStyle(
                  color:const Color(0xFF707070),
                  fontSize: 30.sp,
                )
            )],
        )
    );
  }

  ///圆形进度条样式显示器
  Widget CicleProgressStyle(){
    int value = (valued*100).round();
    return Container(
      child: Stack(
        alignment:Alignment.center,
        children: <Widget>[
          Text(value.toString(), style: TextStyle(fontSize: 80.sp),),
          Positioned(
              child: CircleProgressIndicator(
                ringColors: [Colors.black, Colors.black],
                ringRadius: 270.w,
                strokeWidth: 46.w,
                dotRadius: 42.w,
                dotColors: [Colors.black54, Colors.black87],
                value: valued,
                progressChanged: (v) {
                  setState(() {
                    valued = v;
                    int end = (allTask*value)~/100;
                    for(int i= 0;i<allTask;i++){
                      for(int j= 0;j<=end;j++){
                        if(_taskList[j]['isend'] == false){
                          _taskList[j]['isend'] = true;
                        }else{
                          print("00zz11");
                          continue;
                        }
                      }
                      _taskList[i]['isend'] = false;
                    }
                  });
                },
              )
          ),
        ],
      ),
    );
  }

  ///清单待办事项
  Widget TaskBoardStyle(){
    return Column(
      children: [
        /// 任务列表标题
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 60.w, bottom: 20.h),
                child: Text("任务列表",style: TextStyle(
                    fontSize: 38.sp, fontWeight: FontWeight.w500),),
              ),
            ]
        ),
        /// 任务文本
        Container(
            height: 340.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 1
                ),
                borderRadius: BorderRadius.circular(20.r)
            ),
            margin: EdgeInsets.symmetric(horizontal: 30.h),
            child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 5.w),
                itemCount: _taskList.length,
                itemBuilder: (index, item){
                  return ListTile(
                      leading: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(top: 10.h,right: 30.w),
                          child: _taskList[item]["isend"] == true ? Icon(Icons.check_circle_outline,size: 42.sp,)
                              : Icon(Icons.radio_button_unchecked_outlined,
                            size: 42.sp,
                            color: const Color(0xff000000),
                          ),
                        ),
                        onTap: (){
                          print("图标变化，文本样式变化,值变化");
                          setState(() {
                            print("_taskList[item]['isend']::"+_taskList[item]["isend"].toString());
                            _taskList[item]["isend"] == false
                                ? _taskList[item]["isend"] = true
                                : _taskList[item]["isend"] = false;
                            print("_taskList[item]['isend']::"+_taskList[item]["isend"].toString());
                          });
                        },
                      ),
                      title: _taskList[item]["isend"] == true ? Transform(
                          transform: Matrix4.translationValues(-58.w, 5.h, 0.0),
                          child:  Text(" "+_taskList[item]["text"].toString()+"    ",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: const Color(0xff757575),
                                decorationThickness: 1.4,)),)
                          : Transform(
                          transform: Matrix4.translationValues(-55.w, 5.h, 0.0),
                          child: Text(_taskList[item]["text"].toString(),
                            style: TextStyle(
                                color: const Color(0xff000000),
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w400),
                          ))
                  );
                })
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget space50h = SizedBox(height: 50.h,);
    final Widget space80h = SizedBox(height: 80.h,);
    final Widget space40h = SizedBox(height: 40.h,);
    final Widget spaceBox20 = SizedBox(height: 20.h,);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              topContainer(),
              space50h,
              ///title for task
              CardTitle(),
              space40h,
              ///progress bar, task's progress
              CicleProgressStyle(),
              space80h,
              TaskBoardStyle(),
            ],
          ),
        )
      ),
    );
  }
}