import 'package:flutter/material.dart';

class CustomTabBar extends SliverPersistentHeaderDelegate {
  final Column customTabBar;

  CustomTabBar({required this.customTabBar});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return customTabBar;
  }

  @override
  double get maxExtent => 100.0;

  @override
  double get minExtent => 100.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

CustomTabBar customTabBar(
    {required double screenWidth,
    required int currentCategory,
    required Color mainColor,
    required Function(int) onCategoryChanged}) {
  List<String> tabs = [
    "Popular",
    "Wraps",
    "Bowls",
    "Salads",
    "Side Order",
    "Dessert",
    "Drinks"
  ];
  List<String> tabsImage = [
    "assets/icons/poular.png",
    "assets/icons/wraps.png",
    "assets/icons/bowls.png",
    "assets/icons/salad.png",
    "assets/icons/sideorders.png",
    "assets/icons/dessert.png",
    "assets/icons/drinks.png"
  ];
  return CustomTabBar(
      customTabBar: Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
          color: Colors.white.withOpacity(1),
          width: screenWidth,
          height: 100,
          child: StatefulBuilder(builder: (context, StateSetter setState) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: ((context, index) {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentCategory = index;
                        onCategoryChanged(currentCategory);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Container(
                                width: 70,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCFCFC),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x29000000),
                                      offset: Offset(0, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  tabsImage[index],
                                  filterQuality: FilterQuality.high,
                                  scale: 15,
                                )),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              tabs[index],
                            ),
                            currentCategory == index
                                ? Center(
                                    child: CircleAvatar(
                                        maxRadius: 3.4,
                                        backgroundColor: mainColor),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ));
              }),
            );
          }))
    ],
  ));
}
