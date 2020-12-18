适用于iOS和Android的Flutter插件，用于实现顶部菜单跟页面联合滚动效果。

# 安装
在pubspec.yaml文件中添加link_scroll_menu为依赖项。


# 使用例子

```
GlobalKey<CCMenuPageState> menuState = GlobalKey<CCMenuPageState>();

  List<Color> colorList = [
    Color(0xFF969AF9),
    Color(0xFF53CFA1),
    Color(0xFFFF9E59),
    Color(0xFFFF99CB),
    Color(0xFF80D0FF),
  ];
  List<String> menuList = ['关注','推荐','热榜','抗疫','视频','小视频','直播','娱乐','新闻'];

```

### 1、默认顶部菜单样式，此样式只能传string类型的list
```
return CCMenuPage(
        menuList: menuList,
        itemBuilder: (BuildContext context,int index){
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 200,
            color: colorList[index % colorList.length],
            child: Text('${menuList[index]}',style: TextStyle(fontSize: 20),),
          );
        },
      );
```

### 2、可以设置顶部菜单样式，文字颜色、大小、下划线颜色等，此样式只能传string类型的list
```
return CCMenuPage.custom(
        menuList: menuList,
        tabHeight: 60,
        itemBuilder: (BuildContext context,int index){
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 200,
            color: colorList[index % colorList.length],
            child: Text('${menuList[index]}',style: TextStyle(fontSize: 20),),
          );
        },
      );

```

### 3、可以自定义顶部菜单样式
```
 return CCMenuPage.builder(
        itemCount: menuList.length,
        tabBuilder: (BuildContext context,int index){
          return Container(
            alignment: Alignment.center,
            width: 60,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Container(
                   width: 30,
                   height: 30,
                   margin: EdgeInsets.only(
                     bottom: 10,
                     top: 10
                   ),
                   color: Colors.amber,
                 ),
                 Text(
                   menuList[index],style: TextStyle(fontSize: 18),
                 )
               ],
             ),
          );
        },
        itemBuilder: (BuildContext context,int index){
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 200,
            color: colorList[index % colorList.length],
            child: Text('${menuList[index]}',style: TextStyle(fontSize: 20),),
          );
        },
      );

```

### 4、可以在滚动页面添加头部和底部，不会影响菜单选中
```
return CCMenuPage.custom(
        menuList: menuList,
        tabHeight: 60,
        headerWidget: Container(
          alignment: Alignment.center,
          height: 200,
          color: Colors.black38,
          child: Text('这是头部',style: TextStyle(fontSize: 20),),
        ),
        bottomWidget: Container(
          alignment: Alignment.center,
          height: 200,
          color: Colors.black38,
          child: Text('这是底部',style: TextStyle(fontSize: 20),),
        ),
        itemBuilder: (BuildContext context,int index){
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 200,
            color: colorList[index % colorList.length],
            child: Text('${menuList[index]}',style: TextStyle(fontSize: 20),),
          );
        },
      );

```

### 5、可以添加菜单个数
```
GlobalKey<CCMenuPageState> menuState = GlobalKey<CCMenuPageState>();

return CCMenuPage.custom(
        key: menuState,
        menuList: menuList,
        tabHeight: 60,
        itemBuilder: (BuildContext context,int index){
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 200,
            color: colorList[index % colorList.length],
            child: Text('${menuList[index]}',style: TextStyle(fontSize: 20),),
          );
        },
      );
      
      点击添加按钮菜单：
      GestureDetector(
             onTap: (){
              menuList.add('新增菜单');
              menuState.currentState.updateMenu();
              setState(() {

              });
             },
             child: Container(
               width: 50,
               child: Icon(Icons.add,color: Colors.white,),
             ),
           )

```
