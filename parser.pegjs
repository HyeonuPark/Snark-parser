{
  function take (array, index) {
    return array.map(el => el[index])
  }

  function list (head, tail) {
    return [head, ...take(tail, 1)]
  }
}

File
= WL program:Program WL {
  return {
    type: 'File',
    program
  }
}

Program
= body:StatementList {
  return {
    type: 'Program',
    body
  }
}

Statement
= AssignmentStatement
/ CompoundAssignmentStatement
/ DeclarationStatement
/ IfStatement
/ WhileStatement
/ ForOfStatement
/ EnumStatement
/ Expression

AssignmentStatement
= target:AssignmentPattern PD '=' PD value:Expression {
  return {
    type: 'AssignmentStatement',
    target,
    value
  }
}
/ target:AssignTargetProperty PD '=' PD value:Expression {
  return {
    type: 'AssignmentStatement',
    target,
    value
  }
}

CompoundAssignmentStatement
= target:(Identifier / AssignTargetProperty) operator:[\+\-\*\/] '=' expr:Expression {
  return {
    type: 'CompoundAssignmentStatement',
    target,
    operator
  }
}

AssignTargetProperty
= obj:Expression WL '.' PD name:Identifier {
  type: 'AssignTargetProperty',
  obj,
  name
}

DeclarationStatement
= VariableDeclaration
/ FunctionDeclaration
// ClassDeclaration

IfStatement
= 'if' WS condition:Expression PD '{' WL body:StatementList WL '}' fallback:ElseClause? {
  return {
    type: 'IfStatement',
    condition,
    body,
    fallback
  }
}

ElseClause
= PD 'else' PD body:StatementBlock {
  return body
}

WhileStatement
= 'while' condition:Expression body:StatementBlock {
  return {
    type: 'WhileStatement',
    condition,
    body
  }
}

ForOfStatement
= 'for' WS isAsync:('async' WS)? element:AssignmentPattern PD 'of' PD iterable:Expression body:StatementBlock {
  return {
    type: 'ForOfStatement',
    isAsync,
    element,
    iterable,
    body
  }
}

EnumStatement
= 'enum' id:Identifier? '{' WL enumhead:PublicIdentifier tail:(WkSep PublicIdentifier)* WL '}' {
  return {
    type: 'EnumStatement',
    id,
    body: list(enumhead, tail)
  }
}

AssignmentPattern
= ObjectPattern
/ ArrayPattern
/ VariablePattern

ObjectPattern
= '{' WL objhead:PropertyPattern tail:(WkSep PropertyPattern)* WL '}' {
  return {
    type: 'ObjectPattern',
    body: list(objhead, tail)
  }
}

PropertyPattern
= property:Identifier WS 'as' WS pattern:AssignmentPattern {
  return {
    type: 'PropertyPattern',
    property,
    pattern
  }
}
/ property:Identifier {
  return {
    type: 'PropertyPattern',
    property,
    pattern: {
      type: 'VariablePattern',
      id: property
    }
  }
}

ArrayPattern
= '[' WL arrhead:AssignmentPattern tail:(WkSep AssignmentPattern)* WL ']' {
  return {
    type: 'ArrayPattern',
    body: list(arrhead, tail)
  }
}

VariablePattern
= mut:('mut' WS)? id:Identifier {
  return {
    type: 'VariablePattern',
    isMutable: Boolean(mut),
    id
  }
}

VariableDeclaration
= 'let' PD target:AssignmentPattern PD '=' PD init:Expression {
  return {
    type: 'VariableDeclaration',
    target,
    init
  }
}

Expression
= LogicalBinaryExpression

LogicalBinaryExpression
= head:LogicalNegateExpression tail:(PD ('and' / 'or') PD LogicalNegateExpression)* {
  return tail.reduce(function (left, [, operator, , right]) {
    return {
      type: 'LogicalBinaryExpression',
      operator,
      left,
      right
    }
  }, head)
}

LogicalNegateExpression
= 'not' PD expr:PatternInExpression {
  return {
    type: 'LogicalNegateExpression',
    expr
  }
}
/ PatternInExpression

PatternInExpression
= left:ArithmeticExpression PD 'in' PD right:ArithmeticExpression extract:(PD 'with' PD AssignmentPattern)? {
  return {
    type: 'BinaryInExpression',
    left,
    right,
    extract: extract && extract[3]
  }
}
/ ArithmeticExpression

ArithmeticExpression
= ArithmeticL3Expression

ArithmeticL3Expression
= left:ArithmeticL2Expression PD operator:('**') PD right:ArithmeticL2Expression {
  return {
    type: 'ArithmeticExpression',
    left,
    right,
    operator
  }
}
/ ArithmeticL2Expression

ArithmeticL2Expression
= left:ArithmeticL1Expression PD operator:('*' / '/') PD right:ArithmeticL1Expression {
  return {
    type: 'ArithmeticExpression',
    left,
    right,
    operator
  }
}
/ ArithmeticL1Expression

ArithmeticL1Expression
= left:ArithmeticNegateExpression PD operator:('+' / '-') PD right:ArithmeticNegateExpression {
  return {
    type: 'ArithmeticExpression',
    left,
    right,
    operator
  }
}
/ ArithmeticNegateExpression

ArithmeticNegateExpression
= '-' PD expr:AliasExpression {
  return {
    type: 'ArithmeticNegateExpression',
    expr
  }
}
/ AliasExpression

// FIXME
AliasExpression
// = alias expr syntax
= ChainExpression

ChainExpression
= head:LiteralExpression tail:ChainModifier* {
  return tail.reduce((left, right) => right(left), head)
}

ChainModifier
= FunctionCallModifier
/ ObjectPropertyModifier
// VirtualMethodModifier
/ CollectionGetterModifier
/ CollectionSetterModifier

