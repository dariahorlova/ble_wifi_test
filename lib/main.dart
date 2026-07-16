import 'package:ble_wifi_test/features/connect/cubit/ble_wifi_cubit.dart';
import 'package:ble_wifi_test/features/connect/repository/ble_repository.dart';
import 'package:ble_wifi_test/features/connect/repository/common_repository.dart';
import 'package:ble_wifi_test/features/connect/services/ble_service.dart';
import 'package:ble_wifi_test/features/connect/services/internet_service.dart';
import 'package:ble_wifi_test/features/connect/services/nfc_service.dart';
import 'package:ble_wifi_test/features/connect/services/wifi_service.dart';
import 'package:ble_wifi_test/features/connect/view/main_screen.dart';
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
      child: const MaterialApp(home: MainScreen()),
    );
  }
}
