var Petooh = require('./petooh');
var fs = require('fs');

var filePath = process.argv[2];

if (filePath === void 0) {
    throw new Error('peck-peck');
}

var petooh = new Petooh;

fs.readFile(filePath, { encoding: 'utf8' }, function (error, data) {
    petooh.listen(error, data);

    process.stdout.write(petooh.told() + '\n');
});
