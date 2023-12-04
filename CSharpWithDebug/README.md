### USAGE

#### Prerequisites
install [dotnet 8 sdk](https://dotnet.microsoft.com/en-us/download)

#### Simple use
```
dotnet run ../test.koko -d
```
Here and in the following sections use ```-d``` option to start debug session (can be omitted to just run interpreter)

#### Build and Use
##### Simple build and use
```
dotnet build
```

```
dotnet ./bin/Debug/net8.0/petooh.dll ../test.koko -d
```

##### Optimized build and use
```
dotnet build -c Release
```

```
dotnet ./bin/Release/net8.0/petooh.dll ../test.koko -d
```