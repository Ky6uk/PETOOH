/* globals Petooh */
'use strict';

var sample = 'KoKoKoKoKoKoKoKoKoKo Kud-Kudah\n' +
    'KoKoKoKoKoKoKoKo kudah kO kud-Kudah Kukarek kudah\n' +
    'KoKoKo Kud-Kudah\n' +
    'kOkOkOkO kudah kO kud-Kudah Ko Kukarek kudah\n' +
    'KoKoKoKo Kud-Kudah KoKoKoKo kudah kO kud-Kudah kO Kukarek\n' +
    'kOkOkOkOkO Kukarek Kukarek kOkOkOkOkOkOkO\n' +
    'Kukarek';

var debounce = function (callback, timeout) {
    var timeoutId;

    return function () {
        var context = this;
        var args = arguments;

        clearTimeout(timeoutId);

        timeoutId = setTimeout(function () {
            callback.apply(context, args);
            timeoutId = void 0;
        }, timeout || 0);
    };
};

document.addEventListener('DOMContentLoaded', function () {
    var petooh = new Petooh({ cleanBrain: true });
    var input  = document.getElementById('input');
    var output = document.getElementById('output');

    input.addEventListener('input', debounce(function (event) {
        petooh.listen(null, event.target.value);

        output.value = petooh.told();
    }, 1000));

    input.value = sample;

    input.dispatchEvent(new Event('input'));
});

