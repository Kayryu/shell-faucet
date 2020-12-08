VERSION="1.15.5"
#origin storage.googleapis.com/golang
SOURCE="dl.google.com/go"

[ -z "$GOROOT" ] && GOROOT="$HOME/.go"
[ -z "$GOPATH" ] && GOPATH="$HOME/go"

#get operating system
OS="$(uname -s)"
#get architecture
ARCH="$(uname -m)"

case $OS in
    "Linux")
        case $ARCH in
        "x86_64")
            ARCH=amd64
            ;;
        "armv6")
            ARCH=armv6l
            ;;
        "armv8")
            ARCH=arm64
            ;;
        .*386.*)
            ARCH=386
            ;;
        esac
        PLATFORM="linux-$ARCH"
    ;;
    "Darwin")
        PLATFORM="darwin-amd64"
    ;;
esac

if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
    shell_profile="zshrc"
elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
    shell_profile="bashrc"
fi

if [ "$1" == "--uninstall" ]; then
    rm -rf "$GOROOT"
    if [ "$OS" == "Darwin" ]; then
        sed -i "" '/# GoLang/d' "$HOME/.${shell_profile}"
        sed -i "" '/export GOROOT/d' "$HOME/.${shell_profile}"
        sed -i "" '/$GOROOT\/bin/d' "$HOME/.${shell_profile}"
        sed -i "" '/export GOPATH/d' "$HOME/.${shell_profile}"
        sed -i "" '/$GOPATH\/bin/d' "$HOME/.${shell_profile}"
    else
        sed -i '/# GoLang/d' "$HOME/.${shell_profile}"
        sed -i '/export GOROOT/d' "$HOME/.${shell_profile}"
        sed -i '/$GOROOT\/bin/d' "$HOME/.${shell_profile}"
        sed -i '/export GOPATH/d' "$HOME/.${shell_profile}"
        sed -i '/$GOPATH\/bin/d' "$HOME/.${shell_profile}"
    fi
    echo "Go removed."
    exit 0
fi


PACKAGE_NAME="go$VERSION.$PLATFORM.tar.gz"

echo "Downloading $PACKAGE_NAME ..."
if hash wget 2>/dev/null; then
    wget https://$SOURCE/$PACKAGE_NAME -O /tmp/go.tar.gz
else
    curl -o /tmp/go.tar.gz https://$SROUCE/$PACKAGE_NAME
fi

if [ $? -ne 0 ]; then
    echo "Download failed! Exiting."
    exit 1
fi


echo "Extracting File..."
mkdir -p "$GOROOT"
mkdir -p $GOPATH/{src,pkg,bin}
tar -C "$GOROOT" --strip-components=1 -xzf /tmp/go.tar.gz

touch "$HOME/.${shell_profile}"
{
    echo '# GoLang'
    echo "export GOROOT=${GOROOT}"
    echo 'export PATH=$GOROOT/bin:$PATH'
    echo "export GOPATH=$GOPATH"
    echo 'export PATH=$GOPATH/bin:$PATH'
} >> "$HOME/.${shell_profile}"

echo -e "\nGo $VERSION was installed into $GOROOT"
echo "Make sure to relogin into your shell or run."

#remove pacakge
rm -f /tmp/go.tar.gz
