import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/model/weather_data.dart';
import '../api/fetch_weather.dart';

class GlobalController extends GetxController {
  // create various variables
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  // instance for them to the called
  RxBool checkLoading() => _isLoading;
  RxDouble getLatitude() => _latitude;
  RxDouble getLongitude() => _longitude;

  final weatherData = WeatherData().obs;

  WeatherData getData(){
    return weatherData.value;
  }

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    } else {
      getIndex();
    }
    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission? locationPermission;
    // bu iki satırı ben koydum.
    // LocationPermission permission;
    // permission = await Geolocator.requestPermission();
    // Location servisi aktive edildi mi ?
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error("Location not enabled");
    }
    // status of permission request
    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location permission are denied forever");
    } else if (locationPermission == LocationPermission.denied) {
      // request permission
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Location permission is denied");
      }
    }
    // getting current position
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      // update our latitude and longitude
      _latitude.value = value.latitude;
      _longitude.value = value.longitude;
      // calling our weaather api
      return FetchWeatherAPI()
          .processData(value.latitude, value.longitude)
          .then((value){
            weatherData.value = value;
            _isLoading.value = false;
      });
    });
  }
  RxInt getIndex(){
    return _currentIndex;
  }
}
