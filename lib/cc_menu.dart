import 'dart:ui';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'cc_tabBar.dart';

class CCMenuController {
  GlobalKey<_CCMenuPageState> menuState = GlobalKey<_CCMenuPageState>();

  updateMenu() {
    menuState.currentState!.updateMenu();
  }
}

class CCMenuPage extends StatefulWidget {
  ///默认源数据数组
  final List<String>? menuList;

  ///头部
  final Widget? headerWidget;

  ///底部
  final Widget? bottomWidget;

  ///滚动页面列表样式
  final IndexedWidgetBuilder? itemBuilder;

  ///默认选中
  final int? selectIndex;

  ///点击顶部菜单回调
  final ValueChanged<int>? onTap;

  ///下拉刷新事件
  final VoidCallback? onRefresh;

  ///顶部菜单样式
  final IndexedWidgetBuilder? tabBuilder;

  ///菜单个数
  final int? itemCount;

  ///设置选中时的字体选中样式
  final TextStyle? labelStyle;

  ///设置未选中字体样式
  final TextStyle? unselectedLabelStyle;

  ///设置未选中字体颜色
  final Color? unselectedLabelColor;

  ///设置选中字体颜色
  final Color? labelColor;

  ///选中下划线的颜色
  final Color? indicatorColor;

  ///选中下划线的长度
  final TabBarIndicatorSize? indicatorSize;

  ///选中下划线的高度
  final double? indicatorWeight;
  final EdgeInsetsGeometry? indicatorPadding;

  ///是否滚动 默认true
  final bool? isScrollable;

  /// 菜单栏高度
  final double? tabHeight;

  /// 空数据样式
  final Widget? refreshEmptyWidget;

  ///下拉刷新header样式
  final Header? refreshHeaderWidget;

  CCMenuPage(
      {required this.menuList,
      required this.itemBuilder,
      this.headerWidget,
      this.bottomWidget,
      this.selectIndex = 0,
      this.onTap,
      this.onRefresh,
      this.refreshEmptyWidget,
      this.refreshHeaderWidget,
      Key? key})
      : assert(menuList != null && menuList.length > 0),
        assert(itemBuilder != null),
        this.tabBuilder = null,
        this.itemCount = null,
        this.labelStyle = null,
        this.unselectedLabelStyle = null,
        this.unselectedLabelColor = null,
        this.labelColor = null,
        this.indicatorColor = null,
        this.indicatorSize = null,
        this.indicatorWeight = null,
        this.indicatorPadding = null,
        this.isScrollable = null,
        this.tabHeight = null,
        super(key: key);

  CCMenuPage.custom({
    Key? key,
    required this.menuList,
    required this.itemBuilder,
    this.headerWidget,
    this.bottomWidget,
    this.selectIndex = 0,
    this.onTap,
    this.onRefresh,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.unselectedLabelColor,
    this.labelColor,
    this.indicatorColor,
    this.indicatorSize,
    this.indicatorWeight,
    this.indicatorPadding,
    this.isScrollable,
    this.tabHeight,
    this.refreshEmptyWidget,
    this.refreshHeaderWidget,
  })  : assert(menuList != null && menuList.length > 0),
        assert(itemBuilder != null),
        this.tabBuilder = null,
        this.itemCount = null,
        super(key: key);

  CCMenuPage.builder({
    Key? key,
    required this.tabBuilder,
    required this.itemCount,
    required this.itemBuilder,
    this.headerWidget,
    this.bottomWidget,
    this.selectIndex = 0,
    this.onTap,
    this.onRefresh,
    this.refreshEmptyWidget,
    this.refreshHeaderWidget,
  })  : assert(itemCount != null && itemCount > 0),
        assert(tabBuilder != null),
        assert(itemBuilder != null),
        this.labelStyle = null,
        this.unselectedLabelStyle = null,
        this.unselectedLabelColor = null,
        this.labelColor = null,
        this.indicatorColor = null,
        this.indicatorSize = null,
        this.indicatorWeight = null,
        this.indicatorPadding = null,
        this.isScrollable = null,
        this.menuList = null,
        this.tabHeight = null,
        super(key: key);

  @override
  _CCMenuPageState createState() => _CCMenuPageState();
}

