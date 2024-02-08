import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import '../../domain/repository/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository{

  @override
  Future<Map<String, dynamic>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } catch(error) {
      deviceData = {
        "Error": "Failed to get platform version."
      };
    }

    return deviceData;
  }

  Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
    var release = info.version.release;
    var manufacturer = info.manufacturer;
    var model = info.model;

    return {
      "version": release,
      "device": "$manufacturer $model",
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
    var systemName = info.systemName;
    var version = info.systemVersion;
    var machine = info.utsname.machine;

    return {
      "version": version,
      "device": machine,
    };
  }
}