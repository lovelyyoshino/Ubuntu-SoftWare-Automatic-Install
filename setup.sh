#!/bin/bash

echo ""
echo "#######################################################################"
echo "#                          Start to configurate!                      #"
echo "#                                 V 4.0.0                            #"
echo "#######################################################################"
echo ""

echo "详细安装可以参考：https://dora-cmon.github.io/posts/bbf09ec7/"
echo "额外改进安装可以参考：https://github.com/yxSakana/UbuntuAutoConfigure"
echo "Ubuntu 其他比较好的脚本：https://github.com/alicfeng/note/blob/master/Linux/%E9%82%A3%E4%B8%AA%E7%A8%8B%E5%BA%8F%E5%91%98%E7%9A%84Linux%E5%B8%B8%E7%94%A8%E8%BD%AF%E4%BB%B6%E6%B8%85%E5%8D%95.md"
echo "Ubuntu 分版本的安装脚本：https://github.com/MABIY/shell/blob/master/ubuntu_20.04_init_install_update.sh"

# https://github.com/starFalll/Ubuntu_Init/blob/5f1ab6056b92e846a052efcb1dfdb5b7f9807d50/Linux_Init.sh#L2
Sources=$(lsb_release -rs)

UBUNTU_VERSION=$(lsb_release -rs)
UBUNTU_MAJOR=$(echo $UBUNTU_VERSION | cut -d. -f1)
UBUNTU_MINOR=$(echo $UBUNTU_VERSION | cut -d. -f2)

# Function to install all tools
install_all() {
  update_system
  install_basic_tools
  install_docker
  install_terminator
  install_sougou
  install_sysmonitor
  install_gimp
  install_vscode
  install_sublime
  install_flameshot
  install_retext
  install_mplayer_smplayer
  install_chrome
  install_meld
  install_kazam
  install_figlet
  install_whitesur_theme
  # 如果版本是20.04或更低版本则使用install_clash
  if (( UBUNTU_MAJOR < 20 )) || (( UBUNTU_MAJOR == 20 && UBUNTU_MINOR <= 4 )); then
      echo -e "\033[46;37m检测到Ubuntu $UBUNTU_VERSION (<=20.04)，使用install_clash函数\033[0m"
      install_clash
  else
      echo -e "\033[46;37m检测到Ubuntu $UBUNTU_VERSION (>20.04)，使用install_clash_nyanpasu函数\033[0m"
      install_clash_nyanpasu
  fi
  install_clion
  install_termius
  install_systemback
  install_compizconfig
  install_stickynotes
  install_peek

  echo -e "\033[46;37mAll installations 安装完成。\033[0m"
}

# Function to update the system
update_system() {
  echo -e "\033[46;37mupdate system \033[0m"
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sleep 3
  echo -e "\033[46;37mupdate system 安装完成。 \033[0m"
}

# Function to install basic tools
install_basic_tools() {
  echo -e "\033[46;37minstall basic tools \033[0m"
  sudo apt-get install vlc
  sudo apt-get install bleachbit -y
  sudo apt-get install git curl wget gdebi vim unzip -y
  sudo apt-get install tree htop net-tools uget aria2 rar ssh tmux sshpass okular wmctrl gnome-tweaks apt-transport-https compizconfig-settings-manager compiz-plugins-extra meld -y
  # LSB is keep distribution to keep the organizational structure of the Linux Foundation to standardize the software system structure
  sudo apt-get install -y lsb-core || echo "--------------lsb-core install error"
  sudo add-apt-repository ppa:kelebek333/mint-tools -y
  sudo apt update -y && sudo apt-get purge sticky
  # 使用kchmviewer来避免中文乱码
  sudo apt-get install kchmviewer -y
  # 使用preload来加速应用程序的启动
  sudo apt-get install preload -y
  # 安装ttf-wqy-microhei作为中文字体
  sudo apt-get install ttf-wqy-microhei -y

  sudo apt-get install fish  #fish 自动补全工具，不需要zsh了。这里还可以通过fish_config完成环境配置
  echo '# exec fish' >> ~/.bashrc
  sudo apt install baobab # disk usage analyzer 
  sleep 3
  echo -e "\033[46;37minstall basic tools 安装完成。 \033[0m"
}

# Function to install Docker
install_docker() {
  echo -e "\033[46;37minstall docker \033[0m"
  sudo apt-get remove docker docker-engine docker.io
  sudo apt-get update
  sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
  #curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
  #sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu focal stable"
  sudo apt-get update
  echo -e "\033[46;37minstall docker.io \033[0m"
  sudo apt-get install docker-ce -y
  sudo mkdir -p /etc/docker
  sudo tee /etc/docker/daemon.json <<-'EOF'
  {
      "registry-mirrors": [
          "https://do.nark.eu.org",
          "https://dc.j8.work",
          "https://docker.m.daocloud.io",
          "https://dockerproxy.com",
          "https://docker.mirrors.ustc.edu.cn",
          "https://docker.nju.edu.cn"
      ],
      "runtimes": {
          "nvidia": {
              "args": [],
              "path": "nvidia-container-runtime"
          }
      }
  }
EOF

  sudo systemctl daemon-reload
  sudo systemctl restart docker
  sleep 3
  echo -e "\033[46;37minstall docker-compose 安装完成。 \033[0m"
}

