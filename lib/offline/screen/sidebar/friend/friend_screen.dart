import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/sidebar/friend/friend.dart';
import 'package:memore/presentation/screen/sidebar/friend/friend_add_dialog.dart';


class FriendScreen extends StatefulWidget {
  const FriendScreen({Key? key}) : super(key: key);

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}
class _FriendScreenState extends State<FriendScreen> {
  final List<Friend> dummyFriends = [
    Friend(
      name: '박규나',
      email: 'qnada0118@gmail.com',
      profileImageUrl: 'https://i.pravatar.cc/150?img=1',
    ),
    Friend(
      name: '백준호',
      email: 'jeff070@naver.com',
      profileImageUrl: 'https://i.pravatar.cc/150?img=2',
    ),
  ];
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final searchResult = dummyFriends.where((friend) =>
      friend.name.contains(searchText) || friend.email.contains(searchText)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              // TODO: 친구 추가 화면 이동
              showAddFriendDialog(context); // Dialog 호출
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '친구 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: dummyFriends.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final friend = dummyFriends[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(friend.profileImageUrl),
                  ),
                  title: Text(friend.name),
                  subtitle: Text(friend.email),
                );
                },
            ),
          ),
        ],
      ),
    );
  }
}
