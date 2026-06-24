import 'package:ble_wifi_test/features/connect/cubit/ble_wifi_cubit.dart';
import 'package:ble_wifi_test/features/connect/enums/reader_connection.dart';
import 'package:ble_wifi_test/features/connect/models/device_booklets.dart';
import 'package:ble_wifi_test/features/connect/models/device_config.dart';
import 'package:ble_wifi_test/features/connect/models/reader_device.dart';
import 'package:flutter/material.dart';

const _defaultDeviceName = 'Unknown Device';
const _defaultNoValue = 'UNDEFINED';

class ReaderDeviceView extends StatelessWidget {
  final BleWifiCubit cubit;
  final ReaderDevice reader;

  const ReaderDeviceView({
    super.key,
    required this.reader,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: .hardEdge,
      child: InkWell(
        onTap: reader.isConnected ? null : () => cubit.connectToDevice(reader),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            _buildHeaderTile(),
            const _ReaderCardDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildConfig(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTile() {
    final deviceName = reader.name;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Text(
                deviceName.isEmpty ? _defaultDeviceName : deviceName,
                style: TextStyle(fontWeight: .w600, fontSize: 18),
              ),
              const SizedBox(width: 8),
              _ConnectionTypeView(type: reader.connection),
            ],
          ),
        ),
        const _ReaderCardDivider(),
        _ReaderControls(cubit: cubit, reader: reader),
      ],
    );
  }

  Widget _buildConfig() {
    final config = reader.config;

    if (config == null) {
      return _ReaderConfigTile(
        title: 'Bluetooth ID',
        subtitle: reader.id,
        iconData: Icons.bluetooth,
      );
    }

    return _DeviceConfigView(config: config);
  }
}

class _ReaderControls extends StatelessWidget {
  final BleWifiCubit cubit;
  final ReaderDevice reader;

  const _ReaderControls({required this.cubit, required this.reader});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: .spaceEvenly,
      children: [
        if (reader.isBleConnected) ...[
          IconButton(
            icon: const Icon(Icons.connect_without_contact),
            onPressed: () => cubit.getDeviceConfig(reader),
          ),
          IconButton(
            icon: const Icon(Icons.wifi),
            onPressed: cubit.connectUsingWiFi,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: cubit.disconnectBLE,
          ),
        ],
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Colors.red,
          onPressed: () => cubit.deleteReaderFromCache(reader),
        ),
      ],
    );
  }
}

class _DeviceConfigView extends StatelessWidget {
  final DeviceConfig config;

  const _DeviceConfigView({required this.config});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReaderConfigTile(
          title: 'Bluetooth ID',
          subtitle: config.readerBleId ?? _defaultNoValue,
          iconData: Icons.bluetooth,
        ),
        _ReaderConfigTile(
          title: 'ID',
          subtitle: config.readerId,
          iconData: Icons.numbers,
        ),
        _ReaderConfigTile(
          title: '${config.batteryLevel}%',
          iconData: Icons.battery_3_bar,
        ),
        _ReaderConfigTile(
          title: 'Free storage',
          subtitle: '${config.remainingStorageMb} Mb',
          iconData: Icons.sd_storage,
        ),
        _ReaderConfigTile(
          title: 'Firmware',
          subtitle: config.firmwareVersion ?? _defaultNoValue,
          iconData: Icons.memory,
        ),
        _ReaderConfigTile(
          title: 'Inserted Booklet',
          subtitle: config.currentStoryKey ?? _defaultNoValue,
          iconData: Icons.book,
        ),
        ...?config.booklets?.map((e) => _ReaderBookletView(booklet: e)),
      ],
    );
  }
}

class _ReaderConfigTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? iconData;

  const _ReaderConfigTile({
    required this.title,
    this.subtitle,
    this.iconData = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
    );
  }
}

class _ReaderBookletView extends StatelessWidget {
  final DeviceBooklet booklet;

  const _ReaderBookletView({required this.booklet});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.book_outlined),
      title: Text(booklet.id),
      subtitle: Text('booklet'),
      children: [
        if (booklet.variantIds.isEmpty)
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('No variants stored'),
            ),
          )
        else
          ...booklet.variantIds.map(
            (e) => Padding(
              padding: EdgeInsets.only(left: 16),
              child: ListTile(
                leading: Icon(Icons.audio_file),
                title: Text(e, maxLines: 1, overflow: .ellipsis),
              ),
            ),
          ),

        if (booklet.customRecordings.isEmpty)
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('No custom variants stored'),
            ),
          )
        else
          ...booklet.customRecordings.map(
            (e) => Padding(
              padding: EdgeInsets.only(left: 16),
              child: ListTile(
                leading: Icon(Icons.audiotrack_outlined),
                title: Text(e),
              ),
            ),
          ),
      ],
    );
  }
}

class _ConnectionTypeView extends StatelessWidget {
  final ReaderConnection type;

  const _ConnectionTypeView({required this.type});

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ReaderConnection.none => Chip(label: Text('Disconnected')),
      ReaderConnection.ble => Icon(Icons.bluetooth, color: Colors.blue),
      ReaderConnection.wifi => Icon(Icons.wifi, color: Colors.green),
    };
  }
}

class _ReaderCardDivider extends StatelessWidget {
  const _ReaderCardDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(color: Colors.black.withAlpha(20), thickness: 1, height: 0);
  }
}
