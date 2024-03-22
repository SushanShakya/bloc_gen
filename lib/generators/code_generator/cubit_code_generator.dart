import 'package:bloc_gen/annotation/endpoint_annotation.dart';
import 'package:bloc_gen/generators/code_generator/interface/icode_generator.dart';
import 'package:bloc_gen/generators/code_generator/interface_code_generator.dart';
import 'package:bloc_gen/utils/endpoint_annotation_utils.dart';
import 'package:bloc_gen/utils/repo_utils.dart';

class CubitCodeGenerator implements ICodeGenerator {
  final String sourceFileName;

  CubitCodeGenerator({required this.sourceFileName});

  @override
  String generateCode(
    EndpointMetadata metadata,
    FunctionMetadata fnData,
  ) {
    final interfaceCodeGenerator = InterfaceCodeGenerator();
    final className = generateClassName(metadata);
    final fnName = metadata.functionName;
    final suffix =
        (metadata.requestType == RequestType.get) ? "Loaded" : "Success";
    final dataClassName = metadata.className + suffix;

    return """
        import 'package:warped_bloc/warped_bloc.dart';
        import './$sourceFileName${interfaceCodeGenerator.fileExtension}';

        class $dataClassName extends DataState {
          const $dataClassName({required super.data});
        }

        class $className extends AsyncCubit {
          final ${interfaceCodeGenerator.generateClassName(metadata)} repo;
          $className({
            required this.repo,
          });

          $fnName() {
            handleDefaultStates(() async {
              final data = await repo.$fnName();
              emit($dataClassName(data: data));
            });
          }
        }

    """;
  }

  @override
  String generateClassName(EndpointMetadata metadata) {
    return "${metadata.className}Cubit";
  }

  @override
  String get fileExtension => ".cubit.dart";
}
