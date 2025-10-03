@echo off
setlocal enabledelayedexpansion

REM Normalize the current working directory to WSL format
set "mypath=%~dp0"
set "my_path_new=%mypath:\=/%"  REM Convert backslashes (\) to forward slashes (/)
set "my_path_new=%my_path_new::=%"  REM Remove colons (:)
set "my_path_new=/mnt/%my_path_new%"  REM Convert to WSL path

REM Print the transformed path for debugging
echo WSL Path: %my_path_new%

set "STRING=%my_path_new%"
set "LOWERCASE_STRING=%STRING%"

for %%L in (A a B b C c D d E e F f G g H h I i J j K k L l M m N n O o P p Q q R r S s T t U u V v W w X x Y y Z z) do (
    set "LOWERCASE_STRING=!LOWERCASE_STRING:%%L=%%L!"
)

echo Lowercase open directory: %LOWERCASE_STRING%

REM Open VS Code in WSL
code --remote wsl+Ubuntu-24.04 %LOWERCASE_STRING%