import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_stack_project/features/cafe/models/cafe.dart';
import 'package:full_stack_project/features/cafe/models/cafe_list.dart';
import 'package:full_stack_project/features/cafe/pages/add_cafe_page.dart';
import 'package:full_stack_project/features/cafe/pages/cafe_detail_page.dart';
import 'package:full_stack_project/features/cafe/pages/community_page.dart';
import 'package:full_stack_project/features/cafe/pages/review_page.dart';
import 'package:full_stack_project/features/cafe/widgets/profile_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic>? cafeData;
  final bool showAddButton;

  HomePage({Key? key, this.cafeData, this.showAddButton = true}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Column(
            children: [
              Expanded(
                child: ProfileWidget(),
              ),
              Expanded(
                child: _currentIndex == 0
                    ? Consumer<CafeList>(
                        builder: (context, cafeList, child) {
                          return cafeList.cafes.isNotEmpty
                              ? ListView.builder(
                                  itemCount: cafeList.cafes.length,
                                  itemBuilder: (context, index) {
                                    return _buildCafeRowWidget(
                                      cafeList.cafes[index],
                                      context,
                                      onDelete: () {
                                        _deleteCafe(cafeList.cafes[index]);
                                      },
                                      onView: () {
                                        _viewCafe(cafeList.cafes[index]);
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No cafes available.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddCafePage(),
                                            ),
                                          );
                                        },
                                        child: Text('Add a new cafe'),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      )
                    : Container(),
              ),
            ],
          ),
          ReviewPage(),
          CommunityPage(),
        ],
      ),
      floatingActionButton: _currentIndex == 0 && Provider.of<CafeList>(context).cafes.isNotEmpty && widget.showAddButton
  ? FloatingActionButton(
      backgroundColor: Colors.grey[200],
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddCafePage()),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(
        Icons.add,
        color: Colors.black,
      ),
    )
  : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/home.svg'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/coffee.svg'),
            label: 'Review',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/community.svg'),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/mypage.svg'),
            label: 'My Page',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildCafeRowWidget(
    Cafe cafe,
    BuildContext context, {
    VoidCallback? onDelete,
    VoidCallback? onView,
  }) {
    return Container(
      child: Card(
        elevation: 2.0,
        color: Color.fromARGB(255, 64, 123, 40),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          title: Text(
            cafe.name ?? 'N/A',
            style: TextStyle(fontFamily: 'montserrat_regular.ttf', fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '주소: ${cafe.address ?? 'N/A'}',
                style: TextStyle(fontFamily: 'montserrat_regular.ttf', color: Colors.white),
              ),
              Text(
                '전화번호: ${cafe.number ?? 'N/A'}',
                style: TextStyle(fontFamily: 'montserrat_regular.ttf', color: Colors.white),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: onView,
                child: Text('View'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  foregroundColor: const Color.fromARGB(255, 64, 123, 40),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: onDelete,
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteCafe(Cafe cafe) {
    final cafeList = Provider.of<CafeList>(context, listen: false);
    cafeList.removeCafe(cafe);
  }

  void _viewCafe(Cafe cafe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CafeDetailPage(cafe: cafe),
      ),
    );
  }
}
