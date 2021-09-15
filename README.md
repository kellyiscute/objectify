# Objectify
Turn any Map into your class object

## QuickStart
```dart

import "objectify/objectify.dart" as obj;

@Objectify()
class NestedModel {
  String? yay;
  int? nested;
}

@Objectify()
class SomeModel {
  bool? foo;
  String? bar;
}

void main() {
  final data = {}; // your data
  final model = obj.deserialize<SomeModel>(data);
  // OR
  final model2 = obj.deserialize(data, SomeModel);
  // They are actually the same!
}

```

## NOTICE
this package uses dart:mirrors, which means you will not be able to use AOT!

