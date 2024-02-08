import 'package:pristine_sound/domain/repository/device_repository.dart';
import 'package:pristine_sound/domain/use_case/get_device_data/get_device_data.dart';

class GetDeviceDataImpl implements GetDeviceData {
  final DeviceRepository deviceRepository;

  const GetDeviceDataImpl({
    required this.deviceRepository,
  });

  @override
  Future<Map<String, dynamic>> execute() async {
    return await deviceRepository.getDeviceInfo();
  }

}