# Function to install Terminator
install_terminator() {
  echo -e "\033[46;37minstall terminator \033[0m"
  sudo apt-get install terminator -y
  sleep 3
  echo -e "\033[46;37minstall terminator 安装完成。 \033[0m"
}

# Function to install Sougou
install_sougou() {
  echo -e "\033[46;37minstall sougou \033[0m"
  sudo apt-get remove -y fcitx*
  sudo apt-get autoremove -y
  sudo apt install libqt5qml5 libqt5quick5 libqt5quickwidgets5 qml-module-qtquick2 libgsettings-qt1 fcitx-bin fcitx-table im-config fcitx -y
  im-config -n fcitx
  wget https://benson80.eu.org/sogoupinyin_4.2.1.145_amd64.deb
  sudo dpkg -i sogoupinyin_4.2.1.145_amd64.deb
  sudo apt-get --fix-broken install -y
  sudo apt-get -yf install -y 
  sudo cp /usr/share/applications/fcitx.desktop /etc/xdg/autostart/
  sudo apt remove --purge ibus
  sleep 3
  # https://blog.csdn.net/Mr_Sudo/article/details/124874239
  echo -e "\033[46;37minstall sougou 安装完成。 \033[0m"
}

# Function to install system monitor
install_sysmonitor() {
  echo -e "\033[46;37minstall system monitor \033[0m"
  sudo apt-get purge -y unity-webapps-common
  sudo add-apt-repository -y ppa:fossfreedom/indicator-sysmonitor  
  sudo apt-get update  
  sudo apt-get install -y indicator-sysmonitor
  indicator-sysmonitor &
  sleep 3
  echo -e "\033[46;37minstall system monitor 安装完成。 \033[0m"
}

# Function to install GIMP
install_gimp() {
  echo -e "\033[46;37minstall picture edit gimp start \033[0m"
  sudo apt install gimp -y
  sleep 3
  echo -e "\033[46;37minstall picture edit gimp 安装完成。 \033[0m"
}

# Function to install VS Code：https://code.visualstudio.com/docs/supporting/faq#_previous-release-versions
install_vscode() {
  echo -e "\033[46;37minstall VS code \033[0m"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt-get update
  sudo apt-get -y install code
  echo -e "\033[46;37m VS code was installed successfully! \033[0m"
  sleep 3
  echo -e "\033[46;37minstall VS code 安装完成。如果无法使用请手动下载deb版本，填入对应version即可： https://update.code.visualstudio.com/{version}/linux-deb-x64/stable \033[0m"
}

# Function to install Sublime Text
install_sublime() {
  echo -e "\033[46;37minstall sublime text \033[0m"
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  sudo apt-get install -y apt-transport-https
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  sudo apt-get update
  sudo apt-get -y install sublime-text
  echo -e "\033[46;37m The sublime text3 was installed successfully! \033[0m"
  sleep 3
  echo -e "\033[46;37minstall sublime text 安装完成。 \033[0m"
}

# Function to install Flameshot, 参考：https://blog.csdn.net/qq_62737390/article/details/148225833
install_flameshot() {
  echo -e "\033[46;37minstall flameshot \033[0m"
  sudo apt-get install flameshot -y
  sleep 3
  echo -e "\033[46;37minstall flameshot 安装完成。设置快捷键在设置->键盘->键盘快捷键->查看及自定义快捷键->自定义快捷键 \033[0m"
}

# Function to install retext (安装 ReText)
install_retext() {
  echo -e "\033[46;37m安装 markdown 编辑器 ReText \033[0m"
  sudo apt install -y retext
  sleep 3
  echo -e "\033[46;37mReText 安装完成。 \033[0m"
}

# Function to install mplayer and smplayer (replaces Netease Cloud Music)
install_mplayer_smplayer() {
  echo -e "\033[46;37mInstall mplayer and smplayer \033[0m"
  sudo apt install -y mplayer
  sudo apt install -y smplayer
  echo -e "\033[46;37mmplayer 和 smplayer 安装完成。\033[0m"
}

