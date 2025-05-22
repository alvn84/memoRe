import 'package:flutter/material.dart';

class DataManageScreen extends StatelessWidget {
  const DataManageScreen({super.key});

  void _downloadData(BuildContext context) {
    // TODO: 데이터 백업 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('데이터 백업 파일을 다운로드합니다.')),
    );
  }

  void _requestDeleteData(BuildContext context) {
    // TODO: 데이터 삭제 요청 기능 구현
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('데이터 삭제 요청'),
        content: const Text('정말로 모든 데이터를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('데이터 삭제 요청이 완료되었습니다.')),
              );
              // 실제 삭제 요청 처리 함수 호출 필요
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('데이터 관리'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('내 데이터 다운로드'),
            subtitle: const Text('작성한 메모를 백업 파일로 다운로드합니다.'),
            onTap: () => _downloadData(context),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('내 데이터 삭제 요청'),
            subtitle: const Text('모든 데이터를 삭제하고 복구할 수 없습니다.'),
            onTap: () => _requestDeleteData(context),
          ),
        ],
      ),
    );
  }
}
