import 'package:ble_wifi_test/features/connect/cubit/ble_wifi_cubit.dart';
import 'package:ble_wifi_test/features/connect/repository/ble_repository.dart';
import 'package:ble_wifi_test/features/connect/repository/common_repository.dart';
import 'package:ble_wifi_test/features/connect/services/ble_service.dart';
import 'package:ble_wifi_test/features/connect/services/internet_service.dart';
import 'package:ble_wifi_test/features/connect/services/nfc_service.dart';
import 'package:ble_wifi_test/features/connect/services/wifi_service.dart';
import 'package:ble_wifi_test/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BleWifiCubit>(
      create: (context) => BleWifiCubit(
        CommonRepository(NFCService(), WifiService(), InternetService()),
        BleRepository(BLEService()),
      ),
      child: MaterialApp(
        home: MainScreen(),
        theme: ThemeData(
          dividerColor: Colors.black.withAlpha(20),
          chipTheme: ChipThemeData(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black.withAlpha(20), width: 2),
              borderRadius: BorderRadiusGeometry.circular(24),
            ),
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: .w600,
              color: Colors.black.withAlpha(140),
            ),
          ),
        ),
      ),
    );
  }
}
