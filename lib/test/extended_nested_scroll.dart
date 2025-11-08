import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as ens;

class ExtendedNestedScroll extends StatelessWidget {
  const ExtendedNestedScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExtendedNestedScrollView 分类吸顶示例',
      debugShowCheckedModeBanner: false,
      home: const CategoryStickyPage(),
    );
  }
}

class CategoryStickyPage extends StatefulWidget {
  const CategoryStickyPage({super.key});

  @override
  State<CategoryStickyPage> createState() => _CategoryStickyPageState();
}

class _CategoryStickyPageState extends State<CategoryStickyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = ['推荐', '动漫', '游戏', '音乐', '电影', '小说'];
  final ValueNotifier<bool> isScrolled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    isScrolled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ens.ExtendedNestedScrollView(
        onlyOneScrollInBody: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              backgroundColor:
              innerBoxIsScrolled ? Colors.white : Colors.transparent,
              elevation: innerBoxIsScrolled ? 3 : 0,
              title: Text(
                'AnimeFlow 分类',
                style: TextStyle(
                  color: innerBoxIsScrolled ? Colors.black : Colors.white,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://picsum.photos/800/400',
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarHeaderDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: categories.map((e) => Tab(text: e)).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: categories.map((category) {
            return ens.ExtendedVisibilityDetector(
              uniqueKey: Key(category),
              child: ListView.builder(
                key: PageStorageKey(category),
                itemCount: 20,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade200,
                        child: Text(category[0]),
                      ),
                      title: Text('$category 项目 #$index'),
                      subtitle: const Text('这里是项目的描述内容...'),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _TabBarHeaderDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