# Function to install Google Chrome
install_chrome() {
  CHROME_VERSION="134.0.6998.117"
  DEB_URL="https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb"
  #sudo apt remove google-chrome-stable
  #sudo apt purge google-chrome-stable
  echo -e "\033[46;37mInstall Google Chrome \033[0m"
  wget -q -O - http://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
  sudo apt-get update
  wget ${DEB_URL} -O chrome.deb
  sudo apt-mark hold google-chrome-stable
  sudo dpkg -i chrome.deb
  
  sudo apt-get purge firefox firefox-locale* unity-scope-firefoxbook -y
  sleep 3
  echo -e "\033[46;37m Google Chrome 安装完成。如果无法打开则需要参考两个操作 \033[0m"
  echo -e "\033[46;37m 1. 彻底卸载谷歌浏览器，尝试是否因为安装最新的chrome导致的缓存，无法降级。 参考链接：https://blog.csdn.net/Gochan_Tao/article/details/142451263 \033[0m"
  echo -e "\033[46;37m 2. 如果无法打开，则需要输入google-chrome，然后看问题，这种情况一般就是chromedriver版本不对，则需要驱动安装。 参考链接：https://blog.csdn.net/weixin_44523262/article/details/137971666 下载路径为：https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.117/linux64/chromedriver-linux64.zip\033[0m"
}

# Function to install Meld
install_meld() {
  echo -e "\033[46;37minstall meld \033[0m"
  sudo apt-get install meld -y
  sleep 3
  echo -e "\033[46;37minstall meld 安装完成。 \033[0m"
}

# Function to install Kazam
install_kazam() {
  echo -e "\033[46;37minstall kazam \033[0m"
  sudo apt install kazam -y
  sleep 3
  echo -e "\033[46;37minstall kazam 安装完成。 \033[0m"
}

# Function to install Figlet
install_figlet() {
  echo -e "\033[46;37minstall Figlet \033[0m"
  sudo apt install -y figlet
  sleep 3
  echo -e "\033[46;37mFiglet 安装完成。 \033[0m"
}

install_termius() {
    echo -e "\033[46;37minstall Termius \033[0m"
    wget --show-progress -O  termius.deb https://autoupdate.termius.com/linux/Termius.deb
    sudo apt install -y ./termius.deb
    sudo rm ./termius.deb
    sleep 3
    echo -e "\033[46;37mTermius 安装完成。 \033[0m"
}

# Function to install WhiteSur theme: https://www.cnblogs.com/Undefined443/p/18133703
install_whitesur_theme() {
  echo -e "\033[46;37minstall WhiteSur theme \033[0m"
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y git gnome-tweaks gnome-shell-extensions
  git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
  cd WhiteSur-gtk-theme
  ./install.sh -t all -N glassy -s 220  # 运行安装脚本
  sudo ./tweaks.sh -g  # 添加主题
  cd ..
  git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
  cd WhiteSur-icon-theme
  ./install.sh
  cd ..
  git clone https://github.com/vinceliuice/WhiteSur-cursors.git
  cd WhiteSur-cursors
  ./install.sh
  cd ..
  wget https://font.download/dl/font/helvetica-255.zip
  sudo mkdir /usr/local/share/fonts/Helvetica
  sudo unzip helvetica-255.zip -d /usr/local/share/fonts/Helvetica
  sudo fc-cache -fv
  cd ..
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/Meslo.tar.xz
  tar -xJvf Meslo.tar.xz
  sudo mkdir /usr/local/share/fonts/Meslo
  sudo mv MesloLG* /usr/local/share/fonts/Meslo
  sudo fc-cache -fv
  cd ..
  gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-dark"
  gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"
  gsettings set org.gnome.desktop.interface cursor-theme "WhiteSur-cursors"
  gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-dark"
#   # 设置界面字体为 Inter Regular
#   gsettings set org.gnome.desktop.interface font-name 'Ubuntu Regular 11'
#   # 设置文档字体为 Inter Regular
#   gsettings set org.gnome.desktop.interface document-font-name 'Sans Regular 11'
#   # 设置等宽字体为 Roboto Mono Regular
#   gsettings set org.gnome.desktop.interface monospace-font-name 'Sans Regular 11'
#   # 设置窗口标题字体为 Inter Bold
#   gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Ubuntu Bold 13' 
  # https://www.sohu.com/a/411567625_495675
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
  gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
  gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
  gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.3
  echo "GNOME WhiteSur主题安装和配置完成，请重新启动系统以应用更改。"
  sleep 3
  echo -e "\033[46;37mWhiteSur theme 安装完成。 \033[0m"
}

# Function to install Clash
install_clash() {
  echo -e "\033[46;37minstall Clash \033[0m"
  sudo apt-get install libayatana-indicator3-7 -y
  sudo apt --fix-broken install libayatana-appindicator3-1 -y
  CLASH_VERSION="1.2.0"
  ARCH="amd64"
  if [ "$(printf '%s\n' "$CLASH_VERSION" "1.3.8" | sort -V | head -n1)" = "1.3.8" ] && [ "$CLASH_VERSION" != "1.3.8" ]; then
    wget https://github.com/clashdownload/Clash_Verge/releases/download/${CLASH_VERSION}/clash-verge_${CLASH_VERSION}_${ARCH}.AppImage -O clash-verge.AppImage
    chmod +x clash-verge.AppImage
    sudo mv clash-verge.AppImage /usr/local/bin/clash-verge
  else
    wget https://github.com/zzzgydi/clash-verge/releases/download/v${CLASH_VERSION}/clash-verge_${CLASH_VERSION}_${ARCH}.deb -O clash-verge.deb
    sudo dpkg -i clash-verge.deb
  fi
  sudo tee /etc/systemd/system/clash-verge.service > /dev/null <<EOF
[Unit]
Description=Clash Verge Daemon
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/clash-verge -d /home/$USER/.config/clash
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
  sudo systemctl daemon-reload
  sudo systemctl enable clash-verge
  sudo systemctl start clash-verge
  echo -e "\033[46;37mClash Verge 安装和配置完成。 \033[0m"
}

