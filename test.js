const {parse} = require('./parser.js')

console.log(JSON.stringify(parse('fn foo bar=>baz'), null, 2))
