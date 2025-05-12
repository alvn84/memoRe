import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/sidebar/friend/friend.dart';

class AddFriendScreen extends StatefulWidget {
  final Function(Friend) onFriendAdded;

  const AddFriendScreen({Key? key, required this.onFriendAdded}) : super(key: key);

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _handleAdd() {
    final email = _emailController.text.trim();

    if (email.isNotEmpty) {
      final newFriend = Friend(
        name: email.split('@').first, // 이름 대신 이메일 앞부분 사용
        email: email,
        profileImageUrl: 'https://i.pravatar.cc/150?u=$email',
      );
      widget.onFriendAdded(newFriend);
      Navigator.pop(context); // 화면 종료
    }
  }

  @override
  Widget build(BuildContext context) {
    final myEmail = 'qnada0118@gmail.com'; // 🔒 고정 표시될 사용자 이메일

    return Scaffold(
      appBar: AppBar(title: const Text('친구 추가'), backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: '이메일',
                      prefixIcon: Icon(Icons.alternate_email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                ElevatedButton(
                  onPressed: _handleAdd,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    elevation: 0, // 🌟 그림자 제거
                    backgroundColor: Colors.transparent, // 🌟 배경 제거
                    shadowColor: Colors.transparent,     // 🌟 터치 그림자 제거
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.search,
                    size:  24, // 원하는 크기로 조정 (예: 30, 36 등)
                    color: Colors.black87, // 선택적: 색상 변경
                  ),                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    '내 이메일',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    myEmail,
                    style: const TextStyle(color: Colors.grey),
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