install_clash_nyanpasu() {
  echo -e "\033[46;37mInstalling Clash Nyanpasu... \033[0m"
  echo -e "\033[46;37m 如果需要解决分流问题，可以参考：https://lainbo.dev/clash-config  \033[0m"
  # 下载最新的AppImage文件
  CLASH_VERSION="1.6.1"
  APPIMAGE_URL="https://github.com/libnyanpasu/clash-nyanpasu/releases/download/v${CLASH_VERSION}/clash-nyanpasu_${CLASH_VERSION}_amd64.deb"
  
  wget $APPIMAGE_URL -O clash-nyanpasu.deb
  if [ $? -ne 0 ]; then
   echo -e "\033[41;37mFailed to download Clash Nyanpasu. Please check the URL.\033[0m"
   return 1
  fi

  # 赋予执行权限
  chmod +x clash-nyanpasu.deb
  sudo dpkg -i clash-nyanpasu.deb
  if [ $? -ne 0 ]; then
    sudo apt install libwebkit2gtk-4.0-dev
    echo -e "\033[46;37m Installing dependencies by https://github.com/clash-verge-rev/clash-verge-rev/releases/tag/dependencies ...\033[0m"
    # 下载并安装 libjavascriptcoregtk-4.0-18
    wget http://archive.ubuntu.com/ubuntu/pool/universe/liba/libayatana-indicator/libayatana-indicator3-7_0.6.3-1_amd64.deb -O libayatana-indicator3-7_amd64.deb 
    sudo dpkg -i libayatana-indicator3-7_amd64.deb 
    rm libayatana-indicator3-7_amd64.deb 

    wget http://ftp.de.debian.org/debian/pool/main/liba/libayatana-appindicator/libayatana-appindicator3-1_0.5.92-1_amd64.deb -O libayatana-appindicator3-1_amd64.deb
    sudo dpkg -i libayatana-appindicator3-1_amd64.deb
    rm libayatana-appindicator3-1_amd64.deb
    sudo dpkg -i clash-nyanpasu.deb
  fi
  rm clash-nyanpasu.deb


  # 定义库文件的路径
  LIB_DIR="/usr/lib/x86_64-linux-gnu"
  LIB_CRYPTO_V3="libcrypto.so.3"
  LIB_SSL_V3="libssl.so.3"
  LIB_CRYPTO_V1_1="libcrypto.so.1.1"
  LIB_SSL_V1_1="libssl.so.1.1"
  
  # 检查 libcrypto.so.3 是否存在
  if [ ! -f "$LIB_DIR/$LIB_CRYPTO_V3" ]; then
      echo "$LIB_CRYPTO_V3 不存在，检查 libcrypto.so.1.1"
      if [ -f "$LIB_DIR/$LIB_CRYPTO_V1_1" ]; then
          echo "创建符号链接 $LIB_CRYPTO_V3 -> $LIB_CRYPTO_V1_1"
          sudo ln -s "$LIB_DIR/$LIB_CRYPTO_V1_1" "$LIB_DIR/$LIB_CRYPTO_V3"
      else
          echo "目标库 $LIB_CRYPTO_V1_1 不存在，无法创建链接。"
      fi
  else
      echo "$LIB_CRYPTO_V3 已存在。"
  fi
  
  # 检查 libssl.so.3 是否存在
  if [ ! -f "$LIB_DIR/$LIB_SSL_V3" ]; then
      echo "$LIB_SSL_V3 不存在，检查 libssl.so.1.1"
      if [ -f "$LIB_DIR/$LIB_SSL_V1_1" ]; then
          echo "创建符号链接 $LIB_SSL_V3 -> $LIB_SSL_V1_1"
          sudo ln -s "$LIB_DIR/$LIB_SSL_V1_1" "$LIB_DIR/$LIB_SSL_V3"
      else
          echo "目标库 $LIB_SSL_V1_1 不存在，无法创建链接。"
      fi
  else
      echo "$LIB_SSL_V3 已存在。"
  fi

  # 创建 systemd 服务
  sudo tee /etc/systemd/system/clash-nyanpasu.service > /dev/null <<EOF
[Unit]
Description=Clash Nyanpasu Daemon
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/clash-nyanpasu  -d /home/$USER/.config/clash
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

  # 重新加载 systemd 服务
  sudo systemctl daemon-reload

  # 启用并启动服务
  sudo systemctl enable clash-nyanpasu
  sudo systemctl start clash-nyanpasu

  echo -e "\033[46;37mClash Nyanpasu 安装和配置完成。\033[0m"
}
install_compizconfig(){
  echo -e "\033[46;37minstall compizconfig \033[0m"
  sudo apt-get install compizconfig-settings-manager
  sudo apt-get install compiz-plugins compiz-plugins-extra
  echo -e "\033[46;37mCompizConfig 安装完成。 \033[0m"
}

