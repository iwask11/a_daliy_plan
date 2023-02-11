import 'package:a_daliy_plan/widgets/taskWidget.dart';
import 'package:flutter/cupertino.dart';

class pageViewWidget extends StatefulWidget {
  const pageViewWidget({Key? key}) : super(key: key);

  @override
  State<pageViewWidget> createState() => _pageViewWidgetState();
}

class _pageViewWidgetState extends State<pageViewWidget> {
  late PageController _pageController = new PageController();
  final List<Widget> _pageList = <Widget>[
    taskWidget(),
    taskWidget(),
    taskWidget(),
    taskWidget(),
    taskWidget(),
    taskWidget(),
    taskWidget(),
  ];

  var _currrentPage = 0.0;
  double _scaleFactor = .8;

  @override
  void initState(){
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currrentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: _pageList.length,
      controller: _pageController,
      itemBuilder: (content, index) => _pageList[index],
    );
  }

  _buildPageItem(int index){
    Matrix4 matrix4 = Matrix4.identity();
    return _pageList[index];
  }
}
