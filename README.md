:rooster: PETOOH – a fundamentally new programming language
===========================================================

Basics
------

<table>
    <tr>
        <td>Kudah</td>
        <td>increment the data pointer (to point to the next cell to the right)</td>
    </tr>
    <tr>
        <td>kudah</td>
        <td>decrement the data pointer (to point to the next cell to the left)</td>
    </tr>
    <tr>
        <td>Ko</td>
        <td>increment (increase by one) the byte at the data pointer</td>
    </tr>
    <tr>
        <td>kO</td>
        <td>decrement (decrease by one) the byte at the data pointer</td>
    </tr>
    <tr>
        <td>Kukarek</td>
        <td>output the byte at the data pointer as an ASCII encoded character</td>
    </tr>
    <tr>
        <td>Kud</td>
        <td>if the byte at the data pointer is zero, then instead of moving the instruction pointer forward to the next command</td>
    </tr>
    <tr>
        <td>kud</td>
        <td>if the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to the next command</td>
    </tr>
</table>

Code sample
-----------

    KoKoKoKoKoKoKoKoKoKo Kud-Kudah
    KoKoKoKoKoKoKoKo kudah kO kud-Kudah Kukarek kudah
    KoKoKo Kud-Kudah
    kOkOkOkO kudah kO kud-Kudah Ko Kukarek kudah
    KoKoKoKo Kud-Kudah KoKoKoKo kudah kO kud-Kudah kO Kukarek
    kOkOkOkOkO Kukarek Kukarek kOkOkOkOkOkOkO
    Kukarek

[Try now!](http://ky6uk.github.io/PETOOH/)