install_stickynotes() {
  echo -e "\033[46;37minstall stickynotes \033[0m"
  sudo add-apt-repository ppa:umang/indicator-stickynotes -y
  sudo apt-get install -y indicator-stickynotes
  echo -e "\033[46;37mSticky Notes 安装完成。 \033[0m"
}

install_peek() {
  echo -e "\033[46;37minstall Peek (动图截图工具) \033[0m"
  sudo add-apt-repository ppa:peek-developers/stable -y
  sudo apt install -y peek
  echo -e "\033[46;37mPeek 安装完成。\033[0m"
}

install_clash_verge() {
  echo -e "\033[46;37mInstalling Clash Verge...\033[0m"

  # 定义版本和下载链接
  CLASH_VERGE_VERSION="2.1.2"
  DEB_URL="https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v${CLASH_VERGE_VERSION}/Clash.Verge_${CLASH_VERGE_VERSION}_amd64.deb"

  # 下载 .deb 文件
  wget $DEB_URL -O clash-verge-rev.deb
  if [ $? -ne 0 ]; then
    echo -e "\033[41;37mFailed to download Clash Verge. Please check the URL.\033[0m"
    return 1
  fi

  # 安装 .deb 文件
  sudo dpkg -i clash-verge-rev.deb
  if [ $? -ne 0 ]; then
    echo -e "\033[46;37m Installing dependencies by https://github.com/clash-verge-rev/clash-verge-rev/releases/tag/dependencies ...\033[0m"
    # 下载并安装 libjavascriptcoregtk-4.0-18
    wget https://github.com/clash-verge-rev/clash-verge-rev/releases/download/dependencies/libjavascriptcoregtk-4.0-18_2.43.3-1_amd64.deb -O libjavascriptcoregtk-4.0-18.deb
    sudo dpkg -i libjavascriptcoregtk-4.0-18.deb
    rm libjavascriptcoregtk-4.0-18.deb

    # 下载并安装 libwebkit2gtk-4.0-37
    wget https://github.com/clash-verge-rev/clash-verge-rev/releases/download/dependencies/libwebkit2gtk-4.0-37_2.43.3-1_amd64.deb -O libwebkit2gtk-4.0-37.deb
    sudo dpkg -i libwebkit2gtk-4.0-37.deb
    rm libwebkit2gtk-4.0-37.deb
    
    sudo dpkg -i clash-verge-rev.deb
  fi

  # 清理下载的 .deb 文件
  rm clash-verge-rev.deb


  # 创建 systemd 服务
  sudo tee /etc/systemd/system/clash-verge-rev.service > /dev/null <<EOF
[Unit]
Description=Clash Verge Daemon
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/clash-verge-rev  -d /home/$USER/.config/clash
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

  # 重新加载 systemd 服务
  sudo systemctl daemon-reload

  # 启用并启动服务
  sudo systemctl enable clash-verge-rev
  sudo systemctl start clash-verge-rev

  echo -e "\033[46;37mClash Verge 安装和自启动配置完成。\033[0m"
}


# Function to install PyCharm
install_pycharm() {
  echo -e "\033[46;37minstall pycharm \033[0m"
  PYCHARM_VERSION="2023.3.3"
  wget https://download.jetbrains.com/python/pycharm-professional-${PYCHARM_VERSION}.tar.gz -O pycharm.tar.gz
  sudo tar -xzf pycharm.tar.gz -C /opt
  sudo mv /opt/pycharm-${PYCHARM_VERSION} /opt/pycharm
  sudo tee /usr/share/applications/pycharm.desktop > /dev/null <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=PyCharm
Icon=/opt/pycharm/bin/pycharm.svg
Exec="/opt/pycharm/bin/pycharm.sh" %f
Comment=PyCharm IDE
Categories=Development;IDE;
Terminal=false
StartupWMClass=pycharm
EOF
  echo 'export PATH=/opt/pycharm/bin:$PATH' >> ~/.bashrc
  sudo ln -s /opt/pycharm/bin/pycharm.sh /usr/local/bin/pycharm
  source ~/.bashrc
  rm pycharm.tar.gz
  echo -e "\033[46;37mPyCharm 安装完成。你可以通过应用菜单或命令 pycharm 启动 PyCharm。 \033[0m"
}

install_kdenlive(){
    sudo apt-get install kdenlive
}

