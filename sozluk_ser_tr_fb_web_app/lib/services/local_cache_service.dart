// Platforma göre doğru implementasyonu export eder
export 'local_cache_service_io.dart'
    if (dart.library.html) 'local_cache_service_web.dart';
