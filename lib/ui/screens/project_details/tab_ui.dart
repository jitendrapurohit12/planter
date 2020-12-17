import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/style/text_styles.dart';
import 'package:gmt_planter/ui/screens/project_details/tabs/tab_details.dart';
import 'package:gmt_planter/ui/screens/project_details/tabs/tab_location.dart';
import 'package:velocity_x/velocity_x.dart';

class TabUI extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _tabController = useTabController(initialLength: 2);
    final pages = [
      TabDetails(),
      TabLocation(),
    ];
    return Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.cyan,
          indicatorSize: TabBarIndicatorSize.label,
          dragStartBehavior: DragStartBehavior.down,
          labelColor: tabStyle(context: context).color,
          labelStyle: tabStyle(context: context),
          tabs: const [
            TabUnit(title: 'Details'),
            TabUnit(title: 'Location Map')
          ],
        ),
        const HeightBox(8),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: pages,
          ),
        ),
      ],
    );
  }
}

class TabUnit extends StatelessWidget {
  final String title;

  const TabUnit({this.title});
  @override
  Widget build(BuildContext context) {
    return title.toUpperCase().text.make().py16();
  }
}
