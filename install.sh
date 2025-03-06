###########
## START ##
###########

# Intro (for funsies)
packagelist=$(apt list)
if [[ $($packagelist | grep figlet) == *"installed"* ]]; then
    figlet -f small "Custom Commands Installer"
else
    echo -e "\nCustom Commands Installer\n"
fi

# Check to make sure the user has all the required packages
echo "Installing required packages, please enter your password"
sudo echo
echo -e "Installing figlet"
if [[ ! $($packagelist | grep figlet) == *"installed"* ]]; then
    sudo apt install figlet -y
    if [ $? -ne 0 ]; then
        echo -e "\033[0;31mFAILED"
        echo "Please install figlet manually"
    else
        echo -e "\e[92mSUCCESS"
    fi
else
    echo "figlet is already installed"
fi
echo -e "Installing lolcat"
if [[ ! $packagelist == *"lolcat/"* ]]; then
    sudo apt install lolcat -y
    if [ $? -ne 0 ]; then
        echo -e "\033[0;31mFAILED"
        echo "Please install lolcat manually"
    else
        echo -e "\e[92mSUCCESS"
    fi
else
    echo "lolcat is already installed"
fi
echo -e "Installing sed"
if [[ ! $packagelist == *"sed/"* ]]; then
    sudo apt install sed -y
    if [ $? -ne 0 ]; then
        echo -e "\033[0;31mFAILED"
        echo "Please install sed manually"
    else
        echo -e "\e[92mSUCCESS"
    fi
else
    echo "sed is already installed"
fi
echo -e "Installing curl"
if [[ ! $packagelist == *"curl/"* ]]; then
    sudo apt install curl -y
    if [ $? -ne 0 ]; then
        echo -e "\033[0;31mFAILED"
        echo "Please install curl manually"
    else
        echo -e "\e[92mSUCCESS"
    fi
else
    echo "curl is already installed"
fi
echo -e "Installing x11-xserver-utils"
if [[ ! $($packagelist | grep x11-xserver-utils) == *"installed"* ]]; then
    sudo apt install x11-xserver-utils -y
    if [ $? -ne 0 ]; then
        echo -e "\033[0;31mFAILED"
        echo "Please install x11-xserver-utils manually"
    else
        echo -e "\e[92mSUCCESS"
    fi
else
    echo "x11-xserver-utils is already installed"
fi

# Install the custom commands
if [ ! -d /usr/custom_paths ]; then
    sudo mkdir /usr/custom_paths
fi
sudo cp -r ./commands/* /usr/custom_paths/
sudo chmod +x /usr/custom_paths/*
cd

# Modify .bashrc to make commands part of PATH (accessible from any directory)
if [[ ! $(cat ~/.bashrc) == *"/usr/custom_paths/"* ]]; then
    echo "export PATH=\"$PATH:/usr/custom_paths/\"" >> ~/.bashrc
    if [ $? -ne 0 ]; then
        echo "Something went wrong when adding to your .bashrc file"
    fi
fi

echo "COMPLETE"
