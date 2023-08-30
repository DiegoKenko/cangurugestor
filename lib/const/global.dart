import 'package:cangurugestor/datasource/login/login_autenticar.dart';
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
  getIt.registerLazySingleton<LoginAuntenticarDatasource>(
    () => LoginAuntenticarDatasource(),
  );
}