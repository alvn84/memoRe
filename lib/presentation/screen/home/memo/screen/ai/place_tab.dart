import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart'; // ✅ Factory 클래스
import 'package:flutter/gestures.dart';

import 'ai_repository.dart'; // ✅ OneSequenceGestureRecognizer, EagerGestureRecognizer
import 'package:geolocator/geolocator.dart';

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
  static const LatLng _defaultLatLng = LatLng(35.6895, 139.6917);
  final _gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>{
    Factory(() => EagerGestureRecognizer()),
  };

  Set<Marker> _markers = {};
  List<MapPlace> _places = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  void _loadPlaces() async {
    print('📩 fallback location: ${widget.folderLocation}');
    print('📤 memo text: ${widget.content}');
    try {
      // ✅ memoId 제거
      final places = await extractMapPlaces(
        memoText: widget.content ?? '',
        folderLocation: widget.folderLocation ?? '',
      );
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
                    initialCameraPosition: const CameraPosition(
                      target: _defaultLatLng,
                      zoom: 12,
                    ),
                    onMapCreated: (controller) => _mapController = controller,
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
