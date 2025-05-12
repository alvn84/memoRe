import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/sidebar/friend/friend.dart';
import 'package:memore/presentation/screen/sidebar/friend/add_friend_screen.dart';


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
                              dummyFriends.add(newFriend);
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    trailing: IconButton(
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
                                      dummyFriends.removeAt(index);
                                    });
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                  },
                                  child: const Text('삭제', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
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