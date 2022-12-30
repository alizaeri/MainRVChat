import 'package:camera/camera.dart';

class CameraManager {
  // Declare your camera list here
  List<CameraDescription> _cameras = <CameraDescription>[];

  // Constructor
  CameraManager._privateConstructor();

  // initialise instance
  static final CameraManager instance = CameraManager._privateConstructor();

  // Add a getter to access camera list
  List<CameraDescription> get cameras => _cameras;

  // Init method
  init() async {
    try {
      _cameras = await availableCameras();
      print(
          '99999999999999999999999999999999999999999999999999999999999999$_cameras');
    } on CameraException catch (e) {
      print('${e.code}, ${e.description}');
    }
  }

  // other needed methods to manage camera

}
