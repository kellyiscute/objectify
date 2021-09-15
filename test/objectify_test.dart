import 'package:objectify/objectify.dart';

@Objectify()
class SuperCls {
  String? test2;
}

@Objectify()
class Test extends SuperCls {
  String? test;
  Nested? a;
}

@Objectify()
class Nested {
  bool? b;
}

void main() {
  final data = {
    'test2': 'sdf',
    'test': '',
    'a': {'b': true}
  };
  final cls = deserialize<Test>(data);
  print(cls.a!.b);
}
