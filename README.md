Snark parser
============

Snark parser component with PEG.js

Currently under pre-alpha, very naive implementation.

## Test

```
$ npm install && npm test
```

## Milestones

### Syntax

- [x] Line break semantics

- [ ] Literal

  - [ ] Identifier

    - [x] Normal identifier

    - [ ] Exclude reserved keywords

    - [ ] Private identifier

      - [x] Basic identifier

      - [ ] Uint-like identifier

      - [ ] Computed property identifier

  - [x] Keyword literal

  - [x] Number literal

    - [x] Decimal literal

    - [x] Exponent

    - [x] Hex/Octal/Binary literal

    - [x] Ignore `_`

  - [ ] String literal

    - [x] Single line

    - [ ] Single line across multiple source line

    - [ ] Multiple line

  - [ ] Template string literal

    - [ ] Single line

    - [ ] Single line across multiple source line

    - [ ] Multi line

  - [ ] Object literal

    - [x] Detect curly brace

    - [x] Shorthand property

    - [x] Property with value

    - [ ] Spread property

  - [ ] Array literal

    - [x] Detect square bracket

    - [x] Element

    - [ ] Spread element

    - [ ] Key-value pair element

  - [ ] Range literal

    - [ ] Inclusive range

    - [ ] Exclusive range

  - [ ] Assignment pattern

    - [x] Identifier pattern

    - [x] Object pattern

    - [x] Array pattern

- [ ] Module

  - [ ] Export

    - [ ] Default export

    - [ ] Named export

    - [ ] Export with alias

    - [ ] Declaration export

    - [ ] Bypass export

  - [ ] Import

    - [ ] Restricted to top

    - [ ] Default import

    - [ ] Named import

    - [ ] Import with alias

    - [ ] Namespace import

    - [ ] Zero variable import

  - [ ] Import from environment

    - [ ] Import global object

    - [ ] Import global variable

    - [ ] Import well-known symbol

    - [ ] Import shortcut identifier

- [ ] Expression

  - [x] Arithmetic operator

  - [x] Logical operator

  - [ ] Comparison operator

  - [x] Function call

  - [x] Object property

  - [ ] Virtual method

  - [x] Collection getter

  - [x] Collection setter

  - [ ] Existential operator

    - [ ] Property access

    - [ ] Function call

    - [ ] Collection getter

    - [ ] Collection setter

  - [ ] Switch expression

    - [ ] Equality condition

    - [ ] Pattern matching condition

    - [ ] Non-param switch expression

  - [x] In operator

    - [x] Simple matching

    - [x] Matching with extraction

  - [ ] As operator

  - [ ] Function expression

    - [x] Single argument

    - [x] Multiple argument

    - [ ] Shorthand function

  - [ ] Do expression

    - [ ] Normal do expression

    - [ ] Async do expression

    - [ ] Generator do expression

  - [ ] Suspension expression

    - [ ] Yield

    - [ ] Await

  - [ ] Class

    - [ ] Class method

    - [ ] Class property

    - [ ] Static property

    - [ ] Class constructor

- [ ] Statement

  - [x] Assignment statement

  - [ ] Declaration statement

    - [x] Immutable variable

    - [x] Mutable variable

    - [x] Function declaration

    - [ ] Class declaration

  - [ ] If statement

    - [ ] Else block

  - [ ] While statement

  - [ ] For of statement

    - [ ] Async for-of statement

  - [ ] Enum statement
