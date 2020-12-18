import 'package:cc_tab/cc_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('菜单', (){
    runApp(
        MyApp()
    );
  });

}

class MyApp extends StatelessWidget {
  List<Color> colorList = [
    Color(0xFF969AF9),
    Color(0xFF53CFA1),
    Color(0xFFFF9E59),
    Color(0xFFFF99CB),
    Color(0xFF80D0FF),
  ];

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return CCMenuPage(
      menuList: ['关注','推荐','热榜','抗疫','视频','小视频','直播','娱乐','新闻'],
      itemBuilder: (BuildContext context,int index){
        return Container(
          width: double.infinity,
          height: ScreenUtil().setWidth(500),
          color: colorList[index % colorList.length],
        );
      },
    );
  }


}