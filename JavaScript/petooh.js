/* globals define */

(function (root, factory) {
    'use strict';

    if (typeof define === 'function' && define.amd) {
        define([], factory);
    }
    else if (typeof exports === 'object') {
        module.exports = factory();
    }
    else {
        root.returnExports = factory();
  }
}(this, function () {
    // constructor desu
    var Petooh = function () {
        this.stack = {};
        this.level = 0;
        this.currentCell = 0;
        this.word = '';
        this.filter = new RegExp(/^[adehkKoOru]$/);
    };

    // ears of your rooster
    Petooh.prototype.listen = function (sound) {
        // can you do it a bit deeper?
        if (sound.length > 1) {
            var self = this;

            sound.split('').forEach(function (piece) {
                self.listen(piece);
            });
        };

        // ignore incomprehensible sounds plz
        if (!this.filter.test(sound)) {
            return;
        }

        this.word += sound;

        switch (this.word) {
            case 'Ko':
                if (this.level > 0) {
                }
        }
    };

    return Petooh;
}));
