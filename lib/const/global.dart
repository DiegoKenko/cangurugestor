import 'package:cangurugestor/presentation/controller/auth_controller.dart';
import 'package:cangurugestor/presentation/controller/cuidador_controller.dart';
import 'package:cangurugestor/presentation/controller/gestor_controller.dart';
import 'package:cangurugestor/presentation/controller/responsavel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

const int opcaoInclusao = 1;
const int opcaoAlteracao = 2;
const int opcaoVisualizacao = 3;

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<AuthController>(
    () => AuthController(),
  );
  getIt.registerLazySingleton<GestorController>(
    () => GestorController(),
  );
  getIt.registerLazySingleton<ResponsavelController>(
    () => ResponsavelController(),
  );
  getIt.registerLazySingleton<CuidadorController>(
    () => CuidadorController(),
  );
}