install_drawio(){
    # 下载 draw.io 的 .deb 文件
    wget https://github.com/jgraph/drawio-desktop/releases/download/v13.7.9/draw.io-amd64-13.7.9.deb -O draw.io.deb
    # 安装 draw.io
    sudo dpkg -i draw.io.deb
    # 处理依赖关系
    sudo apt-get install -f
    # 删除下载的 .deb 文件
    rm draw.io.deb
}

# Function to install CLion: https://blog.idejihuo.com/jetbrains/pycharm-2024-1-3-activation-code-latest-crack-tutorial-crack-tool.html
# 激活：http://jets.idejihuo.com/v2/
# 在线激活：https://justsoso.fun/other/JetBrains-License-Server.html
install_clion() {
  echo -e "\033[46;37minstall clion \033[0m"
  CLION_VERSION="2024.2.3"
  wget https://download.jetbrains.com/cpp/CLion-${CLION_VERSION}.tar.gz -O clion.tar.gz
  sudo tar -xzf clion.tar.gz -C /opt
  sudo mv /opt/clion-${CLION_VERSION} /opt/clion
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
  echo 'export PATH=/opt/clion/bin:$PATH' >> ~/.bashrc
  sudo ln -s /opt/clion/bin/clion.sh /usr/local/bin/clion
  source ~/.bashrc
  rm clion.tar.gz
  echo -e "\033[46;37mCLion 安装完成。你可以通过应用菜单或命令 clion 启动 CLion。 \033[0m"
}

# Function to install Miniconda
install_miniconda() {
  echo -e "\033[46;37m Miniconda3 直接全部回车即可 \033[0m"
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  chmod +x Miniconda3-latest-Linux-x86_64.sh
  ./Miniconda3-latest-Linux-x86_64.sh
  echo 'export PATH=$HOME/miniconda3/bin:$PATH' >> ~/.bashrc
  sleep 3
  echo -e "\033[46;37m Miniconda3 安装完成。 \033[0m"
}

install_systemback() {
sudo sh -c 'echo "deb [arch=amd64] http://mirrors.bwbot.org/ stable main" > /etc/apt/sources.list.d/systemback.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key 50B2C005A67B264F
sudo apt-get update
sudo apt-get install systemback
  echo -e "\033[46;37m   使用教程请参考：https://blog.csdn.net/FourthBro/article/details/131020408     \033[0m"
}

install_cursor() {
    APPIMAGE_PATH="/opt/cursor.AppImage"
    
    # 检查 Cursor AppImage 是否已安装
    if [ ! -f $APPIMAGE_PATH ]; then
        # 提示用户手动下载 Cursor AppImage
        echo -e "\033[46;37m请访问 $CURSOR_URL 下载 Cursor AppImage，并将其保存为 $APPIMAGE_PATH \033[0m"
        echo -e "\033[46;37m下载完成后，请确保文件可执行： \033[0m"
        echo -e "\033[46;37msudo mv Cursor-xxxx-x86_64.AppImage  /opt/cursor.AppImage \033[0m"
        echo -e "\033[46;37msudo chmod +x $APPIMAGE_PATH \033[0m"
        echo -e "\033[46;37m然后再次运行此脚本以完成安装。 \033[0m"
        return
    fi

    echo -e "\033[46;37m正在安装 Cursor AI IDE... \033[0m"
    sudo apt-get install -y fuse libfuse2
    # Cursor AppImage 和图标的下载链接
    CURSOR_URL="https://www.cursor.com/cn/downloads"  # 更新为正确的下载页面
    ICON_URL="https://www.cursor.com/apple-touch-icon.png"

    # 安装路径
    ICON_PATH="/opt/cursor.png"
    DESKTOP_ENTRY_PATH="/usr/share/applications/cursor.desktop"

    # 检查 curl 是否已安装
    if ! command -v curl &> /dev/null; then
        echo -e "\033[46;37mcurl 未安装，正在安装... \033[0m"
        sudo apt-get update
        sudo apt-get install -y curl
    fi

    # 下载 Cursor 图标
    echo -e "\033[46;37m正在下载 Cursor 图标... \033[0m"
    sudo wget sudo wget $ICON_URL -O $ICON_PATH

    # 检查 AppImage 文件是否存在，如果存在则创建桌面入口
    if [ -f $APPIMAGE_PATH ]; then
        echo -e "\033[46;37m正在创建 Cursor 的 .desktop 入口... \033[0m"
        sudo bash -c "cat > $DESKTOP_ENTRY_PATH" <<EOL
[Desktop Entry]
Name=Cursor AI IDE
Exec=$APPIMAGE_PATH --no-sandbox
Icon=$ICON_PATH
Type=Application
Categories=Development;
EOL

        echo -e "\033[46;37mCursor AI IDE 安装完成。你可以通过应用菜单或命令启动 Cursor AI IDE。 \033[0m"
    else
        echo -e "\033[46;37mCursor AI IDE 的 AppImage 文件未找到，无法创建桌面入口。请确保下载完成并再次运行此脚本。 \033[0m"
    fi
}

