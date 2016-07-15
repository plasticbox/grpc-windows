#grpc-windows
Build gRPC on Windows x64

#gRPC?
[gRPC - An RPC library and framework](http://github.com/grpc/grpc)

#Requirements
[Git](https://git-scm.com)

[CMake](https://cmake.org/)

Visual Studio 2015

#Build on windows
```
grpc_clone.bat
grpc_build.bat
```

#Build output
```
grpc\bin\grpc\debug
grpc\bin\grpc\release
grpc\bin\protobuf\debug
grpc\bin\protobuf\release
```

#Test grpc_helloworld
```
run test_protoc.bat
open grpc_helloworld.sln
build solution
run server.exe and client.exe
```

#Use grpc

##Install Nuget Package
```
grpc.dependencies.openssl
grpc.dependencies.openssl.redist
grpc.dependencies.zlib
grpc.dependencies.zlib.redist
```

##Example include or link lib
```
grpc_helloworld\projects\lib_debug.props
grpc_helloworld\projects\lib_release.props
```
