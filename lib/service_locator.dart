import 'package:get_it/get_it.dart';
import 'package:receiptscanner/services/auth_service.dart';
import 'package:receiptscanner/services/database_service.dart';

GetIt getIt = GetIt.instance;

void setupServiceLocator(){
	getIt.registerLazySingleton(() => AuthService());
	getIt.registerLazySingleton(() => DatabaseService());
}