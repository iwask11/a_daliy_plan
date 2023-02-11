import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../custom/circleProgressIndicator.dart';

class taskWidget extends StatefulWidget {
  const taskWidget({Key? key}) : super(key: key);

  @override
  State<taskWidget> createState() => _taskWidgetState();
}

class _taskWidgetState extends State<taskWidget> {
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
    allTask = _taskList.length;
    if(endTask != 0){endTask = 0;}
    for(int i= 0;i<_taskList.length;i++){
      if(_taskList[i]['isend']!=null && _taskList[i]['isend'] == true){
        endTask++;
      }else{
        print("00");
      }
    }
    valued = (endTask/allTask);
    print("valued1::${valued}");
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget space50h = SizedBox(height: 50.h,);
    final Widget space80h = SizedBox(height: 80.h,);
    final Widget space40h = SizedBox(height: 40.h,);
    final Widget space20h = SizedBox(height: 20.h,);

    return Card(
      // color: Colors.deepPurple.shade100,
      child: Column(
        children: [
          space80h,
          space80h,
          ///title for task
          CardTitle(),
          space40h,
          ///progress bar, task's progress
          CicleProgressStyle(valued),
          space80h,
          TaskBoardStyle(),
        ],
      ),
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
  Widget CicleProgressStyle(double valued){
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
                    print("end:${end}");
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
                            _taskList[item]["isend"] == false
                                ? _taskList[item]["isend"] = true
                                : _taskList[item]["isend"] = false;

                            if(endTask != 0){endTask = 0;}
                            for(int i= 0;i<_taskList.length;i++){
                              if(_taskList[i]['isend']!=null && _taskList[i]['isend'] == true){
                                endTask++;
                              }else{
                                print("00");
                              }
                            }
                            valued = (endTask/allTask);
                            print("valued12::${valued}");
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
}