LiteralExpression
= KeywordLiteral
/ FunctionExpression
/ Identifier
/ NumberLiteral
/ StringLiteral
// TemplateStringLiteral
/ ObjectLiteral
/ ArrayLiteral
// RangeLiteral
/ '(' WL expr:Expression WL ')' {
  return expr
}

FunctionCallModifier
= PD '(' WL args:ExpressionList WL ')' {
  return left => ({
    type: 'FunctionCallExpression',
    left,
    args
  })
}

ObjectPropertyModifier
= WL '.' PD name:Identifier {
  return left => ({
    type: 'ObjectPropertyExpression',
    left,
    name
  })
}

CollectionSetterModifier
= PD '[' WL key:Expression WL '->' WL value:Expression WL ']' {
  return left => ({
    type: 'CollectionSetterExpression',
    left,
    key,
    value
  })
}

CollectionGetterModifier
= PD '[' WL key:Expression WL ']' {
  return left => ({
    type: 'CollectionGetterExpression',
    left,
    key
  })
}

KeywordLiteral
= name:$('null' / 'true' / 'false' / '_') {
  return {
    type: 'KeywordLiteral',
    name
  }
}

NumberLiteral
= HexadecimalNumber
/ OctalNumber
/ BinaryNumber
/ DecimalNumber

DecimalNumber
= left:Integer '.' right:Integer exponent:ExponentPart? {
  return {
    type: 'NumberLiteral',
    radix: 10,
    value: `${left}.${right}${exponent || ''}`
  }
}
/ num:Integer exponent:ExponentPart? {
  return {
    type: 'NumberLiteral',
    radix: 10,
    value: `${num}${exponent || ''}`
  }
}

ExponentPart
= [Ee] num:Integer {
  return `e${num}`
}

Integer
= num:$(!'_' ('_'? [0-9])+) {
  return num.replace(/_/g, '')
}

HexadecimalNumber
= '0' [Xx] num:$(!'_' ('_'? [0-9a-fA-F])+) {
  return {
    type: 'NumberLiteral',
    radix: 16,
    value: num.replace(/_/g, '')
  }
}

OctalNumber
= '0' [Oo] num:$([0-7] / [0-7] [0-7_]* [0-7]) {
  return {
    type: 'NumberLiteral',
    radix: 8,
    value: num.replace(/_/g, '')
  }
}

BinaryNumber
= '0' [Bb] num: $([01] / [01] [01_]* [01]) {
  return {
    type: 'NumberLiteral',
    radix: 2,
    value: num.replace(/_/g, '')
  }
}

// TODO: support multiline
StringLiteral
= '\'' content:$(StringCharacter*) '\'' {
  return {
    type: 'StringLiteral',
    content
  }
}

StringCharacter
= !'\\' [^\']
/ '\\' [\S]

ObjectLiteral
= '{' WL '}' {
  return {
    type: 'ObjectLiteral',
    properties: []
  }
}
/ '{' WL oblhead:PropertyLiteral tail:(WkSep PropertyLiteral)* WL '}' {
  return {
    type: 'ObjectLiteral',
    properties: list(oblhead, tail)
  }
}

PropertyLiteral
= target:Identifier PD '=' PD value:Expression {
  return {
    type: 'PropertyLiteral',
    target,
    value
  }
}
/ target:Identifier {
  return {
    type: 'PropertyLiteral',
    target,
    value: target
  }
}

// TODO: add key-value pair array literal
ArrayLiteral
= '[' WL ']' {
  return {
    type: 'ArrayLiteral',
    elements: []
  }
}
/ '[' WL arlhead:Expression tail:(WkSep Expression)* WL ']' {
  return {
    type: 'ArrayLiteral',
    elements: list(arlhead, tail)
  }
}

Identifier
= PublicIdentifier
/ PrivateIdentifier

PublicIdentifier
= name:$([a-zA-Z_] [a-zA-Z0-9_]*) {
  return {
    type: 'PublicIdentifier',
    name
  }
}

PrivateIdentifier
= '#' id:PublicIdentifier {
  id.type = 'PrivateIdentifier'
  return id
}

FunctionClause
= args:FunctionArgument PD '=>' PD result:Expression {
  return {
    type: 'FunctionClause',
    name: null,
    args,
    result
  }
}

NamedFunctionClause
= 'fn' PD name:Identifier PD body:FunctionClause {
  body.name = name
  return body
}

FunctionDeclaration
= clause:NamedFunctionClause {
  return {
    type: 'FunctionDeclaration',
    clause
  }
}

FunctionExpression
= clause:(NamedFunctionClause / FunctionClause) {
  return {
    type: 'FunctionExpression',
    clause
  }
}

FunctionArgument
= pattern:AssignmentPattern {
  return [pattern]
}
/ '(' WL fnhead:AssignmentPattern tail:(WkSep AssignmentPattern)* WL ')' {
  return list(fnhead, tail)
}

StatementList
= PD slhead:Statement tail:(StSep Statement)* {
  return list(slhead, tail)
}

StatementBlock
= '{' WL body:StatementList WL '}' {
  return body
}

ExpressionList
= exphead:Expression tail:(WkSep Expression)* {
  return list(exphead, tail)
}

WhiteSpaceCharacter
= ' '

LineBreakCharacter
= '\n'

WS
= WhiteSpaceCharacter+

PD
= WhiteSpaceCharacter*

LB
= WhiteSpaceCharacter* LineBreakCharacter

WL
= WhiteSpaceCharacter* (LineBreakCharacter+ WhiteSpaceCharacter*)*

WkSep
= PD ',' WL
/ LB WL

StSep
= PD ';' WL
/ LB WL
