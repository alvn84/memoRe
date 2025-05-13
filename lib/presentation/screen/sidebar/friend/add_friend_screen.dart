import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/sidebar/friend/friend.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddFriendScreen extends StatefulWidget {
  final Function(Friend) onFriendAdded;

  const AddFriendScreen({Key? key, required this.onFriendAdded}) : super(key: key);

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _emailController = TextEditingController();

  List<Friend> searchResults = [];
  bool isLoading = false;

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() => isLoading = true);

    final response = await http.get(
      Uri.parse('https://your-api.com/users/search?query=$query'), // 실제 API 주소로 변경
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        searchResults = data.map((e) => Friend.fromJson(e)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final myEmail = 'qnada0118@gmail.com'; // 본인 이메일 (향후 SharedPreferences 등으로 대체 가능)

    return Scaffold(
      appBar: AppBar(title: const Text('친구 추가'), backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔍 검색 입력창 + 버튼
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    onChanged: (value) => searchUsers(value),
                    decoration: const InputDecoration(
                      hintText: '이름 또는 이메일로 검색',
                      prefixIcon: Icon(Icons.alternate_email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => searchUsers(_emailController.text.trim()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.search,
                    size: 24,
                    color: Colors.black87,
                  ),                ),
              ],
            ),

            // 👤 내 이메일 표시
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
            const SizedBox(height: 16),

            // 🔍 검색 결과 출력
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : searchResults.isEmpty
                  ? const Center(child: Text('검색 결과가 없습니다.'))
                  : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final friend = searchResults[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(friend.profileImageUrl),
                    ),
                    title: Text(friend.name),
                    subtitle: Text(friend.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.person_add, color: Colors.blue),
                      onPressed: () {
                        widget.onFriendAdded(friend);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
