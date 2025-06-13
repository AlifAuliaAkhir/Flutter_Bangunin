// // MAIN UNTUK MAPS
// import 'package:flutter/material.dart';
// import 'screens/toko_map_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Toko Map',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const TokoMapScreen(),
//     );
//   }
// }


// MAIN UNTUK CAMERA
// import 'package:flutter/material.dart';
// import 'screens/profile_page.dart';



// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Profil Demo',
//       home: const ProfilePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// MAIN UNTUK CRUD ADMIN
import 'package:flutter/material.dart';
import 'screens/crud_menu_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CrudMenuScreen(),
  ));
}
