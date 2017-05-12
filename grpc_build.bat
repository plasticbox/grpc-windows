@echo off
@setlocal

@REM EDIT THIS SECTION ACCORDING TO YOUR ENV
call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" amd64
set path=%path%;C:\Program Files\cmake-3.8.1-win64-x64\bin
set path=%path%;C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE
set path=%path%;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin
@REM EOF

pushd "%~dp0"

echo #### grpc build start!

set devenv=devenv

mkdir grpc\bin\zlib
mkdir grpc\bin\zlib\debug
mkdir grpc\bin\zlib\release

cd grpc\third_party\zlib
mkdir build & cd build
mkdir debug & cd debug
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=../../../../bin/zlib/debug ../..
nmake & nmake install

cd ..
mkdir release & cd release
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../../../../bin/zlib/release ../..
nmake & nmake install

cd ../../../../bin/zlib/release
set PATH=%PATH%;%cd%\bin

popd
pushd "%~dp0"

cd grpc\third_party\protobuf\cmake
mkdir build & cd build
mkdir solution & cd solution
cmake -G "Visual Studio 14 2015 Win64" -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_WITH_ZLIB=ON ../..
"%devenv%" protobuf.sln /build "Debug|x64" /project ALL_BUILD
if not %ERRORLEVEL% == 0 goto Finish
robocopy /mir .\Debug ..\..\..\..\..\bin\protobuf\debug

"%devenv%" protobuf.sln /build "Release|x64" /project ALL_BUILD
if not %ERRORLEVEL% == 0 goto Finish
robocopy /mir .\Release ..\..\..\..\..\bin\protobuf\release

cd ..\..\..\..\..\vsprojects
"%devenv%" grpc_protoc_plugins.sln /build "Release|x64"
if not %ERRORLEVEL% == 0 goto Finish
robocopy .\x64\Release\ ..\bin\grpc_protoc_plugins\ /XF *.lib *.iobj *.ipdb
"%devenv%" grpc_protoc_plugins.sln /clean "Release|x64"

"%devenv%" grpc.sln /clean "Debug"
"%devenv%" grpc.sln /clean "Release"
"%devenv%" grpc.sln /build "Debug|x64" /project grpc++
"%devenv%" grpc.sln /build "Debug|x64" /project grpc++_unsecure
if not %ERRORLEVEL% == 0 goto Finish
robocopy /mir .\x64\Debug ..\bin\grpc\debug

"%devenv%" grpc.sln /build "Release|x64" /project grpc++
"%devenv%" grpc.sln /build "Release|x64" /project grpc++_unsecure
if not %ERRORLEVEL% == 0 goto Finish
robocopy /mir .\x64\Release ..\bin\grpc\release /XF *grpc_cpp_plugin*

"%devenv%" grpc.sln /clean "Debug"
"%devenv%" grpc.sln /clean "Release"
"%devenv%" grpc.sln /build "Debug-DLL|x64" /project grpc++
"%devenv%" grpc.sln /build "Debug-DLL|x64" /project grpc++_unsecure
if not %ERRORLEVEL% == 0 goto Finish
robocopy /mir .\x64\Debug-DLL ..\bin\grpc\debug_dll

"%devenv%" grpc.sln /build "Release-DLL|x64" /project grpc++
"%devenv%" grpc.sln /build "Release-DLL|x64" /project grpc++_unsecure
if not %ERRORLEVEL% == 0 goto Finish
robocopy /mir .\x64\Release-DLL ..\bin\grpc\release_dll /XF *grpc_cpp_plugin*

echo #### grpc build done!

:Finish
rem "%devenv%" protobuf.sln /clean "Debug|x64"
rem "%devenv%" protobuf.sln /clean "Release|x64"
rem "%devenv%" grpc_protoc_plugins.sln /clean "Release|x64" /project grpc_cpp_plugin
rem "%devenv%" grpc.sln /clean "Debug|x64" /project grpc++
rem "%devenv%" grpc.sln /clean "Release|x64" /project grpc++
popd
endlocal
pause
