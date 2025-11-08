import 'package:flutter/material.dart';

class CustomScrollAdvanced extends StatelessWidget {
  const CustomScrollAdvanced({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '分类吸顶示例',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StickyCategoryPage(),
    );
  }
}

class StickyCategoryPage extends StatefulWidget {
  const StickyCategoryPage({super.key});

  @override
  State<StickyCategoryPage> createState() => _StickyCategoryPageState();
}

class _StickyCategoryPageState extends State<StickyCategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<bool> isScrolled = ValueNotifier(false);

  final List<String> categories = ['推荐', '动漫', '游戏', '音乐', '电影', '小说'];

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
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels > 100 && !isScrolled.value) {
            isScrolled.value = true;
          } else if (scroll.metrics.pixels <= 100 && isScrolled.value) {
            isScrolled.value = false;
          }
          return false;
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: isScrolled,
          builder: (context, scrolled, _) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor:
                  scrolled ? Colors.white : Colors.transparent,
                  elevation: scrolled ? 3 : 0,
                  title: Text(
                    'AnimeFlow 分类',
                    style: TextStyle(
                      color: scrolled ? Colors.black : Colors.white,
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
                  delegate: _CategoryTabBarDelegate(
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
              ],
              body: TabBarView(
                controller: _tabController,
                children: categories.map((category) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: 20,
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
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _CategoryTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
