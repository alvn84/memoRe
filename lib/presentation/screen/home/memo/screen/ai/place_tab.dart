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
  String? _selectedPlaceName;
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
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
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                        ),
                      ),

                      // 지도 위에 반투명 장소명 배너
                      Positioned(
                        top: 12,
                        left: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _selectedPlaceName ??
                                widget.folderLocation ??
                                '알 수 없는 장소',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4A90E2),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      return GestureDetector(
                        onTap: () {
                          final latLng = LatLng(place.lat, place.lng);

                          setState(() {
                            _selectedPlaceName =
                                place.name; // ✅ 지도 상단 배너 텍스트 변경
                            _initialLatLng = latLng; // ✅ 중심 위치도 갱신
                            _markers = {
                              Marker(
                                markerId: const MarkerId('selected'),
                                position: latLng,
                                infoWindow: InfoWindow(title: place.name),
                              ),
                            }; // ✅ 선택된 장소만 마커로 표시
                          });

                          _mapController?.animateCamera(
                            CameraUpdate.newLatLng(latLng),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(Icons.place,
                                    color: Color(0xFF6495ED), size: 30),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        place.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
              ],
            ),
          );
  }
}
