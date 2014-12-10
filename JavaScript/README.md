### DESCRIPTION

PETOOH interpreter written on JavaScript

### FEATURES
* AMD / Common.JS
* Error-first
* Length-independent input

### USAGE

#### NodeJS Example

```js
var Petooh = require('./petooh');
var fs = require('fs');

var petooh = new Petooh;

fs.readFile(process.argv[2], { encoding: 'utf8' }, function (error, data) {
    petooh.listen(error, data);
    
    process.stdout.write(petooh.told() + '\n');
});
```
