/* globals define */
/* jshint node: true */

(function (root, factory) {
    'use strict';

    if (typeof define === 'function' && define.amd) {
        define([], factory);
    }
    else if (typeof exports === 'object') {
        module.exports = factory();
    }
    else {
        root.Petooh = factory();
  }
}(this, function () {
    'use strict';

    // constructor desu
    var Petooh = function (options) {
        this.options = options || {};
        this.stack = {};
        this.level = 0;
        this.currentPosition = 0;
        this.word = '';
        this.filter = new RegExp(/^[adehkKoOru]$/);
        this.brain = [];
        this.result = '';
        this.buffer = '';
    };

    // ears of your rooster
    Petooh.prototype.listen = function (error, sound) {
        if (error) {
            this.peckError();
        }

        // can you do it a bit deeper?
        if (sound.length > 1) {
            var self = this;

            // great.. no more IE 8- here..
            sound.split('').forEach(function (piece) {
                self.listen(error, piece);
            });
        }

        // ignore incomprehensible sounds plz
        if (!this.filter.test(sound)) {
            return;
        }

        var buffer = this.word + sound;

        if (buffer === 'Ko') {
            this.level > 0
                ? this.remember(buffer)
                : this.increasePlz();

            this.forget();
        }
        else if (buffer === 'kO') {
            this.level > 0
                ? this.remember(buffer)
                : this.decreasePlz();

            this.forget();
        }
        else if (buffer === 'Kudah') {
            this.level > 0
                ? this.remember(buffer)
                : this.currentPosition++;

            this.forget();
        }
        else if (buffer === 'kudah') {
            this.level > 0
                ? this.remember(buffer)
                : this.currentPosition--;

            this.forget();
        }
        else if (this.word === 'Kud' && sound !== 'a') {
            this.stack[++this.level] = [];
            this.forget(sound);
        }
        else if (this.word === 'kud' && sound !== 'a') {
            this.repeat();
            this.level--;
            this.forget(sound);
        }
        else if (buffer === 'Kukarek') {
            this.level > 0
                ? this.remember(buffer)
                : this.success();

            this.forget();
        }
        else {
            this.word += sound;
        }
    };

    Petooh.prototype.repeat = function () {
        var self = this;

        while (this.brain[this.currentPosition] > 0) {
            this.stack[this.level].forEach(function (word) {
                if      (word === 'Ko')      { self.increasePlz(); }
                else if (word === 'kO')      { self.decreasePlz(); }
                else if (word === 'Kudah')   { self.currentPosition++; }
                else if (word === 'kudah')   { self.currentPosition--; }
                else if (word === 'Kukarek') { self.success(); }
            });
        }
    };

    // catch some error
    Petooh.prototype.peckError = function () {
        throw new Error('peck-peck');
    };

    Petooh.prototype.forget = function (sound) {
        this.word = sound === void 0 ? '' : sound;
    };

    Petooh.prototype.increasePlz = function () {
        this.brain[this.currentPosition] === void 0
            ? this.brain[this.currentPosition] = 1
            : this.brain[this.currentPosition]++;
    };

    Petooh.prototype.decreasePlz = function () {
        this.brain[this.currentPosition] === void 0
            ? this.brain[this.currentPosition] = 1
            : this.brain[this.currentPosition]--;
    };

    Petooh.prototype.remember = function (word) {
        if (!this.stack[this.level]) {
            this.peckError();
        }

        this.stack[this.level].push(word);
    };

    Petooh.prototype.success = function () {
        this.result += String.fromCharCode(this.brain[this.currentPosition]);

        if (this.options.cleanBrain) {
            this.brain = [];
        }
    };

    Petooh.prototype.told = function () {
        return this.result;
    };

    return Petooh;
}));
