// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import '../services/toko_service.dart';
// import '../models/toko_model.dart';

// class TokoMapScreen extends StatefulWidget {
//   const TokoMapScreen({super.key});

//   @override
//   State<TokoMapScreen> createState() => _TokoMapScreenState();
// }

// class _TokoMapScreenState extends State<TokoMapScreen> {
//   late Future<List<Toko>> _tokoFuture;

//   @override
//   void initState() {
//     super.initState();
//     _tokoFuture = TokoService.fetchToko();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Daftar Toko di Map")),
//       body: FutureBuilder<List<Toko>>(
//         future: _tokoFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("Tidak ada data toko."));
//           }

//           final tokoList = snapshot.data!;
//           print("Jumlah toko: ${tokoList.length}");
//           tokoList.forEach((t) => print("Toko: ${t.namaToko}"));

//           return FlutterMap(
//             options: MapOptions(
//               initialCenter: LatLng(
//                 tokoList[0].latitude,
//                 tokoList[0].longitude,
//               ),
//               initialZoom: 13,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 userAgentPackageName: 'com.example.app',
//               ),
//               MarkerLayer(
//                 markers: tokoList.map((toko) {
//                   print('Nama marker: "${toko.namaToko}"');
//                   final nama = toko.namaToko.trim().isNotEmpty
//                       ? toko.namaToko.trim()
//                       : "Toko Tanpa Nama";

//                   return Marker(
//                     point: LatLng(toko.latitude, toko.longitude),
//                     width: 120,
//                     height: 60,
//                     alignment: Alignment.topCenter,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 blurRadius: 4,
//                                 offset: Offset(2, 2),
//                               ),
//                             ],
//                           ),
//                           child: Text(
//                             nama,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                               color: Colors.black,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const Icon(Icons.location_on, size: 32, color: Colors.red),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
