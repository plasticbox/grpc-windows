@setlocal

call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" amd64
set path=%path%;C:\Program Files\cmake-3.8.1-win64-x64\bin
set path=%path%;C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE
set path=%path%;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin
call grpc_build.bat

@endlocal
