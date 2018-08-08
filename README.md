# cranium

Cranium

Experimentation of DSL for graphql in dart


## Example

A simple usage example:

```dart
final q = query("article", ss: [
  field("id"),
  field("slug"),
  field("description"),
  field("photo", args: {"size": new IntValue(500)})
]);
```
