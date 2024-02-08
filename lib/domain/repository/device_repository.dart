abstract interface class DeviceRepository {
  Future<Map<String, dynamic>> getDeviceInfo();
}