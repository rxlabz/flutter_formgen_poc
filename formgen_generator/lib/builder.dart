import 'package:build/build.dart';
import 'package:formgen_generator/src/form_generator.dart';
import 'package:source_gen/source_gen.dart';

import 'src/form_generator.dart';

Builder formGenerator(BuilderOptions options) =>
    SharedPartBuilder([FormGenerator()], 'form_generator');
