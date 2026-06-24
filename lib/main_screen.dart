import 'package:ble_wifi_test/features/connect/cubit/ble_wifi_cubit.dart';
import 'package:ble_wifi_test/views/empty_view.dart';
import 'package:ble_wifi_test/views/reader_device_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BleWifiCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reader Tools'),
        actions: [
          IconButton(
            onPressed: () => cubit.searchBLE(),
            icon: const Icon(Icons.bluetooth_searching),
          ),
          IconButton(onPressed: cubit.launchNFC, icon: const Icon(Icons.nfc)),
        ],
      ),
      body: BlocBuilder<BleWifiCubit, BleWifiState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(child: _buildDeviceList(context, state, cubit)),
              Visibility(
                visible: state.hintText.isNotEmpty,
                child: SafeArea(
                  minimum: EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: SafeArea(
                      child: Text(
                        state.hintText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDeviceList(
    BuildContext context,
    BleWifiState state,
    BleWifiCubit cubit,
  ) {
    const initialMessage = 'No readers here... Tap & connect one!';

    if (state.devices.isEmpty) {
      return EmptyView(text: initialMessage);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: state.devices.length,
      itemBuilder: (context, index) {
        final device = state.devices[index];
        return ReaderDeviceView(reader: device, cubit: cubit);
      },
    );
  }
}
