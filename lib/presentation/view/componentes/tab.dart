import 'package:flutter/material.dart';

class TabCanguru extends StatelessWidget {
  const TabCanguru({
    Key? key,
    required this.tabs,
    required this.views,
    required this.controller,
    this.direction = VerticalDirection.down,
  }) : super(key: key);
  final List<Tab> tabs;
  final List<Widget> views;
  final TabController controller;
  final VerticalDirection direction;

  @override
  Widget build(BuildContext context) {
    return Column(
      verticalDirection: direction,
      children: [
        SizedBox(
          height: 60,
          child: TabBar(
            controller: controller,
            tabs: tabs,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: TabBarView(
              controller: controller,
              children: views,
            ),
          ),
        ),
      ],
    );
  }
}
