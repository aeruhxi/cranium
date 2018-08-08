import "ast.dart";

VariableDefinition variable(String name,
        {VariableType t, Value defaultValue}) =>
    new VariableDefinition(name, t, defaultValue);

VariableType named(String name, {bool nullable = true}) =>
    new NamedType(name, nullable);

VariableType list(NamedType namedType, {bool nullable = false}) =>
    new ListType(namedType, nullable);

Directive dir(String name, {Map<String, Value> args}) =>
    new Directive(name, args);

Field field(String name,
        {String alias,
        Map<String, Value> args,
        List<Directive> dirs,
        SelectionSet ss}) =>
    new Field(alias, name, args, dirs, ss);

FragmentSpread fragmentSpread(String name, {List<Directive> dirs}) =>
    new FragmentSpread(name, dirs);

InlineFragment inlineFragment(
        {String on, List<Directive> dirs, SelectionSet ss}) =>
    new InlineFragment(on, dirs, ss);

OperationDefinition _op(
    OperationType t,
    String n,
    List<VariableDefinition> variables,
    List<Directive> directives,
    List<Selection> ss) {
  return new OperationDefinition(
      t, n, variables, directives, new SelectionSet(ss));
}

OperationDefinition query(String n,
        {List<VariableDefinition> variables,
        List<Directive> directives,
        List<Selection> ss}) =>
    _op(OperationType.query, n, variables, directives, ss);

OperationDefinition mutation(String n,
        {List<VariableDefinition> variables,
        List<Directive> directives,
        List<Selection> ss}) =>
    _op(OperationType.mutation, n, variables, directives, ss);
