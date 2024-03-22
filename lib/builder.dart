import "package:bloc_gen/generators/endpoint_generator.dart";
import "package:build/build.dart";
import "package:source_gen/source_gen.dart";

Builder blocGenBuilder(BuilderOptions options) {
  return LibraryBuilder(
    EndpointGenerator(),
    additionalOutputExtensions: [
      ".interface.dart",
      ".cubit.dart",
      ".repo.dart",
    ],
  );
}
