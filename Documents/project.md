---
name: Thomsen Clang-Format Customizations
description: Complete list of all custom features in the Thomsen clang-format build, ported from LLVM 11.1.0 to 22.1.0
type: project
---

# Thomsen Clang-Format Customizations

Custom clang-format build with 9 features added on top of upstream LLVM. Originally developed against LLVM 11.1.0 (`thomsen` branch), ported to LLVM 22.1.0 (`thomsen-22.1.0` branch).

## 1. Line Escape System (`//.`)

Lines ending with `//.` are protected from formatting. During token lexing, comment tokens ending with `//. ` cause all tokens on that line to be marked `Finalized`, which prevents clang-format from modifying their whitespace. No buffer modification or offset translation is needed.

- **Config**: Always active, no option required.
- **Files**: `FormatTokenLexer.cpp`

## 2. Double Break After Access Specifiers

Always inserts a blank line after `public:`, `protected:`, `private:` in classes/structs. Overrides the upstream `EmptyLineAfterAccessModifier` logic when enabled.

- **Config**: `AlwaysDoubleBreakAfterClassProtectionKeywords: true`
- **Files**: `Format.h`, `Format.cpp`, `UnwrappedLineFormatter.cpp`

## 3. Spaces Between Adjacent Delimiters

Inserts spaces between adjacent opening delimiters (`((`, `{{`, `[[`) and adjacent closing delimiters (`))`, `}}`, `]]`). Example: `if( ( a < b ) )` instead of `if(( a < b ))`.

- **Config**: `SpacesBetweenParenthesesBracketsAndBraces: true`
- **Files**: `Format.h`, `Format.cpp`, `TokenAnnotator.cpp`

## 4. Spaces After Empty Args / Before Empty Brackets

Inserts a space after `()` (empty argument list) when followed by a closing delimiter, and between `(` and `[` when `[` is followed by `]` (empty brackets). Example: `( f() )` instead of `( f())`.

- **Config**: `SpacesAfterEmptyArgsAndBeforeEmptyBrackets: true`
- **Files**: `Format.h`, `Format.cpp`, `TokenAnnotator.cpp`

## 5. `InlineOnly` Short Lambda Style

New enum value for `AllowShortLambdasOnASingleLine`. Lambdas used as function arguments may stay on one line, but standalone lambdas (assigned to variables, etc.) always get Allman-style brace placement.

- **Config**: `AllowShortLambdasOnASingleLine: InlineOnly`
- **Files**: `Format.h`, `Format.cpp`, `TokenAnnotator.cpp`

## 6. Lambda Formatting Fixes (ColumnLimit: 0 + BeforeLambdaBody)

Fixes broken lambda formatting when combining Allman braces with unlimited line width. Three changes:

- **mustBreak**: When ColumnLimit==0, inspects whether the lambda body has newlines to decide Allman vs single-line (instead of comparing body length to 0).
- **moveStateToNewBlock**: Sets `BreakBeforeClosingBrace = true` when the opening `{` was placed on its own line.
- **formatChildren**: Forces block formatting when the brace was placed on its own line, preventing "half-Allman" output.

- **Config**: Uses existing `BraceWrapping.BeforeLambdaBody: true`, `ColumnLimit: 0`, `LambdaBodyIndentation: OuterScope`
- **Files**: `ContinuationIndenter.cpp`, `UnwrappedLineFormatter.cpp`

## 7. Dot-Operator Continuation Indent

When a `.` (dot operator) starts a continuation line, indentation is calculated relative to the original column of the expression's starting line plus `ContinuationIndentWidth`. Produces cleaner chained method call alignment:

```cpp
someObject.method1()
    .method2()
    .method3();
```

- **Config**: Uses standard `ContinuationIndentWidth` (no new option)
- **Files**: `ContinuationIndenter.cpp`

## 8. AfterAssignment Brace Wrapping

New `BraceWrapping` flag. When a braced initializer list after `=` is multi-line, the opening brace wraps to the next line (Allman-style). Single-line initializer lists are unaffected.

```cpp
auto x =
{
    1, 2, 3
};
```

- **Config**: `BraceWrapping.AfterAssignment: true`
- **Files**: `Format.h`, `Format.cpp`, `TokenAnnotator.cpp`, `UnwrappedLineParser.cpp`

## 9. "Thomsen" Predefined Style

Registers `"thomsen"` as a recognized base style name. It loads LLVM defaults as the starting point, then the user's `.clang-format` overrides apply the custom options above.

- **Config**: `BasedOnStyle: Thomsen`
- **Files**: `Format.cpp`
