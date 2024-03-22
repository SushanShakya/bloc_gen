import 'package:analyzer/dart/element/element.dart';
import 'package:bloc_gen/annotation/endpoint_annotation.dart';
import 'package:bloc_gen/generators/code_generator/repo_code_generator.dart';
import 'package:bloc_gen/utils/endpoint_annotation_utils.dart';
import 'package:bloc_gen/utils/repo_utils.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

import 'code_generator/cubit_code_generator.dart';
import 'code_generator/interface_code_generator.dart';

class EndpointGenerator extends GeneratorForAnnotation<Endpoint> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final metadata = EndpointMetadata.fromAnnotation(element, annotation);
    final repo = FunctionMetadata.fromEndpointMetadata(metadata);

    String sourceFilePath =
        element.source!.fullName.split('/').skip(2).join("/");

    String fileName = buildStep.inputId.pathSegments.last;

    final codeGenerators = [
      RepoCodeGenerator(),
      CubitCodeGenerator(sourceFileName: fileName.replaceAll('.dart', '')),
      InterfaceCodeGenerator(),
    ];

    for (var generator in codeGenerators) {
      final code = generator.generateCode(metadata, repo);

      String outputFilePath = sourceFilePath.replaceAll(
        '.dart',
        generator.fileExtension,
      );

      final output = DartFormatter().format(code);

      // if (generator is! RepoCodeGenerator) {
      //   try {
      //     final prevGeneratedCode = await readPreviousGeneratedCode(
      //       buildStep,
      //       outputFilePath,
      //     );

      //     print('--- OLD CODE');
      //     print(prevGeneratedCode);

      //     print('--- NEW CODE');
      //     print(output);

      //     if (prevGeneratedCode != output) {
      //       buildStep.
      //       continue;
      //     }
      //   } on AssetNotFoundException {
      //     // If File doesn't exists you shold probably create it
      //     print('----- Asset Not Found Exception');
      //   }
      // }

      try {
        await buildStep.writeAsString(
          AssetId(buildStep.inputId.package, outputFilePath),
          output,
        );
      } on InvalidOutputException catch (e) {
        print('Error type');
        print(e.runtimeType);
        throw Exception(
          "Do not include multiple @Endpoint() annotation in same file",
        );
      }
    }
  }

  Future<String> readPreviousGeneratedCode(
    BuildStep buildStep,
    String path,
  ) async {
    print(buildStep.inputId.package);
    print(path);

    // Logic to determine the path of the previous generated source file
    // Adjust the path or filename as needed
    final previousGeneratedAssetId = AssetId(
      buildStep.inputId.package,
      path,
    );
    // Read the previous generated source code
    return await buildStep.readAsString(previousGeneratedAssetId);
  }
}
