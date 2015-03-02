petooc – a fundamentally new PETOOH-to-Java bytecode compiler
====================================================

How to build compiler
---------------------
```bash
./gradlew shadowJar
```
Output file placed in 
```
build/libs/petooc.jar
```

How to compile PETOOH programs
------------------------------
```
java -jar ./petooc.jar test.koko
```
Output file would be test.class, then you can run it
```
java test
```
