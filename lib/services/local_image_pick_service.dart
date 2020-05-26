// uncomment below to set mobile platform as default
export 'local_image_pick_service_mobile.dart'
    if (dart.library.html) 'local_image_pick_service_web.dart';

// uncomment below to set web platform as default
// export 'local_image_pick_service_web.dart'
//     if (dart.library.io) 'local_image_pick_service_mobile.dart';

// uncomment below so if platform is unidentified, placeholder as default
// export 'unsupported_storage.dart'
//     if (dart.library.html) 'local_image_pick_service_web.dart'
//     if (dart.library.io) 'local_image_pick_service_mobile.dart';