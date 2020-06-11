import 'package:get_it/get_it.dart';
import 'package:image_list/services/authentication_service.dart';
import 'package:image_list/services/localstorage_service.dart';
import 'package:image_list/services/temp_user_service.dart';
// import 'package:compound/services/navigation_service.dart';
// import 'package:compound/services/dialog_service.dart';

GetIt getIt = GetIt.instance;

Future setupLocator() async {
  getIt.registerSingleton<UserService>(UserService());
  getIt.registerLazySingleton(() => AuthenticationService());
  getIt.registerSingleton<LocalStorageService>(LocalStorageService());
 
  // getIt.registerSingleton(() => UserService());
//   locator.registerLazySingleton(() => NavigationService());
//   locator.registerLazySingleton(() => DialogService());

  // var instance = await LocalStorageService.getInstance();
  // getIt.registerSingleton<LocalStorageService>(instance);

}
