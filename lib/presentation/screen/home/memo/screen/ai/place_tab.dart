import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart'; // ✅ Factory 클래스
import 'package:flutter/gestures.dart';

import 'ai_repository.dart'; // ✅ OneSequenceGestureRecognizer, EagerGestureRecognizer
import 'package:geolocator/geolocator.dart';

class PlaceTab extends StatefulWidget {
  final String? title;
  final String? content;

  const PlaceTab({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<PlaceTab> createState() => _PlaceTabState();
}

class _PlaceTabState extends State<PlaceTab> {
  GoogleMapController? _mapController;
  LatLng? _initialPosition;
  final _gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>{
    Factory(() => EagerGestureRecognizer()),
  };

  Set<Marker> _markers = {};
  List<MapPlace> _places = [];
  bool _isLoading = true;

  Future<void> _determineInitialPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('❌ 위치 서비스 꺼져 있음');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('❌ 위치 권한 거부됨');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('❌ 위치 권한 영구 거부됨');
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _getCurrentLocationAndMoveMap() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 여부 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('❌ 위치 서비스 꺼져 있음');
      return;
    }

    // 권한 확인 및 요청
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('❌ 위치 권한 거부됨');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('❌ 위치 권한 영구 거부됨');
      return;
    }

    // 위치 가져오기
    final position = await Geolocator.getCurrentPosition();

    final currentLatLng = LatLng(position.latitude, position.longitude);

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(currentLatLng, 14),
    );
  }

  @override
  void initState() {
    super.initState();
    _determineInitialPosition();
    _loadPlaces();
  }

  void _loadPlaces() async {
    try {
      // ✅ memoId 제거
      final places = await extractMapPlaces(widget.content ?? '');
      final markers = places.map((place) {
        return Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.lat, place.lng),
          infoWindow: InfoWindow(title: place.name),
        );
      }).toSet();

      setState(() {
        _markers = markers;
        _places = places;
        _isLoading = false;

        if (markers.isNotEmpty) {
          _mapController
              ?.moveCamera(CameraUpdate.newLatLng(markers.first.position));
        }
      });
    } catch (e) {
      print('❌ 장소 로딩 실패: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initialPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      // 🔑 이렇게 감싸줘야 전체 시트가 스크롤 이벤트를 인식
      child: Column(
        children: [
          SizedBox(
            height: 250, // 적당히 고정된 지도 높이
            child: GoogleMap(
              myLocationEnabled: true,
              // ✅ 사용자 위치 표시
              myLocationButtonEnabled: true,
              // ✅ 기본 위치 버튼 표시 (우측 하단)
              initialCameraPosition: CameraPosition(
                target: _initialPosition!,
                zoom: 12,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                _getCurrentLocationAndMoveMap(); // 👈 여기서 호출
              },
              gestureRecognizers: _gestureRecognizers,
              markers: _markers,
            ),
          ),
          const SizedBox(height: 16), // 간격
          if (_places.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text('📍 추출된 장소가 없습니다.')),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _places.length,
              itemBuilder: (context, index) {
                final place = _places[index];
                return ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(place.name),
                  onTap: () {
                    // ✅ 마커 위치로 부드럽게 카메라 이동
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(LatLng(place.lat, place.lng)),
                    );
                  },
                );
              },
            )
        ],
      ),
    );
  }
}