# Function to install ROS
install_ros() {
  echo -e "\033[46;37mInstalling ROS via FishROS script\033[0m"
  wget http://fishros.com/install -O fishros
  chmod +x fishros
  . ./fishros
  rm fishros
  echo -e "\033[46;37mROS installation completed. Please check the above output for any issues.\033[0m"
  # 写入为了在conda deactivate时不影响PATH。可以直接找到ros版本
  echo 'export PATH=$(echo $PATH | tr ":" "\n" | grep -v "miniconda" | paste -sd:)' >> ~/.bashrc
}

# Function to install Neofetch
install_neofetch() {
  echo -e "\033[46;37mInstall Neofetch \033[0m"
  sudo add-apt-repository ppa:dawidd0811/neofetch -y
  sudo apt-get install neofetch -y
  sleep 2
  echo -e "\033[46;37mNeofetch 安装完成。 \033[0m"
}

# Function to install Tailscale (解决没有公网IP问题)
install_tailscale() {
  sudo apt install openssh-server -y
  sudo service ssh start
  sudo systemctl enable ssh
  sudo service ssh status
  echo -e "\033[46;37m安装并配置 Tailscale (内网穿透)：https://zhuanlan.zhihu.com/p/1912191578182756128\033[0m"
  # 安装Tailscale
  curl -fsSL https://tailscale.com/install.sh | sh
  # 启动并获取认证链接
  sudo tailscale up
  # 创建开机自启脚本
  cat > ~/tailscale-startup.sh << 'EOF'
#!/bin/bash
echo "  启动Tailscale..."
sudo tailscale up
echo "✅ Tailscale已启动"
echo "  设备IP: $(tailscale ip -4)"
EOF
  chmod +x ~/tailscale-startup.sh
  # 添加到bashrc
  if ! grep -q 'tailscale-startup.sh' ~/.bashrc; then
    echo '~/tailscale-startup.sh' >> ~/.bashrc
  fi
  # 设置 systemd 自启（如支持）
  sudo systemctl enable tailscaled 2>/dev/null || true
  echo -e "\033[46;37mTailscale 安装完成。请根据提示完成认证。\033[0m"
  echo -e "\033[46;37m如需注册账号请访问：https://tailscale.com/\033[0m"
  echo -e "\033[46;37m认证完成后，可通过 tailscale ip -4 查看分配的内网IP。\033[0m"
}

install_zsh_ohmyzsh_aliases() {
  echo -e "\033[46;37m安装 zsh start \033[0m"
  sudo apt-get install -y zsh || echo -e "\033[46;------------zsh install error \033[0m"
  echo -e "\033[46;37minstall oh my zsh \033[0m"
  echo ji | sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  echo -e "\033[46;37minput custom alias export \033[0m"
  sudo sh -c "cat >> /home/lh/.zshrc <<EOF
alias datef=\"date '+%Y%m%d'\"
alias gdate=\"date +'%Y%m%d' | clipcopy\"
alias gpu=\"grive -p /home/lh/grive/\"
alias pu=\"git add -A && git commit -m  \"..\" && git push\"
alias rb=\"echo ji | sudo sync;sudo sync;sudo sync;sudo -S reboot\"
alias sd=\"gpu && sudo sync&&sudo sync&& sudo sync&&sudo -S shutdown -h 0\"
alias leanjava=\"idea ~/project/learn_java\"
alias killmw=\"killall -9 mysql-workbench-bin\"
alias noproxy=\"unset http_proxy && unset https_proxy\"
alias killwx=\"killall -9 electronic-wechat\"
#export https_proxy='https://0.0.0.0:7118'
export http_proxy='http://0.0.0.0:12333'
#export https_proxy=socks5://127.0.0.1:1080
EOF"
}

install_variety() {
  echo -e "\033[46;37minstall Variety (动态壁纸工具) \033[0m"
  sudo apt-get install variety -y
  echo -e "\033[46;37mVariety 安装完成。\033[0m"
}

install_cuda118() {
  echo -e "\033[46;37m开始安装 CUDA 11.8 ...\033[0m"
  SCRIPT_PATH="$(dirname "$0")/nvidia_cuda11.8_install.sh"
  if [ -f "$SCRIPT_PATH" ]; then
    bash "$SCRIPT_PATH"
    echo -e "\033[46;37mCUDA 11.8 安装完成。\033[0m"
  else
    echo -e "\033[41;37m未找到 nvidia_cuda11.8_install.sh，请将其放在本脚本同目录下。\033[0m"
  fi
}

# 新增 CUDA 12.2 安装函数
install_cuda122() {
  echo -e "\033[46;37m开始安装 CUDA 12.2 ...\033[0m"
  SCRIPT_PATH="$(dirname "$0")/nvidia_cuda12.2_install.sh"
  if [ -f "$SCRIPT_PATH" ]; then
    bash "$SCRIPT_PATH"
    echo -e "\033[46;37mCUDA 12.2 安装完成。\033[0m"
  else
    echo -e "\033[41;37m未找到 nvidia_cuda12.2_install.sh，请将其放在本脚本同目录下。\033[0m"
  fi
}

