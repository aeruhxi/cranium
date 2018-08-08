abstract class ASTSerializable {
  String serialize();
}

enum OperationType { query, mutation, subscription }

/* Input Values */
abstract class Value implements ASTSerializable {}

class VariableValue implements Value {
  String value;

  VariableValue(this.value);

  String serialize() {
    return value;
  }
}

class IntValue implements Value {
  int value;

  IntValue(this.value);

  String serialize() {
    return value.toString();
  }
}

class FloatValue implements Value {
  double value;

  FloatValue(this.value);

  String serialize() {
    return value.toString();
  }
}

class StringValue implements Value {
  String value;

  StringValue(this.value);

  String serialize() {
    return value.toString();
  }
}

class BooleanValue implements Value {
  bool value;

  BooleanValue(this.value);

  String serialize() {
    return value.toString();
  }
}

class NullValue implements Value {
  final value = null;

  String serialize() {
    return value.toString();
  }
}

class EnumValue implements Value {
  String value;

  EnumValue(value);

  String serialize() {
    return value;
  }
}

class ListValue implements Value {
  List<Value> value;

  ListValue(this.value);

  String serialize() {
    return "[" + listToString(value) + "]";
  }
}

class ObjectValue implements Value {
  Map<String, Value> value;

  ObjectValue(this.value);

  String serialize() {
    return "{" + mapToString(value) + "}";
  }
}

/* Variable Definition */
class VariableDefinition {
  String name;
  VariableType type;
  Value defaultValue;

  VariableDefinition(this.name, this.type, this.defaultValue);

  String serialize() {
    final defaultValueString = defaultValue?.serialize() ?? "";
    return name + ": " + type.serialize() + " = " + defaultValueString;
  }
}

/* Variable Types */
abstract class VariableType implements ASTSerializable {}

class NamedType implements VariableType {
  final String value;
  final bool nullable;

  NamedType(this.value, this.nullable);

  String serialize() {
    return value + (nullable ? ":" : "!");
  }
}

class ListType implements VariableType {
  final VariableType value;
  final bool nullable;

  ListType(this.value, this.nullable);

  String serialize() {
    return "[" + value.serialize() + "]" + (nullable ? "!" : "");
  }
}

/* Directives */
class Directive implements ASTSerializable {
  final String name;
  final Map<String, Value> arguments;

  Directive(this.name, this.arguments);

  String serialize() {
    final argumentsString =
        arguments.isEmpty ? "" : "(${mapToString(arguments)})";
    return "@" + name + argumentsString;
  }
}

/* Selection Set */
class SelectionSet implements ASTSerializable {
  List<Selection> selections;

  SelectionSet(this.selections);

  String serialize() {
    return "{ " + selections.map((s) => s.serialize()).join(" ") + " }";
  }
}

abstract class Selection implements ASTSerializable {}

class Field implements Selection {
  String alias;
  String name;
  final Map<String, Value> arguments;
  final List<Directive> directives;
  final SelectionSet selectionSet;

  Field(this.alias, this.name, this.arguments, this.directives,
      this.selectionSet);

  String serialize() {
    final aliasString = alias ?? "";
    final argumentsString =
        arguments == null ? "" : "(${mapToString(arguments)})";
    final directivesString =
        directives?.map((d) => d.serialize())?.join(" ") ?? "";
    final selectionSetString = selectionSet?.serialize() ?? "";
    return "$aliasString $name $argumentsString $directivesString $selectionSetString";
  }
}

/* Fragments */
class FragmentSpread implements Selection {
  String name;
  List<Directive> directives;

  FragmentSpread(this.name, this.directives);

  String serialize() {
    final directivesString = directives.map((d) => d.serialize()).join(" ");
    return "...$name $directivesString $directivesString";
  }
}

class InlineFragment implements Selection {
  String typeCondition;
  List<Directive> directives;
  SelectionSet selectionSet;

  InlineFragment(this.typeCondition, this.directives, this.selectionSet);

  String serialize() {
    final typeConditionString = typeCondition ?? "";
    final directivesString = directives.map((d) => d.serialize()).join(" ");
    return "...$typeConditionString $directivesString ${selectionSet.serialize()}";
  }
}

class FragmentDefinition implements ExecutableDefinition {
  String fragmentName;
  String typeCondition;
  List<Directive> directives = [];
  SelectionSet selectionSet;

  FragmentDefinition(this.fragmentName, this.typeCondition, this.directives,
      this.selectionSet);

  String serialize() {
    final directivesString = directives.map((d) => d.serialize()).join(" ");
    return "fragment $fragmentName $typeCondition $directivesString ${selectionSet.serialize()}";
  }
}

/* Operation Definition */
class OperationDefinition implements ExecutableDefinition {
  final OperationType operationType;
  final String name;
  final List<VariableDefinition> variableDefinitions;
  final List<Directive> directives;
  final SelectionSet selectionSet;

  OperationDefinition(this.operationType, this.name, this.variableDefinitions,
      this.directives, this.selectionSet);

  String serialize() {
    String operationTypeString;
    switch (operationType) {
      case OperationType.query:
        operationTypeString = "query";
        break;
      case OperationType.mutation:
        operationTypeString = "mutation";
        break;
      case OperationType.subscription:
        operationTypeString = "subscription";
        break;
    }
    ;
    final directivesString =
        directives?.map((d) => d.serialize())?.join(" ") ?? "";
    final variableDefinitionsString = (variableDefinitions?.isEmpty ?? true)
        ? ''
        : variableDefinitions.map((v) => v.serialize()).join(", ");

    return "$operationTypeString $name $variableDefinitionsString $directivesString ${selectionSet.serialize()}";
  }
}

abstract class ExecutableDefinition implements ASTSerializable {}

/* utils */
String mapToString(Map<String, ASTSerializable> value) =>
    value.keys.map((key) => key + ": " + value[key].serialize()).join(", ");
String listToString(List<ASTSerializable> value) =>
    value.map((v) => v.serialize()).join(", ");
