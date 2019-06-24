import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:formgen_lib/formgen_lib.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/type.dart';

class FormGenerator extends GeneratorForAnnotation<RXForm> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    return _generateTargetCode(element);
  }

  String _generateTargetCode(Element element) {
    final visitor = FormModelVisitor();
    element.visitChildren(visitor);
    final widgetName = visitor.className.name.split('Model').first;

    final emitter = DartEmitter();

    final result = StringBuffer();

    final genClass = Class((b) => b
      ..name = widgetName
      ..extend = refer('StatefulWidget', 'package:flutter/material.dart')
      ..fields.add(Field((f) => f
        ..name = 'model'
        ..modifier = FieldModifier.final$
        ..type = refer(visitor.className.name)))
      ..constructors.add(
        Constructor(
          (c) => c
            ..requiredParameters.add(
              Parameter((p) => p
                ..name = 'model'
                ..toThis = true),
            ),
        ),
      )
      ..methods.add(Method(
        (m) => m
          ..annotations.add(CodeExpression(Code('override')))
          ..name = 'createState'
          ..returns = refer('_${widgetName}State')
          ..lambda = true
          ..body = Code('_${widgetName}State()'),
      )));

    result.writeln(DartFormatter().format('${genClass.accept(emitter)}'));

    final stateGen = Class(
      (c) => c
        ..name = "_${widgetName}State"
        ..extend = TypeReference((r) => r
          ..symbol = 'State'
          ..types.add(refer(widgetName)))
        ..fields.addAll([
          Field((f) => f
            ..name = '_formKey'
            ..modifier = FieldModifier.final$
            ..type = refer('GlobalKey<FormState>')
            ..assignment = Code('GlobalKey<FormState>()')),
          ...visitor.fields.keys.map(
            (name) => Field(
              (f) => f
                ..name = '${name}Controller'
                ..type = refer('TextEditingController'),
            ),
          ),
          Field((f) => f
            ..name = '_autovalidate'
            ..type = refer('bool')
            ..assignment = Code('false'))
        ])
        ..methods.addAll([
          Method.returnsVoid(
            (m) => m
              ..name = 'initState'
              ..annotations.add(CodeExpression(Code('override')))
              ..body = Block.of([
                for (var field in visitor.fields.keys)
                  Code('${field}Controller = TextEditingController();'),
                refer('super.initState').call([]).statement
              ]),
          ),
          _computeBuildMethod(visitor, emitter),
        ]),
    );

    result.writeln(DartFormatter().format('${stateGen.accept(emitter)}'));

    return result.toString();
  }

  Method _computeBuildMethod(FormModelVisitor visitor, DartEmitter emitter) {
    return Method(
      (m) {
        final fieldColumn =
            refer('ListView', 'package:flutter/material.dart').call([], {
          'children': literalList([
            for (String field in visitor.fields.keys)
              refer('TextFormField').call([], {
                'key': refer('Key').call([literalString('${field}Field')]),
                'controller': refer('${field}Controller'),
                if (visitor.obscureFields.contains(field))
                  'obscureText': literalBool(true),
                'decoration': refer('InputDecoration').call(
                  [],
                  {'labelText': literalString(capitalize(field))},
                ),
                if (visitor.requiredFields.contains(field))
                  'validator': CodeExpression(
                    Code('widget.model.${field}Validator'),
                  ),
                'onSaved': CodeExpression(
                    Code('(value) => widget.model.$field = value')),
                if (visitor.requiredFields.contains(field))
                  'autovalidate': refer('_autovalidate'),
              }).code,
            refer('RaisedButton').call([], {
              'child': refer('Text').call([literalString('Submit')]),
              'onPressed': CodeExpression(Code('(){'
                  'if (_formKey.currentState.validate()) {'
                  '_formKey.currentState.save();'
                  'widget.model.onSubmit();'
                  '} else setState(() => _autovalidate = true);'
                  '}'))
            })
          ])
        });
        final form = refer('Form', 'package:flutter/material.dart').call(
            [], {'key': refer('_formKey'), 'child': fieldColumn}).statement;

        return m
          ..name = 'build'
          ..requiredParameters.add(Parameter((p) => p
            ..name = 'context'
            ..type = refer('BuildContext')))
          ..annotations.add(CodeExpression(Code('override')))
          ..returns = refer('Widget', 'package:flutter/material.dart')
          ..body = Code('return ${form.accept(emitter).toString()}');
      },
    );
  }
}

String capitalize(String value) {
  if (value.isEmpty) return value;
  final list = value.split('');
  list.first = list.first.toUpperCase();
  return list.join();
}

class FormModelVisitor extends SimpleElementVisitor {
  DartType className;
  Map<String, DartType> fields = {};
  List<String> requiredFields = [];
  List<String> obscureFields = [];

  @override
  visitConstructorElement(ConstructorElement element) {
    className = element.type.returnType;
  }

  @override
  visitFieldElement(FieldElement element) {
    if (element.getter != null && element.getter.isSynthetic) {
      fields[element.name] = element.type;
      if (element.hasRequired) requiredFields.add(element.name);
      for (var meta in element.metadata) {
        if (meta.element is PropertyAccessorElement &&
            meta.element.name == 'obscure') obscureFields.add(element.name);
      }
    }
  }
}
