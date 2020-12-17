import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CCTabBar extends StatefulWidget {
  @required final List<String> menuList;
  final TextStyle labelStyle;
  final TextStyle unselectedLabelStyle;
  final Color unselectedLabelColor;
  final Color labelColor;
  final Color indicatorColor;
  final TabBarIndicatorSize indicatorSize;
  final double indicatorWeight;
  @required final TabController controller;
  final EdgeInsetsGeometry indicatorPadding;
  final bool isScrollable;
  final ValueChanged<int> onTap;
  CCTabBar(
      {this.menuList,
      this.labelStyle,
      this.unselectedLabelStyle,
      this.unselectedLabelColor,
      this.labelColor,
      this.indicatorColor,
      this.indicatorSize = TabBarIndicatorSize.tab,
      this.indicatorWeight = 2.0,
      this.controller,
      this.indicatorPadding = EdgeInsets.zero,
      this.isScrollable = true,
      this.onTap,
      Key key})
      : super(key: key);

  @override
  CCTabBarState createState() => CCTabBarState();
}

class CCTabBarState extends State<CCTabBar> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: ScreenUtil().setWidth(56),
        width: double.infinity,
        color: Colors.white,
        child: TabBar(
          onTap: (int index) {
            if (widget.onTap != null) {
              widget.onTap(index);
            }
          },
          isScrollable: widget.isScrollable,
          controller: widget.controller,
          labelColor: _getLabelColor(),
          labelStyle: _getLabelStyle(),
          unselectedLabelColor: _getUnselectedLabelColor(),
          unselectedLabelStyle: _getUnselectedLabelStyle(),
          indicatorColor: _getIndicatorColor(),
          indicatorSize: widget.indicatorSize,
          indicatorWeight: widget.indicatorWeight,
          indicatorPadding: widget.indicatorPadding,
          tabs: _getMenuList(),
        ));
  }

  ///设置选中时的字体颜色
  Color _getLabelColor() {
    if (widget.labelColor != null) {
      return widget.labelColor;
    }
    return Color(0xFF201E26);
  }

  ///设置选中时的字体样式
  TextStyle _getLabelStyle() {
    if (widget.labelStyle != null) {
      return widget.labelStyle;
    }
    return TextStyle(
        fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18));
  }

  ///设置未选中时的字体样式
  TextStyle _getUnselectedLabelStyle() {
    if (widget.unselectedLabelStyle != null) {
      return widget.unselectedLabelStyle;
    }
    return TextStyle(
        fontWeight: FontWeight.w400, fontSize: ScreenUtil().setSp(16));
  }

  ///设置未选中时的字体颜色
  Color _getUnselectedLabelColor() {
    if (widget.unselectedLabelColor != null) {
      return widget.unselectedLabelColor;
    }
    return Color(0xFF929099);
  }

  ///选中下划线的颜色
  Color _getIndicatorColor() {
    if (widget.indicatorColor != null) {
      return widget.indicatorColor;
    }
    return Color(0xFF724AE8);
  }

  List<Widget> _getMenuList() {
    List<Widget> menuWidgetList = [];
    if (widget.menuList != null && widget.menuList.length > 0) {
      for (int i = 0; i < widget.menuList.length; i++) {
        menuWidgetList.add(Tab(
          child: Text(widget.menuList[i]),
        ));
      }
      return menuWidgetList;
    }
    return menuWidgetList;
  }
}
