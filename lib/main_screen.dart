import 'package:ble_wifi_test/features/connect/cubit/ble_wifi_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/connect/models/device_booklets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color cardColor(BleWifiState state, int index) {
    var color = index == state.currentDeviceIndex
        ? Colors.green.shade100
        : Colors.blue.shade100;
    if (state.isWifiConnected && index == state.currentDeviceIndex) {
      color = Colors.red.shade100;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BleWifiCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE wifi test'),
        actions: [
          IconButton(onPressed: cubit.launchNFC, icon: const Icon(Icons.nfc)),
        ],
      ),
      body: BlocBuilder<BleWifiCubit, BleWifiState>(
        builder: (context, state) {
          return Padding(
            // Додамо трохи падінгів для гарного вигляду
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: state.devices.isEmpty
                      ? Center(
                          child: Text(
                            state.status == BleWifiStatus.loading
                                ? ''
                                : 'Nothing was found, try again',
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.devices.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                titleAlignment: ListTileTitleAlignment.top,
                                tileColor: cardColor(state, index),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                  state.devices[index].advName.isEmpty
                                      ? 'Unknown Device'
                                      : state.devices[index].advName,
                                ),
                                subtitle: state.deviceConfig == null
                                    ? Text(state.devices[index].remoteId.str)
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.deviceConfig?.readerBleId ??
                                                'not assigned',
                                          ),
                                          Text(
                                            'Reader ID:${state.deviceConfig?.readerId ?? 'not assigned'}',
                                          ),
                                          Text(
                                            'Battery :${state.deviceConfig?.batteryLevel ?? 'not assigned'}',
                                          ),
                                          Text(
                                            'Free storage :${state.deviceConfig?.remainingStorageMb ?? 'not assigned'}',
                                          ),
                                          Text(
                                            'Firmware :${state.deviceConfig?.firmwareVersion ?? 'not assigned'}',
                                          ),
                                          Text(
                                            'Current booklet :${state.deviceConfig?.currentStoryKey ?? 'not assigned'}',
                                          ),
                                          Text('Reader booklets:'),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                            ),
                                            child: Column(
                                              children:
                                                  state.deviceConfig?.booklets
                                                      ?.map(
                                                        (e) => readerBooks(e),
                                                      )
                                                      .toList() ??
                                                  [SizedBox.shrink()],
                                            ),
                                          ),
                                        ],
                                      ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.connect_without_contact,
                                      ),
                                      onPressed: () =>
                                          cubit.getDeviceConfigByBle(),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: cubit.disconnectBLE,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.wifi),
                                      onPressed: cubit.makeMagic,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 16),
                Visibility(
                  visible: state.hintText.isNotEmpty,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      state.hintText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget readerBooks(DeviceBooklets data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data.id),
        Text('Variants'),

        if (data.variantIds.isEmpty)
          Padding(padding: EdgeInsets.only(left: 4), child: Text('-'))
        else
          ...data.variantIds.map(
            (e) => Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                e,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),

        Text('Customs'),
        if (data.customRecordings.isEmpty)
          Padding(padding: EdgeInsets.only(left: 4), child: Text('-'))
        else
          ...data.customRecordings.map(
            (e) => Padding(padding: EdgeInsets.only(left: 4), child: Text('e')),
          ),
        Text('--------------'),
      ],
    );
  }
}
