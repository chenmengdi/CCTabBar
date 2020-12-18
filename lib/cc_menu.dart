import 'dart:ui';

import 'package:cc_tab/cc_tabBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class CCMenuPage extends StatefulWidget {
  @required final List<String> menuList;
  final Widget headerWidget;
  final Widget bottomWidget;
  @required final IndexedWidgetBuilder itemBuilder;
  final Color backgroundColor;
  final int selectIndex;
  final ValueChanged<int> onTap;
  final onRefresh;
  final TextStyle labelStyle;
  final TextStyle unselectedLabelStyle;
  final Color unselectedLabelColor;
  final Color labelColor;
  final Color indicatorColor;
  final TabBarIndicatorSize indicatorSize;
  final double indicatorWeight;
  final EdgeInsetsGeometry indicatorPadding;
  final bool isScrollable;
  CCMenuPage(
      {this.menuList,
      this.headerWidget,
        this.bottomWidget,
      this.itemBuilder,
      this.selectIndex = 0,
      this.onTap,
        this.onRefresh,
        this.backgroundColor,
        this.labelStyle,
        this.unselectedLabelStyle,
        this.unselectedLabelColor,
        this.labelColor,
        this.indicatorColor,
        this.indicatorSize,
        this.indicatorWeight,
        this.indicatorPadding,
        this.isScrollable,
      Key key})
      : super(key: key);

  @override
  CCMenuPageState createState() => CCMenuPageState();
}

class CCMenuPageState extends State<CCMenuPage> with TickerProviderStateMixin {
  List _keyList = [];
  List _offsetList = [];
  TabController _tabController;
  ScrollController _scrollController;
  bool _isScrollView = false;
  final GlobalKey headerGlobalKey = GlobalKey();
  double _headerHeight = 0;
  int _selectNumber = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  initData() {
    _selectNumber = widget.selectIndex;
    _keyList = List.generate(widget.menuList.length, (index) => GlobalKey());
    _tabController = null;
    _tabController = TabController(length: widget.menuList.length, vsync: this);
    if (_tabController.indexIsChanging) {

    }
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      var of = _scrollController.offset;
      if (of == _scrollController.position.maxScrollExtent){
        _isScrollView = false;
      }else{
        if (_isScrollView == true){
          return;
        }
        var oneOffset = _offsetList[0];
        bool isOffset = false;
        for (int i = _offsetList.length - 1; i > 0; i--) {
          var nowOffset = _offsetList[i];
          if (of > (nowOffset - oneOffset + _headerHeight)) {
            isOffset = true;
            _tabController.animateTo(i);
            break;
          }
        }
        if (isOffset == false) {
          _tabController.animateTo(0);
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _headerHeight = _getHeaderHeigth();
      _subInitState();
      _anmationMenu();
    });
  }

  updateMenu(){
    _keyList = List.generate(widget.menuList.length, (index) => GlobalKey());
    _tabController = TabController(length: widget.menuList.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _headerHeight = _getHeaderHeigth();
      _subInitState();
      _anmationMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: _getBackgroundColor(),
      child: Column(
        children: [
          CCTabBar(
            menuList: widget.menuList,
            controller: _tabController,
            labelStyle: widget.labelStyle,
            unselectedLabelStyle: widget.unselectedLabelStyle,
            unselectedLabelColor: widget.unselectedLabelColor,
            labelColor: widget.labelColor,
            indicatorColor: widget.indicatorColor,
            indicatorSize: widget.indicatorSize,
            indicatorPadding: widget.indicatorPadding,
            indicatorWeight: widget.indicatorWeight,
            isScrollable: widget.isScrollable,
            onTap: (int index){
              setState(() {
                _selectNumber = index;
                _anmationMenu();
              });
              if (widget.onTap != null){
                widget.onTap(index);
              }
            },
          ),
          Expanded(child: Container(
            height: MediaQuery.of(context).size.height -
                _headerHeight -
                MediaQueryData.fromWindow(window).padding.top,
            child: EasyRefresh(
              onRefresh: () async {
                if(widget.onRefresh != null){
                  widget.onRefresh();
                }
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    _getHeaderWidget(),
                    _getListWidget(),
                    _getBottomWidget()
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _getListWidget(){
     if (widget.menuList.length == 0){
       return SizedBox();
     }
     return ListView.builder(
       shrinkWrap: true,
       physics: new NeverScrollableScrollPhysics(),
       itemCount: widget.menuList.length,
       itemBuilder:
           (BuildContext context, int index) {
         GlobalKey itemKey = _keyList[index];
         return Container(
           key: itemKey,
           child: widget.itemBuilder(context,index),
         );
       },
     );
  }

  Widget _getHeaderWidget(){
    if (widget.headerWidget != null){
      return Container(
        key: headerGlobalKey,
        child: widget.headerWidget,
      );
    }
    return SizedBox(key: headerGlobalKey,);
  }

  Widget _getBottomWidget(){
    if (widget.bottomWidget != null){
      return widget.bottomWidget;
    }
    return SizedBox();
  }

  Color _getBackgroundColor() {
    if (widget.backgroundColor != null) {
      return widget.backgroundColor;
    }
    return Colors.white;
  }

  _subInitState() {
    _offsetList = [];
    for (int i = 0; i < _keyList.length; i++) {
      var globalKey = _keyList[i];
      var offsetY = getY(globalKey.currentContext);
      _offsetList.add(offsetY);
    }
  }

  double getY(BuildContext buildContext) {
    if (buildContext == null){
      return 0;
    }
    final RenderBox box = buildContext.findRenderObject();
    final topLeftPosition = box.localToGlobal(Offset.zero);
    return topLeftPosition.dy;
  }

  _anmationMenu(){

    if (_selectNumber == 0){
      _isScrollView = false;
      _tabController.animateTo(_selectNumber);
      _scrollController.jumpTo(0);
    } else{
      _isScrollView = false;
      _tabController.animateTo(_selectNumber);
      var oneOffset = _offsetList[0];
      var nowOffset = _offsetList[_selectNumber]-oneOffset+_headerHeight;
      if (nowOffset <= _scrollController.position.maxScrollExtent){
        _scrollController.jumpTo(_offsetList[_selectNumber] -
            _offsetList[0] +
            _headerHeight +
            2);
      }else{
        //滚动到底部
        _isScrollView = true;
        if (_scrollController.offset == _scrollController.position.maxScrollExtent){
          //如果已经滚动到底部  不会走滚动监听回调
          _isScrollView = false;
        }else{
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    }
  }

  double _getHeaderHeigth(){
    final containerHeight = headerGlobalKey.currentContext.size.height;
    return containerHeight;
  }

}
