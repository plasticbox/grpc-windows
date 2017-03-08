@echo off

pushd %~dp0

set path=%cd%
set output_client_path=%path%\src\client\
set output_server_path=%path%\src\server\
set protoc_path=%path%\..\grpc\bin\protobuf\release
set grpc_protoc_plugins_path=%path%\..\grpc\bin\grpc_protoc_plugins

%protoc_path%\protoc.exe helloworld.proto --grpc_out=%output_client_path% --plugin=protoc-gen-grpc=%grpc_protoc_plugins_path%\grpc_cpp_plugin.exe --proto_path=.\
%protoc_path%\protoc.exe helloworld.proto --grpc_out=%output_server_path% --plugin=protoc-gen-grpc=%grpc_protoc_plugins_path%\grpc_cpp_plugin.exe --proto_path=.\

%protoc_path%\protoc.exe helloworld.proto --cpp_out=%output_client_path% --proto_path=.\
%protoc_path%\protoc.exe helloworld.proto --cpp_out=%output_server_path% --proto_path=.\

popd
