// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/_core/app_theme.dart';
import 'ui/widgets/auth/auth_provider.dart';
import 'ui/widgets/bag_provider.dart';
import 'ui/widgets/splash/splash_screen.dart';
import 'data/hotel_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HotelData hotelData = HotelData();
  await hotelData.getDestinations();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: hotelData),
        ChangeNotifierProvider(create: (context) => BagProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'S&M Hotel',
      theme: AppTheme.appTheme,
      home: const SplashScreen(),
    );
  }
}

