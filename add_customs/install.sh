###########
## START ##
###########

figlet -f small "Custom Commands Installer"
# Ask the user for confirmation
if [[ ! $1 == *"y"* ]]; then      #Ineffecient way of auto selecting yes, but whatever
    read -p "Do you want to continue with the installation? [Y/n]: " uinput
fi
if [[ ! $uinput == *"y"* || ! $uinput == *"Y"* ]]; then
  exit;
fi

# Check to make sure the user has all the required packages
packagelist=$(apt list)
echo -e "Installing lolcat"
if [[ ! $packagelist == *"lolcat/"*]]; then
    sudo apt install lolcat -y
    if [ $? -ne 0 ]; then
        echo "FAILED"
        echo "Please install lolcat manually"
    else
        echo "SUCCESS"
    fi
else
    echo "lolcat is already installed"
fi
echo -e "Installing sed"
if [[ ! $packagelist == *"sed/"*]]; then
    sudo apt install sed -y
    if [ $? -ne 0 ]; then
        echo "FAILED"
        echo "Please install sed manually"
    else
        echo "SUCCESS"
    fi
else
    echo "sed is already installed"
fi
echo -e "Installing x11-xserver-utils"
if [[ ! $packagelist == *"x11-xserver-utils/"*]]; then
    sudo apt install x11-xserver-utils -y
    if [ $? -ne 0 ]; then
        echo "FAILED"
        echo "Please install x11-xserver-utils manually"
    else
        echo "SUCCESS"
    fi
else
    echo "x11-xserver-utils is already installed"
fi

