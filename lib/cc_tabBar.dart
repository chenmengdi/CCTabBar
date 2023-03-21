import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CCTabBar extends StatefulWidget {
  final TabController? controller;
  final List<Widget>? menuList;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final Color? unselectedLabelColor;
  final Color? labelColor;
  final Color? indicatorColor;
  final TabBarIndicatorSize? indicatorSize;
  final double? indicatorWeight;
  final EdgeInsetsGeometry? indicatorPadding;
  final bool? isScrollable;
  final ValueChanged<int>? onTap;
  CCTabBar(
      {required this.menuList,
        required this.controller,
        this.labelStyle,
        this.unselectedLabelStyle,
        this.unselectedLabelColor,
        this.labelColor,
        this.indicatorColor,
        this.indicatorSize = TabBarIndicatorSize.tab,
        this.indicatorWeight = 2.0,
        this.indicatorPadding = EdgeInsets.zero,
        this.isScrollable = true,
        this.onTap,
        Key? key})
      :super(key: key);

  @override
  CCTabBarState createState() => CCTabBarState();
}

class CCTabBarState extends State<CCTabBar> with TickerProviderStateMixin {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TabBar(
      onTap: (int index) {
        if (widget.onTap != null) {
          widget.onTap!(index);
        }
      },
      isScrollable: _getIsScrollable(),
      controller: widget.controller,
      labelColor: _getLabelColor(),
      labelStyle: _getLabelStyle(),
      unselectedLabelColor: _getUnselectedLabelColor(),
      unselectedLabelStyle: _getUnselectedLabelStyle(),
      indicatorColor: _getIndicatorColor(),
      indicatorSize: _getIndicatorSize(),
      indicatorWeight: _getIndicatorWeight(),
      indicatorPadding: _getIndicatorPadding(),
      tabs: widget.menuList ?? [],
    );
  }

  ///设置选中时的字体颜色
  Color _getLabelColor() {
    if (widget.labelColor != null) {
      return widget.labelColor!;
    }
    return Color(0xFF201E26);
  }

  ///设置选中时的字体样式
  TextStyle _getLabelStyle() {
    if (widget.labelStyle != null) {
      return widget.labelStyle!;
    }
    return TextStyle(fontWeight: FontWeight.w600, fontSize: 18);
  }

  ///设置未选中时的字体样式
  TextStyle _getUnselectedLabelStyle() {
    if (widget.unselectedLabelStyle != null) {
      return widget.unselectedLabelStyle!;
    }
    return TextStyle(fontWeight: FontWeight.w400, fontSize: 16);
  }

  ///设置未选中时的字体颜色
  Color _getUnselectedLabelColor() {
    if (widget.unselectedLabelColor != null) {
      return widget.unselectedLabelColor!;
    }
    return Color(0xFF929099);
  }

  ///选中下划线的颜色
  Color _getIndicatorColor() {
    if (widget.indicatorColor != null) {
      return widget.indicatorColor!;
    }
    return Color(0xFF724AE8);
  }

  bool _getIsScrollable() {
    if (widget.isScrollable != null) {
      return widget.isScrollable!;
    }
    return true;
  }

  TabBarIndicatorSize _getIndicatorSize() {
    if (widget.indicatorSize != null) {
      return widget.indicatorSize!;
    }
    return TabBarIndicatorSize.tab;
  }

  double _getIndicatorWeight() {
    if (widget.indicatorWeight != null) {
      return widget.indicatorWeight!;
    }
    return 2.0;
  }

  EdgeInsetsGeometry _getIndicatorPadding() {
    if (widget.indicatorPadding != null) {
      return widget.indicatorPadding!;
    }
    return EdgeInsets.zero;
  }


}
