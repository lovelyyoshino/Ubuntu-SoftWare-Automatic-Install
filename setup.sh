#!/bin/bash  

echo ""
echo "#######################################################################"
echo "#                          Start to configurate!                      #"
echo "#                                 V 1.0.0                             #"
echo "#######################################################################"
echo ""


echo ""


if [ "${Sources}" == "16.04" ]; then
test -f sources.list && result_0="y"
if [ "${result_0}" == "y" ]; then
         echo "Begin copy"
         sudo cp /etc/apt/sources.list Backup/sources.list
         sudo cp sources.list /etc/apt/sources.list
else
         echo -e "\033[41;37m The sources file which contains tsinghua sources does not exist! \033[0m" >> errorinit.log
         echo -e "\033[41;37m Please check whether the file in the warehouse catalog is complete. \033[0m" >> errorinit.log
         echo -e "\033[41;37m (包含清华的源文件不存在!请检查仓库目录下文件是否完整.) \033[0m" >>errorinit.log
         #echo -e "Coutinue?(Y/n) :\c"
         #read  yn
         #if [ "${yn}" == "n" ] || [ "${yn}" == "N" ]; then
         exit 0;
         #fi
fi
elif [ "${Sources}" == "14.04" ]; then
test -f sources14.04.list && result_0="y"
if [ "${result_0}" == "y" ]; then
         echo "Begin copy"
         sudo cp /etc/apt/sources.list Backup/sources.list
         sudo cp sources14.04.list /etc/apt/sources.list
else
         echo -e "\033[41;37m The sources file which contains tsinghua sources does not exist! \033[0m" >>errorinit.log
         echo -e "\033[41;37m Please check whether the file in the warehouse catalog is complete. \033[0m" >> errorinit.log
         echo -e "\033[41;37m (包含清华的源文件不存在!请检查仓库目录下文件是否完整.) \033[0m" >>errorinit.log
         #echo -e "Coutinue?(Y/n) :\c"
         #read  yn
         #if [ "${yn}" == "n" ] || [ "${yn}" == "N" ]; then
       exit 0;
         #fi
fi
fi




sudo apt install net-tools
sudo systemctl enable ssh.service
systemctl status ssh
sudo systemctl start ssh
sudo apt install openssh-server

# update system
echo "update system"
sudo apt-get update -y
sudo apt-get upgrade -y
sleep 3

# install some tools:
echo "install git"
sudo apt-get install git -y
sleep 3

echo "install curl"
apt-get install curl -y
sleep 3

echo "install gdebi"
apt-get install gdebi -y
sleep 3

echo "install vim"
sudo apt-get install -y vim
sleep 3

echo "install unzip"
sudo apt-get install unzip -y
sleep 3


sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install \
         apt-transport-https \
         ca-certificates \
         curl \
         software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
         $(lsb_release -cs) \
         stable"
sudo apt-get update
echo "install docker.io"
sudo apt-get install docker-ce
sleep 3

echo "install terminator"
# https://blog.csdn.net/zack_liu/article/details/120687194
sudo apt-get install terminator
sleep 3

# install sougou
echo "install sougou"
sudo apt-get remove -y fcitx*
sudo apt-get autoremove
rm sogoupinyin_2.1.0.0086_amd64.deb*
wget -q http://cdn2.ime.sogou.com/dl/index/1491565850/sogoupinyin_2.1.0.0086_amd64.deb?st=H6Fv3RXvgGFlgWBT3xkMZw&e=1507788214&fn=sogoupinyin_2.1.0.0086_amd64.deb
echo -e "Install sougoupinyin,Please wait...\c"
sleep 300
sudo dpkg -i sogoupinyin*
sudo apt-get -yf install 
sudo dpkg -i sogoupinyin*
sleep 3

# 安装系统监视软件sysmonitor
sudo apt-get purge -y unity-webapps-common

sudo add-apt-repository -y ppa:fossfreedom/indicator-sysmonitor  
sudo apt-get update  
sudo apt-get install -y indicator-sysmonitor
indicator-sysmonitor &


# install VS code
echo "install VS code"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sleep 4
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get -y install code
echo -e "\033[46;37m VS code was installed successfully! \033[0m"
echo -e "\033[46;37m (vscode安装成功!) \033[0m"
sleep 3

# install sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sleep 2
sudo apt-get install -y  apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get -y install sublime-text
echo -e "\033[46;37m The sublime text3 was installed successfully! \033[0m"
echo -e "\033[46;37m (sublime安装成功!) \033[0m"
sleep 3


#install flameshot
echo "install flameshot"
sudo apt-get install flameshot
sleep 3

#install markdown editor tepora
echo "install markdown editor Typora"
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add - # 添加公钥
sudo add-apt-repository 'deb https://typora.io/linux ./' # 添加typora仓库
sudo apt-get update 
sudo apt-get install typora # 安装typora
sleep 3

# install
wget -q http://d1.music.126.net/dmusic/netease-cloud-music_1.1.0_amd64_ubuntu.deb 
echo -e "Install netease-cloud-music,Please wait...\c"
sleep 150
sudo dpkg -i netease-cloud-music*
sudo apt-get -yf install
sudo dpkg -i netease-cloud-music*
sleep 3

# chrome 安装
wget -q -O - http://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get -y install google-chrome-stable
sudo apt-get purge firefox firefox-locale* unity-scope-firefoxbook

#install meld
echo "install meld"
sudo apt-get install meld
sleep 3

# install Kazam
echo "install kazam"
sudo apt install kazam
sleep 3


echo "install Termius"
sudo wget -O Termius.deb -c  "https://autoupdate.termius.com/linux/Termius.deb"
sudo dpkg -i ${vscodeName}
sleep 3



echo ""
echo "#######################################################################"
echo "#                          FINISH!!!!!!!!!                            #"
echo "#######################################################################"
echo ""


