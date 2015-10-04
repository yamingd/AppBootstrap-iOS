#!/usr/bin/env bash
path=`pwd`
echo "${path}"

name="$1"
echo "${name}"

namelower=$(echo $name | awk '{print tolower($0)}')

rm ${name}.pb.hh
rm ${name}.pb.mm

protoc --proto_path=${path} --cpp_out=${path} ${path}/${name}.proto
#protoc --proto_path=${path} --java_out=${path}/java ${path}/${name}.proto

mv ${name}.pb.h ${name}.pb.hh
mv ${name}.pb.cc ${name}.pb.mm

