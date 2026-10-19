#!/bin/sh

# Stops script execution if a command has an error
set -e

INSTALL_ONLY=0
# Loop through arguments and process them: https://pretzelhands.com/posts/command-line-flags
for arg in "$@"; do
    case $arg in
        -i|--install) INSTALL_ONLY=1 ; shift ;;
        *) break ;;
    esac
done

if [ ! -f "/usr/share/code/code" ]; then
    echo "Installing VS Code. Please wait..."
    cd $RESOURCES_PATH
    VSCODE_VERSION=1.96.4
    VSCODE_SHA256=67f8a32eb1e24e3ba3c8e586f0871ae20a5522dc8d76323e187cd9b5f9bce0e9
    curl --fail --location --retry 3 --retry-delay 2 \
        "https://update.code.visualstudio.com/${VSCODE_VERSION}/linux-deb-x64/stable" \
        --output ./vscode.deb
    echo "${VSCODE_SHA256}  vscode.deb" | sha256sum --check -
    apt-get update
    apt-get install -y ./vscode.deb
    rm ./vscode.deb
    rm -f /etc/apt/sources.list.d/vscode.list
else
    echo "VS Code is already installed"
fi

# Run
if [ $INSTALL_ONLY = 0 ] ; then
    echo "Starting VS Code"
    /usr/share/code/code --no-sandbox --unity-launch $WORKSPACE_HOME
    sleep 10
fi
