import 'package:flutter/material.dart';
import '../auth/login/login_screen.dart';
import 'package:memore/presentation/screen/sidebar/profile/profile_card.dart';
import 'package:memore/presentation/screen/sidebar/favorite/favorite_screen.dart';
import 'package:memore/presentation/screen/sidebar/trash/trash_screen.dart';
import 'package:memore/presentation/screen/sidebar/friend/friend_screen.dart';
import 'package:memore/presentation/screen/sidebar/setting/setting_screen.dart';
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,  // 화면의 70% 너비
      child: Drawer(
        backgroundColor: Color(0xFFFFFEFA),
        child: Column(
          // ✅ ListView -> Column 변경
          children: [
            const SafeArea(
              child: ProfileCard(),
            ),
            // 메뉴 리스트
            ListTile(
              leading: const Icon(Icons.star, color: Color(0xFF6495ED)),
              title: const Text('Favorites',style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context); // 드로어 닫고
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add, color: Color(0xFF6495ED)),
              title: const Text('Friends', style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                // TODO: 친구 추가 화면 이동 (규나 진행중)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FriendScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Color(0xFF6495ED)),
              title: const Text('Trash',style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context); // 먼저 드로어 닫고
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrashScreen()), // TrashScreen으로 이동
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF6495ED)),
              title: const Text('Settings',style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingScreen()),
                );
              },
            ),

            const Spacer(), // 👈 위 메뉴들 밀어올리고

      // 하단 영역
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 좌우 끝으로 배치
                children: [
                  const Text(
                    '© 2025 Memo:Re\n당신의 여행을 기록합니다.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                      height: 1.5, // 줄 간격 조금 늘림
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
