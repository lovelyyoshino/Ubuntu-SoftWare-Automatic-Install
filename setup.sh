#!/bin/bash  

echo ""
echo "#######################################################################"
echo "#                          Start to configurate!                      #"
echo "#                                 V 2.0.0                             #"
echo "#######################################################################"
echo ""


echo "详细安装可以参考：https://dora-cmon.github.io/posts/bbf09ec7/"


# https://github.com/starFalll/Ubuntu_Init/blob/5f1ab6056b92e846a052efcb1dfdb5b7f9807d50/Linux_Init.sh#L2
Sources=$(lsb_release -rs)

if [ "${Sources}" == "22.04" ]; then
  SOURCE_FILE="source22.04.list"
elif [ "${Sources}" == "20.04" ]; then
  SOURCE_FILE="source20.04.list"
elif [ "${Sources}" == "18.04" ]; then
  SOURCE_FILE="source18.04.list"
elif [ "${Sources}" == "16.04" ]; then
  SOURCE_FILE="source16.04.list"
elif [ "${Sources}" == "14.04" ]; then
  SOURCE_FILE="source14.04.list"
else
  echo -e "\033[41;37m The system version is not supported! \033[0m" | tee -a errorinit.log
  echo -e "\033[41;37m (系统版本不支持!) \033[0m" | tee -a errorinit.log
  echo -e "\033[41;37m 暂时默认支持16.04、18.04、20.04、22.04版本!这里默认替换了22.04版本 \033[0m" | tee -a errorinit.log
  SOURCE_FILE="source22.04.list"
fi

if [ -f "${SOURCE_FILE}" ]; then
  echo "Begin copy"
  sudo cp "${SOURCE_FILE}" /etc/apt/sources.list
else
  echo -e "\033[41;37m The sources file which contains Tsinghua sources does not exist! \033[0m" | tee -a errorinit.log
  echo -e "\033[41;37m (包含清华的源文件不存在!请检查仓库目录下文件是否完整.) \033[0m" | tee -a errorinit.log
  exit 0
fi


sudo apt install net-tools
sudo systemctl enable ssh
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
git config --global user.email "mpl9725440@gmail.com"
git config --global user.name "mpl9725440"
sleep 3

echo "install curl"
sudo apt-get install curl -y
sudo apt install -y wget
sleep 3

echo "install gdebi"
sudo apt-get install gdebi -y
sleep 3

echo "install vim"
sudo apt-get install -y vim
sleep 3

echo "install unzip"
sudo apt-get install unzip -y
sleep 3


echo "install tools start"
sudo apt install -y tree
sudo apt install -y htop
sudo apt install -y rar
sudo apt-get install -y ssh
sudo apt install -y sshpass
sudo apt-get install -y okular
sudo apt install -y wmctrl
sudo apt install -y gnome-tweaks
sudo apt-get install -y apt-transport-https
sudo apt install -y compizconfig-settings-manager
sudo apt install -y compiz-plugins-extra
sudo apt-get -y install meld 
# Sticky Notes 
sudo add-apt-repository ppa:kelebek333/mint-tools -y
sudo apt update -y && sudo apt install sticky -y
echo "install tools end"


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


echo "install picture edit gimp start"
sudo apt install gimp -y
echo "install picture edit gimp end"

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


sudo apt install -y figlet #将字符串在终端生成一个logo的终端工具

#gnome extensions
echo "install gnome"
sudo apt install -y gnome-shell-extension-manager
sudo apt-get install -y chrome-gnome-shell 
echo "install gnome"
#gnome extensions
#桌面环境配置
gsettings set org.gnome.desktop.wm.keybindings panel-main-menu "[]" # disable Alt+F1
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal  "['<Alt>t']" # change alt+ctrl+t -> alt+t
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]" # disable window  menu
# 关闭窗口动画效果
gsettings set org.gnome.desktop.interface enable-animations false 



echo "install Termius"
sudo wget -O Termius.deb -c  "https://autoupdate.termius.com/linux/Termius.deb"
sudo dpkg -i ${vscodeName}
sleep 3


# https://github.com/clashdownload/Clash_Verge/releases
echo "install clash"

# 下载 Clash (使用新的下载地址)
CLASH_VERSION="1.3.8"
ARCH="amd64"
wget https://github.com/clashdownload/Clash_Verge/releases/download/${CLASH_VERSION}/clash-verge_${CLASH_VERSION}_${ARCH}.AppImage -O clash-verge.AppImage

# 授予可执行权限并移动到 /usr/local/bin
chmod +x clash-verge.AppImage
sudo mv clash-verge.AppImage /usr/local/bin/clash-verge

# 创建配置文件目录并下载示例配置文件
mkdir -p ~/.config/clash
wget https://raw.githubusercontent.com/Dreamacro/clash/master/config.yaml -O ~/.config/clash/config.yaml

# 创建 systemd 服务文件
sudo tee /etc/systemd/system/clash-verge.service > /dev/null <<EOF
[Unit]
Description=Clash Verge Daemon
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/clash-verge -d /home/$USER/.config/clash
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

# 启用并启动 Clash Verge 服务
sudo systemctl daemon-reload
sudo systemctl enable clash-verge
sudo systemctl start clash-verge

echo "Clash Verge 安装和配置完成。"

echo "install clion"
# 下载 CLion (从 JetBrains 官方网站)
CLION_VERSION="2023.1.1"
wget https://download.jetbrains.com/cpp/CLion-${CLION_VERSION}.tar.gz -O clion.tar.gz

# 解压缩 CLion 并移动到 /opt 目录
sudo tar -xzf clion.tar.gz -C /opt
sudo mv /opt/clion-${CLION_VERSION} /opt/clion

# 创建桌面快捷方式
sudo tee /usr/share/applications/clion.desktop > /dev/null <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=CLion
Icon=/opt/clion/bin/clion.svg
Exec="/opt/clion/bin/clion.sh" %f
Comment=CLion IDE
Categories=Development;IDE;
Terminal=false
StartupWMClass=clion
EOF

# 添加到 PATH
echo 'export PATH=/opt/clion/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# 清理下载的安装文件
rm clion.tar.gz

echo "CLion 安装完成。你可以通过应用菜单或命令 clion 启动 CLion。"


echo ""
echo "#######################################################################"
echo "#                          FINISH!!!!!!!!!                            #"
echo "#######################################################################"
echo ""


