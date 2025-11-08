import 'package:flutter/material.dart';

class CustomScrollPage extends StatefulWidget {
  const CustomScrollPage({super.key});

  @override
  CustomScrollPageState createState() => CustomScrollPageState();
}

class CustomScrollPageState extends State<CustomScrollPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("CustomScrollView-demo"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.lightBlue,
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  "模拟轮播图",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverPersistentHeader(delegate: _StickyCategory(), pinned: true),
            SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverList.separated(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 100,
                  color: Colors.lightGreen,
                  alignment: Alignment.center,
                  child: Text(
                    "列表项$index",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                  color: Colors.grey,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyCategory extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 80,
            margin: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            color: Colors.lightBlue,
            child: Text(
              '分类${index + 1}',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
