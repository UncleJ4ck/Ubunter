#!/bin/bash 

header() {
    clear
    echo "
             _    _ _                 _            
            | |  | | |               | |           
            | |  | | |__  _   _ _ __ | |_ ___ _ __ 
            | |  | | '_ \| | | | '_ \| __/ _ \ '__|
            | |__| | |_) | |_| | | | | ||  __/ |   
             \____/|_.__/ \__,_|_| |_|\__\___|_|   

                        by UncleJ1ck                                 
    "
}

permNet() {
    if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
    fi

    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
    if [ $? -eq 0 ]; then
    echo "You are ready to start!"
    else
        echo "This script needs a network connection"
    exit 1
    fi
}

prerequisites() {
    clear
    echo "[!] Do you want to start the installation ?"
    echo
    echo "1) Yes"
    echo "2) No"
    echo
    read -p ">> "  answer


    case $answer in 
    1) 
    echo
    cd ~/
    clear
    echo "[!]Installing prerequisites"
    echo
    echo "[!]System updates"
    echo
    apt-get install tlp tlp-rdw software-properties-common preload
    tlp start


    echo 
    echo "[!]Package installation"
    echo
    cd /tmp
    apt update
    apt install -y gnupg
    sh -c "echo 'deb https://http.kali.org/kali kali-rolling main non-free contrib' > /etc/apt/sources.list.d/kali.list"
    wget 'https://archive.kali.org/archive-key.asc'
    apt-key add archive-key.asc 
    sh -c "echo 'Package: *'>/etc/apt/preferences.d/kali.pref; echo 'Pin: release a=kali-rolling'>>/etc/apt/preferences.d/kali.pref; echo 'Pin-Priority: 50'>>/etc/apt/preferences.d/kali.pref"
    apt-get -y update
    
    
    cd ~
    echo
    echo "[!]Removal of default useless apps."
    echo
    apt autoremove --purge
    apt-get autoclean

    echo
    echo "Do you have packages problem? (y/n)" 
    echo 
    read -p ">> " answer 

    case $answer in 
    y | Y) 
    apt-get update --fix-missing
    dpkg --configure -a
    apt-get install -f
    apt-get clean
    apt-get update 
    apt-get -y full-upgrade -y
    apt-get dist-upgrade -y
    apt autoremove -y 
    ;;

    n | N) 
    echo "So you can continue!"
    ;;
    esac

    echo
    echo "[!]Bash to Zsh! Do you wanna switch? (y/n)" 
    echo
    read -p ">> " choice

    case $choice in
    y | Y)
    echo
    if ! [ -x "$(command -v zsh)" ]; then
    echo 'Error: zsh is not installed.' >&2
    echo "Installing zsh..."
    echo
    cd ~
    apt-get install -y zsh zsh-syntax-highlighting zsh-autosuggestions
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    wget https://raw.githubusercontent.com/OscarAkaElvis/zsh-parrot-theme/master/install.zsh
    ./install.zsh 
    echo "You can add more plugins to your zsh like zsh autosuggestions / .. "
    fi
    ;;

    N | n) 
    echo
    echo "You can continue! "
    ;;
    esac

    echo 
    echo "[!]Drivers Installation"
    echo
    apt-get install -y virtualbox-guest-dkms-hwe
    ubuntu-drivers autoinstall
    
    echo
    echo "[!]Changing your ubuntu theme"
    echo
    snap install orchis-themes
    snap install tela-icons
    for i in $(snap connections | grep gtk-common-themes:gtk-3-themes | awk '{print $2}'); do sudo snap connect $i orchis-themes:gtk-3-themes; done
    apt install gnome-shell-extensions gnome-tweak-tool
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height BOTTOM
    gsettings set org.gnome.desktop.interface gtk-theme "Orchis-dark"
    gsettings set org.gnome.desktop.wm.preferences theme "Orchis-dark"
    gsettings set org.gnome.desktop.interface icon-theme "Tela-black"
    echo "at the end you can go to 'Tweaks' and choose your theme in Appearance!"
    echo
    echo "[!]Installation of ruby and its requirements"
    echo
    apt-get install -y ruby-full ruby
    echo
    echo "[!]Installation of gems"
    echo
    gem update --system
    gem install bundler 
    bundle install
    gem install clipboard  
    gem install coffee-script 
    gem install colorize 
    gem install commander 
    gem install ftpd 
    gem install geoip 
    gem install highline 
    gem install http 
    gem install httparty 
    gem install httpclient 
    gem install httpi 
    gem install mechanize 
    gem install metasm 
    gem install net-http-digest_auth 
    gem install net-ping 
    gem install net-scp 
    gem install net-ssh 
    gem install nokogiri 
    gem install opal 
    gem install pry 
    gem install pry-byebug 
    gem install pry-doc 
    gem install rails 
    gem install rest-client 
    gem install ruby_apk 
    gem install rubyfu 
    gem install ruby-nmap 
    gem install ruby-ntlm 
    gem install savon 
    gem install selenium-webdriver 
    gem install snmp 
    gem install wpscan
    gem install spidr 
    gem install tty-prompt 
    gem install uirusu 
    gem install virustotal 
    gem install wasabi 
    gem install watir-webdriver 
    gem install websocket 
    gem install rake

    echo
    echo "[*]installation of python-requirements"
    echo
    apt-get install -y python3.9 python3-pip libssl-dev libffi-dev python3-dev python3-aiosqlite python3-bs4 python3-dnspython python3-lxml 


    echo 
    echo "[*]installation of java-requirements"
    echo
    apt-get install default-jdk default-jre default-jdk openjdk-11-jdk openjdk-11-jre-headless
    echo
    echo "[*]installation of php-requirements"
    echo
    apt-get install -y php libapache2-mod-php apache2 

    echo
    echo "[*]installation of dev libs"
    echo
    apt-get install -y dpkg-dev pkg-config libc6 postgresql-common postgresql-server-dev-12 libappindicator1 postgresql-server-dev-all libpq-dev libpcap-dev libsqlite3-dev libnfc5 libreadline-dev samba-libs libcapstone3 libcapstone-dev libssl-dev zlib1g-dev libxml2-dev libxslt1-dev libyaml-dev libffi-dev libssh-dev libpq-dev libsqlite-dev libsqlite3-dev libpcap-dev libgmp3-dev libpcap-dev  libpcre3-dev libidn11-dev libcurl4-openssl-dev build-essential gcc g++ 

    echo
    echo "[*]installation of libs"
    echo
    apt-get install -y libpq5 libgcrypt20 libc6 libstdc++6 libc6 libndpi4.0 libatkmm-1.6-1v5 libreadline5 libjs-sphinxdoc libwbclient0 libappindicator1 libindicator7 build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev git autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev libyaml-dev curl zlib1g-dev gawk bison libffi-dev libgdbm-dev libncurses5-dev libtool sqlite3 libgmp-dev gnupg2 dirmngr libnss3 libxss1 libncurses5-dev libncurses5 build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev libyaml-dev curl zlib1g-dev mdk4 xterm gawk bison libffi-dev hcxdumptool libgdbm-dev libncurses5-dev libtool sqlite3 libgmp-dev gnupg2 dirmngr 

    echo
    echo "[*]installation of perl"
    echo
    sudo apt-get install -y libdbd-mysql-perl perl
    sudo apt install make
    clear
    ;;

    2)
    echo "Have a good!"
    exit 0
    ;;

    *) 
    echo "Invalid Input! Please try again"
    choice
    ;;
    esac
}