class _CCMenuPageState extends State<CCMenuPage> with TickerProviderStateMixin {
  List _keyList = [];
  List _offsetList = [];
  late TabController? _tabController;
  late ScrollController _scrollController;
  bool _isScrollView = false;
  final GlobalKey headerGlobalKey = GlobalKey();
  double _headerHeight = 0;
  int _selectNumber = 0;
  int _itemCount = 0;
  List<Widget> _menuWidgetList = [];
  double _tabHeight = 0;
  late EasyRefreshController _easyRefreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
    _easyRefreshController.dispose();
    _tabController?.dispose();
    _scrollController.dispose();
  }

  initData() {
    _easyRefreshController = EasyRefreshController();
    _getItemHeight();
    _selectNumber = widget.selectIndex ?? 0;
    _itemCount = _getItemCount();
    _getMenuList();
    _keyList = List.generate(_itemCount, (index) => GlobalKey());
    _tabController = null;
    _tabController = TabController(length: _itemCount, vsync: this);
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      var of = _scrollController.offset;
      if (of == _scrollController.position.maxScrollExtent) {
        _isScrollView = false;
      } else {
        if (_isScrollView == true) {
          return;
        }
        var oneOffset = _offsetList[0];
        bool isOffset = false;
        for (int i = _offsetList.length - 1; i > 0; i--) {
          var nowOffset = _offsetList[i];
          if (of > (nowOffset - oneOffset + _headerHeight)) {
            isOffset = true;
            _tabController?.animateTo(i);
            break;
          }
        }
        if (isOffset == false) {
          _tabController?.animateTo(0);
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _headerHeight = _getHeaderHeigth();
      _subInitState();
      _anmationMenu();
    });
  }

  updateMenu() {
    _itemCount = _getItemCount();
    _getMenuList();
    _keyList = List.generate(_itemCount, (index) => GlobalKey());
    _tabController = TabController(length: _itemCount, vsync: this);
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _headerHeight = _getHeaderHeigth();
      _subInitState();
      _anmationMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        _tabHeight == 0
            ? Container(
                width: double.infinity,
                child: _tabBarWidget(),
              )
            : Container(
                height: _tabHeight,
                width: double.infinity,
                child: _tabBarWidget(),
              ),
        Expanded(
            child: Container(
          height: MediaQuery.of(context).size.height -
              _headerHeight -
              MediaQueryData.fromWindow(window).padding.top,
          child: _itemCount == 0
              ? Center(
                  child: _getEmptyWidget(),
                )
              : EasyRefresh(
                  controller: _easyRefreshController,
                  onRefresh: () async {
                    if (widget.onRefresh != null) {
                      widget.onRefresh!();
                    }
                  },
                  header: _getDefaultHeader(),
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
    );
  }

  Widget _tabBarWidget() {
    return CCTabBar(
      menuList: _menuWidgetList,
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
      onTap: (int index) {
        setState(() {
          _selectNumber = index;
          _anmationMenu();
        });
        if (widget.onTap != null) {
          widget.onTap!(index);
        }
      },
    );
  }

  Header _getDefaultHeader() {
    if (widget.refreshHeaderWidget == null) {
      return MaterialHeader();
    }
    return widget.refreshHeaderWidget!;
  }

  Widget _getEmptyWidget() {
    if (widget.refreshEmptyWidget == null) {
      return SizedBox();
    }
    return widget.refreshEmptyWidget!;
  }

  _getMenuList() {
    List<Widget> widgetList = [];
    if (widget.menuList != null) {
      for (int i = 0; i < widget.menuList!.length; i++) {
        widgetList.add(Tab(
          child: Text(widget.menuList![i]),
        ));
      }
    } else {
      if ((widget.itemCount ?? 0) > 0) {
        for (int i = 0; i < widget.itemCount!; i++) {
          widgetList.add(widget.tabBuilder!(context, i));
        }
      }
    }
    _menuWidgetList = widgetList;
  }

  Widget _getListWidget() {
    if (_itemCount == 0) {
      return SizedBox();
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      itemCount: _itemCount,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        GlobalKey itemKey = _keyList[index];
        return Container(
          key: itemKey,
          child: widget.itemBuilder!(context, index),
        );
      },
    );
  }

  Widget _getHeaderWidget() {
    return Container(
      key: headerGlobalKey,
      child: widget.headerWidget ?? SizedBox(),
    );
  }

  Widget _getBottomWidget() {
    if (widget.bottomWidget != null) {
      return widget.bottomWidget!;
    }
    return SizedBox();
  }

  _subInitState() {
    _offsetList = [];
    for (int i = 0; i < _keyList.length; i++) {
      var globalKey = _keyList[i];
      var offsetY = getY(globalKey.currentContext);
      _offsetList.add(offsetY);
    }
  }

  double getY(BuildContext? buildContext) {
    if (buildContext == null) {
      return 0;
    }
    final RenderBox box = buildContext.findRenderObject() as RenderBox;
    final topLeftPosition = box.localToGlobal(Offset.zero);
    return topLeftPosition.dy;
  }

  int _getItemCount() {
    if (widget.itemCount == null && widget.tabBuilder == null) {
      return widget.menuList!.length;
    }
    return widget.itemCount!;
  }

  _getItemHeight() {
    if (widget.tabBuilder == null && widget.itemCount == null) {
      if (widget.tabHeight != null) {
        _tabHeight = widget.tabHeight!;
      } else {
        _tabHeight = 30;
      }
    } else {
      _tabHeight = 0;
    }
  }

  _anmationMenu() {
    if (_selectNumber == 0) {
      _isScrollView = false;
      _tabController?.animateTo(_selectNumber);
      _scrollController.jumpTo(0);
    } else {
      _isScrollView = false;
      _tabController?.animateTo(_selectNumber);
      var oneOffset = _offsetList[0];
      var nowOffset = _offsetList[_selectNumber] - oneOffset + _headerHeight;
      if (nowOffset <= _scrollController.position.maxScrollExtent) {
        _scrollController.jumpTo(
            _offsetList[_selectNumber] - _offsetList[0] + _headerHeight + 2);
      } else {
        //滚动到底部
        _isScrollView = true;
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          //如果已经滚动到底部  不会走滚动监听回调
          _isScrollView = false;
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    }
  }

  double _getHeaderHeigth() {
    double? containerHeight = headerGlobalKey.currentContext?.size?.height;
    return containerHeight ?? 0;
  }
}
