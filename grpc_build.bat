@echo off
pushd %~dp0

call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" amd64

echo #### grpc build start!

cd grpc\third_party\protobuf\cmake
cmake -G "Visual Studio 14 2015 Win64" -Dprotobuf_BUILD_TESTS=OFF
devenv.com protobuf.sln /build "Debug|x64" /project ALL_BUILD
if not %ERRORLEVEL% == 0 goto Finish
robocopy /mir .\Debug ..\..\..\bin\protobuf\debug

devenv.com protobuf.sln /build "Release|x64" /project ALL_BUILD
if not %ERRORLEVEL% == 0 goto Finish
robocopy /mir .\Release ..\..\..\bin\protobuf\release

cd ..\..\..\vsprojects
devenv.com grpc_protoc_plugins.sln /build "Release|x64" /project grpc_cpp_plugin
if not %ERRORLEVEL% == 0 goto Finish
robocopy .\x64\Release\ ..\bin\protobuf\debug\ /XF *.lib *.iobj *.ipdb
robocopy .\x64\Release\ ..\bin\protobuf\release /XF *.lib *.iobj *.ipdb

devenv.com grpc.sln /build "Debug|x64" /project grpc++
if not %ERRORLEVEL% == 0 goto Finish
robocopy /mir .\x64\Debug ..\bin\grpc\debug

devenv.com grpc.sln /build "Release|x64" /project grpc++
if not %ERRORLEVEL% == 0 goto Finish
robocopy /mir .\x64\release ..\bin\grpc\release /XF *grpc_cpp_plugin*

echo #### grpc build done!

:Finish
rem devenv.com protobuf.sln /clean "Debug|x64"
rem devenv.com protobuf.sln /clean "Release|x64"
rem devenv.com grpc_protoc_plugins.sln /clean "Release|x64" /project grpc_cpp_plugin
rem devenv.com grpc.sln /clean "Debug|x64" /project grpc++
rem devenv.com grpc.sln /clean "Release|x64" /project grpc++
popd
pause