tools() {
    cd ~
    echo "Which categories of tools do you want to install ?"
    echo
    echo " 
    1) Information Gathering			8) Exploitation Tools
    2) Vulnerability Analysis			9) Forensics Tools
    3) Wireless Attacks			        10) Stress Testing
    4) Web Applications				11) Password Attacks
    5) Sniffing & Spoofing		        12) Reverse Engineering 
    6) Maintaining Access		        13) Hardware Hacking
    7) Reporting Tools 	                        14) Developer Tools
    0) All                                      15) exit			
    "
    echo
    read -p ">> " answer

    case $answer in 

    1)
    apt-get install -y amap arp-scan bing-ip2hosts braa cisco-torch copy-router-config copy-router-config dmitry nmap dnsenum dnsmap dnsrecon dnstracer dnswalk dotdotpwn enum4linux enumiax eyewitness exploitdb fierce firewalk goofile hping3 ismtp intrace ident-user-enum inspy lbd  maltego masscan metagoofil nbtscan-unixwiz nikto nmap osrframework p0f parsero recon-ng set smbmap smtp-user-enum snmpcheck sslsplit  sublist3r thc-ipv6   twofi unicornscan urlcrazy wireshark  
    ;;

    2) 
    apt-get install -y bed cisco-auditing-tool cisco-global-exploiter cisco-ocs cisco-torch copy-router-config doona dotdotpwn greenbone-security-assistant jsql-injection lynis nmap ohrwurm openvas-scanner oscanner sfuzz sidguesser siparmyknife sqlmap sqlninja sqlsus thc-ipv6 tnscmd10g unix-privesc-check yersinia
    ;;

    3)
    apt-get install -y aircrack-ng asleap bluelog blueranger bluesnarfer bully cowpatty crackle eapmd5pass fern-wifi-cracker  hostapd-wpe kalibrate-rtl kismet mdk3  mfterm multimon-ng pixiewps reaver redfang rtlsdr-scanner spooftooph wifi-honey wifite iw gawk curl git wireless-tools ettercap-graphical hostapd isc-dhcp-server iptables sslstrip lighttpd dsniff reaver xterm expect 
    ;;

    4) 
    apt-get install -y apache-users burpsuite cutycapt davtest dirb dirbuster gobuster hurl jboss-autopwn joomscan jsql-injection nikto padbuster paros parsero plecost recon-ng skipfish sqlmap sqlninja sqlsus uniscan webscarab websploit wfuzz xsser zaproxy
    
    ;;

    5) 
    apt-get install -y bettercap burpsuite dnschef fiked hamster-sidejack hexinject iaxflood inviteflood ismtp isr-evilgrade isr-evilgrade mitmproxy ohrwurm protos-sip rebind responder rtpbreak rtpinsertsound rtpmixsound sctpscan siparmyknife sipp sipvicious sniffjoke sslsplit thc-ipv6 voiphopper webscarab wifi-honey wireshark xspy yersinia zaproxy
    ;;

    6) 
    apt-get install -y cryptcat cymothoa dbd dns2tcp httptunnel nishang polenum powersploit pwnat ridenum sbd webshells weevely winexe
    ;;

    7)
    apt-get install -y casefile  cutycapt dos2unix  metagoofil nipper-ng pipal
    ;;

    8)
    if ! [ -x "$(command -v msfconsole)" ]; then 
    cd /tmp
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
    chmod +x msfinstall
    ./msfinstall
    cd ~
    apt-get install -y  armitage backdoor-factory beef kali-tools-crypto-stego kali-tools-gpu cisco-auditing-tool cisco-global-exploiter cisco-ocs cisco-torch commix crackle commix exploitdb jboss-autopwn linux-exploit-suggester routersploit set shellnoob sqlmap thc-ipv6 yersinia beef-xss    
    else 
    apt-get install -y  armitage backdoor-factory beef kali-tools-crypto-stego kali-tools-gpu cisco-auditing-tool cisco-global-exploiter cisco-ocs cisco-torch commix crackle commix exploitdb jboss-autopwn linux-exploit-suggester routersploit set shellnoob sqlmap thc-ipv6 yersinia beef-xss    
    fi
    ;;

    9)
    apt-get install -y binwalk  chntpw dc3dd ddrescue dumpzilla extundelete foremost galleta guymager p0f pdf-parser pdfid 
    ;;

    10) 
    apt-get install -y dhcpig iaxflood inviteflood ipv6-toolkit mdk3 reaver rtpflood slowhttptest t50 termineter thc-ipv6 thc-ssl-dos
    ;;

    11) 
    apt-get install -y brutespray burpsuite cewl chntpw cisco-auditing-tool cmospwd crowbar crunch gpp-decrypt hash-identifier hashcat hashid hydra john johnny maskprocessor multiforcer ncrack oclgausscrack pack patator polenum rainbowcrack rcracki-mt rsmangler statsprocessor seclists thc-pptp-bruter truecrack webscarab wordlists zaproxy 
    ;;

    12) 
    apt-get install -y apktool dex2jar edb-debugger javasnoop jdim ollydbg smali valgrind yara  
    ;;

    13) 
    apt-get install -y android-sdk apktool arduino dex2jar sakis3g smali
    ;;

    14)
    apt install nodejs npm 
    snap install atom
    snap install discord 
    snap install --classic sublime-text
    snap install spotify 
    snap install --classic code
    ;;

    15)
    echo
    echo "Have a good day!"
    exit 0
    ;;

    0)
    if ! [ -x "$(command -v msfconsole)" ]; then
    cd /tmp
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
    chmod +x msfinstall
    ./msfinstall
    db_status
    msfdb init
    cd ~ 
    apt-get install -y  amap nodejs npm arp-scan bing-ip2hosts braa cisco-torch copy-router-config copy-router-config dmitry nmap dnsenum dnsmap dnsrecon dnstracer dnswalk dotdotpwn enum4linux enumiax eyewitness exploitdb fierce firewalk goofile hping3 ismtp intrace ident-user-enum inspy lbd  maltego masscan metagoofil nbtscan-unixwiz nikto nmap osrframework p0f parsero recon-ng set smbmap smtp-user-enum snmpcheck sslsplit  sublist3r thc-ipv6   twofi unicornscan urlcrazy wireshark  bed cisco-auditing-tool cisco-global-exploiter cisco-ocs cisco-torch copy-router-config doona dotdotpwn greenbone-security-assistant lynis nmap ohrwurm openvas-scanner oscanner sfuzz sidguesser siparmyknife sqlmap sqlninja sqlsus thc-ipv6 tnscmd10g unix-privesc-check yersinia aircrack-ng asleap bluelog blueranger bluesnarfer bully cowpatty crackle eapmd5pass fern-wifi-cracker  hostapd-wpe kalibrate-rtl kismet mdk3  mfterm multimon-ng pixiewps reaver redfang rtlsdr-scanner spooftooph wifi-honey  wifite apache-users burpsuite cutycapt davtest dirb dirbuster gobuster hurl jboss-autopwn joomscan nikto padbuster paros parsero plecost recon-ng skipfish sqlmap kali-tools-crypto-stego kali-tools-gpu sqlninja sqlsus uniscan webscarab websploit wfuzz xsser zaproxy bettercap nodejs npm burpsuite dnschef fiked hamster-sidejack hexinject iaxflood inviteflood ismtp isr-evilgrade isr-evilgrade mitmproxy ohrwurm protos-sip rebind responder rtpbreak rtpinsertsound rtpmixsound sctpscan siparmyknife sipp sipvicious sniffjoke sslsplit thc-ipv6 voiphopper webscarab wifi-honey wireshark xspy yersinia zaproxy cryptcat cymothoa dbd dns2tcp httptunnel nishang polenum powersploit pwnat ridenum sbd webshells weevely  cutycapt dos2unix  metagoofil nipper-ng pipal armitage backdoor-factory beef cisco-auditing-tool cisco-global-exploiter cisco-ocs cisco-torch commix crackle commix exploitdb jboss-autopwn linux-exploit-suggester routersploit set shellnoob sqlmap thc-ipv6 yersinia beef-xss binwalk  chntpw dc3dd ddrescue dumpzilla extundelete foremost galleta guymager p0f pdf-parser pdfid  dhcpig iaxflood inviteflood ipv6-toolkit mdk3 reaver rtpflood slowhttptest t50 termineter thc-ipv6 thc-ssl-dos brutespray burpsuite cewl chntpw cisco-auditing-tool cmospwd crowbar crunch gpp-decrypt hash-identifier hashcat hashid hydra john johnny maskprocessor multiforcer ncrack oclgausscrack pack patator polenum rainbowcrack rcracki-mt rsmangler statsprocessor seclists thc-pptp-bruter truecrack webscarab wordlists zaproxy apktool dex2jar edb-debugger javasnoop jdim ollydbg smali valgrind yara android-sdk apktool arduino dex2jar sakis3g smali
    snap install atom
    snap install discord 
    snap install --classic sublime-text
    snap install spotify 
    snap install --classic code
    else 
    apt-get install -y  amap nodejs npm arp-scan bing-ip2hosts braa cisco-torch copy-router-config copy-router-config dmitry nmap dnsenum dnsmap dnsrecon dnstracer dnswalk dotdotpwn enum4linux enumiax eyewitness exploitdb fierce firewalk goofile hping3 ismtp intrace ident-user-enum inspy lbd  maltego masscan metagoofil nbtscan-unixwiz nikto nmap osrframework p0f parsero recon-ng set smbmap smtp-user-enum snmpcheck sslsplit  sublist3r thc-ipv6   twofi unicornscan urlcrazy wireshark  bed cisco-auditing-tool cisco-global-exploiter cisco-ocs cisco-torch copy-router-config doona dotdotpwn greenbone-security-assistant lynis nmap ohrwurm openvas-scanner oscanner sfuzz sidguesser siparmyknife sqlmap sqlninja sqlsus thc-ipv6 tnscmd10g unix-privesc-check yersinia aircrack-ng asleap bluelog blueranger bluesnarfer bully cowpatty crackle eapmd5pass fern-wifi-cracker  hostapd-wpe kalibrate-rtl kismet mdk3  mfterm multimon-ng pixiewps reaver redfang rtlsdr-scanner spooftooph wifi-honey  wifite apache-users burpsuite cutycapt davtest dirb dirbuster gobuster hurl jboss-autopwn joomscan nikto padbuster paros parsero plecost recon-ng skipfish sqlmap kali-tools-crypto-stego kali-tools-gpu sqlninja sqlsus uniscan webscarab websploit wfuzz xsser zaproxy bettercap nodejs npm burpsuite dnschef fiked hamster-sidejack hexinject iaxflood inviteflood ismtp isr-evilgrade isr-evilgrade mitmproxy ohrwurm protos-sip rebind responder rtpbreak rtpinsertsound rtpmixsound sctpscan siparmyknife sipp sipvicious sniffjoke sslsplit thc-ipv6 voiphopper webscarab wifi-honey wireshark xspy yersinia zaproxy cryptcat cymothoa dbd dns2tcp httptunnel nishang polenum powersploit pwnat ridenum sbd webshells weevely  cutycapt dos2unix  metagoofil nipper-ng pipal armitage backdoor-factory beef cisco-auditing-tool cisco-global-exploiter cisco-ocs cisco-torch commix crackle commix exploitdb jboss-autopwn linux-exploit-suggester routersploit set shellnoob sqlmap thc-ipv6 yersinia beef-xss binwalk  chntpw dc3dd ddrescue dumpzilla extundelete foremost galleta guymager p0f pdf-parser pdfid  dhcpig iaxflood inviteflood ipv6-toolkit mdk3 reaver rtpflood slowhttptest t50 termineter thc-ipv6 thc-ssl-dos brutespray burpsuite cewl chntpw cisco-auditing-tool cmospwd crowbar crunch gpp-decrypt hash-identifier hashcat hashid hydra john johnny maskprocessor multiforcer ncrack oclgausscrack pack patator polenum rainbowcrack rcracki-mt rsmangler statsprocessor seclists thc-pptp-bruter truecrack webscarab wordlists zaproxy apktool dex2jar edb-debugger javasnoop jdim ollydbg smali valgrind yara android-sdk apktool arduino dex2jar sakis3g smali
    snap install atom
    snap install discord 
    snap install --classic sublime-text
    snap install spotify 
    snap install --classic code
    fi
    ;;
    
    *) 
    echo "Invalid Input! Please try again"
    tools
    ;;
    esac
    echo
    echo "The installation has finished! Please reboot it now"
    echo "Your lab is ready"
    echo "Have a good day!"
    exit 0
}

choice() {
    echo "Firstly do you want to skip the prerequisites installation ?"
    echo
    echo "1) Yes"
    echo "2) No"
    echo
    read -p ">> " answer 
    if [ $answer -eq 2 ]
    then
        permNet
        prerequisites   
        tools
    elif [ $answer -eq 1 ]
    then
        permNet
        tools
    else 
        echo "Invalid Input"
        echo "Please try again!"
        choice
    fi
}
        

header
choice
