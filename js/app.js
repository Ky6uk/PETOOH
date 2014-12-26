'use strict';

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
    var petooh = new Petooh;

    var input = document.getElementById('input');
    var output = document.getElementById('output');

    input.addEventListener('input', debounce(function (event) {
        petooh.listen(null, event.target.value, { cleanBrain: true });

        output.value = petooh.told();
    }, 1000));
});

