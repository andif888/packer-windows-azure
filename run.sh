#!/bin/bash
set -e

current_dir=$(pwd)
script_name=$(basename "${BASH_SOURCE[0]}")
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
environment=$(basename $script_dir)

build_path_terraform=$script_dir/terraform
build_path_packer=$script_dir/packer

echo "-------"
echo "environment:"
echo $environment
echo "-------"
echo "script_name:"
echo $script_name
echo "-------"
echo "script_dir:"
echo $script_dir
echo "-------"
echo "build_path_packer:"
echo $build_path_packer
echo "-------"
echo "build_path_terraform:"
echo $build_path_terraform
echo "-------"
echo "current_dir:"
echo $current_dir
echo "-------"

cd $build_path_terraform
./build.sh

cd $build_path_packer
./build.sh

cd $current_dir