echo  -e "\033[34m 这里是主程序，具体是----------
1：   更新系统(默认安装)
2：   安装基础工具(默认安装)
3：   安装docker(docker容器，默认安装)
4：   安装terminator(终端模拟器，默认安装)
5：   安装搜狗输入法(默认安装)
6：   安装系统监视器(默认安装)
7：   安装GIMP(图像处理软件，默认安装)
8：   安装VS Code(代码编辑器，默认安装)
9：   安装Sublime Text(代码编辑器，默认安装)
10：  安装Flameshot(截图工具，默认安装)
11：  安装ReText(Markdown编辑器，默认安装)
12：  安装mplayer和smplayer(默认安装，视频播放器)
13：  安装Chrome(谷歌浏览器，默认安装)
14：  安装Meld(文件比较工具，默认安装)
15：  安装Kazam(屏幕录像工具，默认安装)
16：  安装Figlet(命令行艺术字体，默认安装)
17：  安装WhiteSur主题(Ubuntu主题，默认安装)
18：  安装Clash(Clash代理工具，默认安装)
19：  安装CLion(C/C++编辑器，默认安装)
20：  安装Miniconda(Anaconda的轻量级版本，默认安装)
21：  安装Termius(SSH客户端，默认安装)
22：  安装systemback(系统备份和恢复工具，默认安装)
23：  安装compizconfig(窗口管理增强，默认安装)
24：  安装便签(Sticky Notes，默认安装)
25：  安装Peek(动图截图工具，默认安装)
26：  安装Drawio(!!!流程图编辑器，默认不安装)
27：  安装Pycharm(!!!!Python编辑器，默认不安装)
28：  安装Kdenlive(!!!!视频剪辑，默认不安装)
29：  安装 Cursor可视化图标(!!!VsCode进阶版，无法通过直接安装，需要手动下载，然后运行该脚本，默认不安装)
30：  安装 ROS (!!!机器人操作系统，也默认手动安装)
31：  安装 Neofetch (!!!系统信息展示工具，默认不安装)
32：  安装 Tailscale (!!!内网穿透/远程访问，默认不安装)
33：  安装 zsh + oh-my-zsh + 常用 alias (可选)
34：  安装 Variety(动态壁纸工具，可选)
35：  安装 CUDA 11.8 (可选，支持TensorRT8.7和cudnn 8.7)
36：  安装 CUDA 12.2 (可选)\033[0m"


echo  -e "\033[34m 请根据需要输入对应的数字，多个数字之间用空格隔开，回车默认安装所有工具\033[0m"
# Prompt user for input
read -p "请输入数字: " input
# If no input, install all packages
if [ -z "$input" ]; then
  install_all
else
  # Install selected packages based on user input
  for arg in $input; do
    case $arg in
      1)
        update_system
        ;;
      2)
        update_system
        install_basic_tools
        ;;
      3)
        update_system
        install_docker
        ;;
      4)
        update_system
        install_terminator
        ;;
      5)
        update_system
        install_sougou
        ;;
      6)
        update_system
        install_sysmonitor
        ;;
      7)
        update_system
        install_gimp
        ;;
      8)
        update_system
        install_vscode
        ;;
      9)
        update_system
        install_sublime
        ;;
      10)
        update_system
        install_flameshot
        ;;
      11)
        update_system
        install_retext
        ;;
      12)
        update_system
        install_mplayer_smplayer
        ;;
      13)
        update_system
        install_chrome
        ;;
      14)
        update_system
        install_meld
        ;;
      15)
        update_system
        install_kazam
        ;;
      16)
        update_system
        install_figlet
        ;;
      17)
        update_system
        install_whitesur_theme
        ;;
      18)
        update_system
        install_clash
        ;;
      19)
        update_system
        install_clion
        ;;
      20)
        update_system
        install_miniconda
        ;;
      21)
        update_system
        install_termius
        ;;
      22)
        update_system
        install_systemback
        ;;
      23)
        update_system
        install_compizconfig
        ;;
      24)
        update_system
        install_stickynotes
        ;;
      25)
        update_system
        install_peek
        ;;
      26)
        update_system
        install_drawio
        ;;
      27)
        update_system
        install_pycharm
        ;;
      28)
        update_system
        install_kdenlive
        ;;
      29)
        install_cursor
        ;;
      30)
        update_system
        install_ros
        ;;
      31)
        update_system
        install_neofetch
        ;;
      32)
        update_system
        install_tailscale
        ;;
      33)
        update_system
        install_zsh_ohmyzsh_aliases
        ;;
      34)
        update_system
        install_variety
        ;;
      35)
        install_cuda118
        ;;
      36)
        install_cuda122
        ;;
      *)
        echo "Unknown option: $arg"
        install_all
        ;;
    esac
  done
fi

echo ""
echo "#######################################################################"
echo "#                          FINISH!!!!!!!!!                            #"
echo "#######################################################################"
echo ""
