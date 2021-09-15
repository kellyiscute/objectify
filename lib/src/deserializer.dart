import 'dart:mirrors';

class Objectify {
  const Objectify();
}

bool isObjectifyClass(ClassMirror mirror) {
  try {
    mirror.metadata.firstWhere(
        (element) => element.type.simpleName == Symbol('Objectify'));
    return true;
  } catch (e) {
    return false;
  }
}

T deserialize<T>(Map data, [Type? t]) {
  late final ClassMirror mirror;
  if (T != dynamic) {
    mirror = reflectClass(T);
  } else {
    mirror = reflectClass(t!);
  }

  if (!isObjectifyClass(mirror)) {
    throw Exception('Not an Objectify class');
  }

  final fields = <MethodMirror>[];
  mirror.instanceMembers.forEach((key, value) {
    if (value.isGetter &&
        value.simpleName != Symbol('runtimeType') &&
        value.simpleName != Symbol('hashCode')) {
      fields.add(value);
    }
  });

  final cls = mirror.newInstance(Symbol.empty, []);

  final pattern = RegExp('^Symbol\\(\"(.*)\"\\)\$');
  fields.forEach((element) {
    final name =
        pattern.allMatches(element.simpleName.toString()).first.group(1);
    // type check here
    if (element.returnType.reflectedType == data[name].runtimeType) {
      cls.setField(element.simpleName, data[name]);
    } else {
      // check if nested type
      final childCls = reflectClass(element.returnType.reflectedType);
      if (isObjectifyClass(childCls)) {
        final type = childCls.reflectedType;
        cls.setField(element.simpleName, deserialize(data[name], type));
      } else {
        // throw exception if not objectify class && when type does not match
        throw Exception('type does not match');
      }
    }
  });

  return cls.reflectee;
}
