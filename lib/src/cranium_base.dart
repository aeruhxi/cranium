import "builder.dart";
import "ast.dart";

void main() {
  final q = query("article", ss: [
    field("id"),
    field("slug"),
    field("description"),
    field("photo", args: {"size": new IntValue(500)})
  ]);
  print(q.serialize());
}
