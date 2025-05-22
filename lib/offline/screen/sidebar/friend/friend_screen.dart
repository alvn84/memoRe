import 'package:flutter/material.dart';
import 'package:memore/offline/screen/sidebar/friend/friend.dart';
import 'package:memore/offline/screen/sidebar/friend/add_friend_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FriendScreen extends StatefulWidget {
  const FriendScreen({Key? key}) : super(key: key);

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}
class _FriendScreenState extends State<FriendScreen> {
  List<Friend> friends = [];

  @override
  void initState() {
    super.initState();
    fetchFriendsFromServer();
  }

  Future<void> fetchFriendsFromServer() async {
    final response = await http.get(Uri.parse('https://your-api.com/friends'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        friends = data.map((e) => Friend.fromJson(e)).toList();
      });
    }
  }
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final searchResult = friends.where((friend) =>
    friend.name.contains(searchText) || friend.email.contains(searchText)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: Colors.transparent, // 배경 투명
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: '검색',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.person_add),
                  tooltip: '친구 추가',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFriendScreen(
                          onFriendAdded: (newFriend) {
                            setState(() {
                              friends.add(newFriend);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView.separated(
                itemCount: friends.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(friend.profileImageUrl),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(friend.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 2),
                              Text(friend.email, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          tooltip: '삭제',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('삭제'),
                                  content: Text('${friend.name}님을 삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          friends.removeAt(index);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('삭제', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
