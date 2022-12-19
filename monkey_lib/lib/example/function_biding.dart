// ignore: prefer_function_declarations_over_variables
// Function.apply(foo, [1, 2, 3], {#d: 4, #e: 5});
void foo(int a, int b, int c, {required int d, required int e}) {
  print("{$a} {$b} {$c} {$d} {$e}");
  return;
}
