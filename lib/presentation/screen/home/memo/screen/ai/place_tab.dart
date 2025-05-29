import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart'; // ✅ Factory 클래스
import 'package:flutter/gestures.dart';

import 'ai_repository.dart'; // ✅ OneSequenceGestureRecognizer, EagerGestureRecognizer

class PlaceTab extends StatefulWidget {
  final String? title;
  final String? content;
  final String? folderLocation; // ✅ 추가

  const PlaceTab({
    super.key,
    required this.title,
    required this.content,
    this.folderLocation, // ✅ 추가
  });

  @override
  State<PlaceTab> createState() => _PlaceTabState();
}

class _PlaceTabState extends State<PlaceTab> {
  GoogleMapController? _mapController;
  final _gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>{
    Factory(() => EagerGestureRecognizer()),
  };
  LatLng? _initialLatLng; // ✅ 도쿄 대신 폴더 기반 초기 위치

  Set<Marker> _markers = {};
  List<MapPlace> _places = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('📍 전달된 folderLocation: ${widget.folderLocation}');
    initLocation();
    _loadPlaces();
  }

  void initLocation() async {
    if (widget.folderLocation == null ||
        widget.folderLocation!.trim().isEmpty) {
      print('⚠️ folderLocation이 비어 있음');
      return;
    }

    try {
      final place = await extractLocation(widget.folderLocation!);
      if (place != null) {
        final latLng = LatLng(place.lat, place.lng);
        print('📍 폴더 장소 초기 위치 설정됨: ${place.name} (${place.lat}, ${place.lng})');
        setState(() {
          _initialLatLng = latLng;
        });

        // ✅ 지도 생성된 이후일 경우 바로 이동
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(latLng),
          );
        }
      } else {
        print('⚠️ extractLocation 결과가 null');
      }
    } catch (e) {
      print('❌ 폴더 장소 초기화 실패: $e');
    }
  }

  void _loadPlaces() async {
    print('📤 memo text: ${widget.content}');
    try {
      final places = await extractMapPlaces(
        memoText: widget.content ?? '',
      );

      final markers = places.map((place) {
        return Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.lat, place.lng),
          infoWindow: InfoWindow(title: place.name),
        );
      }).toSet();

      setState(() {
        _places = places;
        _markers = markers;
        _isLoading = false;

        // ❌ 더 이상 _initialLatLng을 메모 기반으로 덮어쓰지 않음
        // ✅ 폴더 장소만 최초 기본값으로 유지
      });
    } catch (e) {
      print('❌ 장소 로딩 실패: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            // 🔑 이렇게 감싸줘야 전체 시트가 스크롤 이벤트를 인식
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  ' 📍 메모리 지도',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250, // 적당히 고정된 지도 높이
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialLatLng!,
                      zoom: 12,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;

                      if (_initialLatLng != null) {
                        _mapController!.animateCamera(
                          CameraUpdate.newLatLng(_initialLatLng!),
                        );
                      }
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
                            CameraUpdate.newLatLng(
                                LatLng(place.lat, place.lng)),
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
