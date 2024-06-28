checkRoot() {
user=$(whoami)
if [ ! "${user}" = "root" ]; then
echo -e "\e[91mHey dude, run me as root!\e[0m" # Red text
exit 1
fi
}
YELLOW='\033[1;33m'
NC='\033[0m'
T_BOLD=$(tput bold)
T_GREEN=$(tput setaf 2)
T_YELLOW=$(tput setaf 3)
T_RED=$(tput setaf 1)
T_RESET=$(tput sgr0)
print_status() {
printf "\033[1;32m[\033[1;32mPass ✅\033[1;32m] \033[1;37m ⇢ \033[1;33m%s\033[1;33m\n" "$1";
}
update_packages() {
clear && clear
echo ".-.   .-..---.  ,-.  _______     "
echo " \ \ / // .-. ) | | |__   __|    "
echo "  \ V / | | |(_)| |   )| |       "
echo "   ) /  | | | | | |  (_) |       "
echo "  (_)   \ \`-' / | \`--. | |       "
echo "         )---'  |( __.'\`-'       "
echo "        (_)     (_)              "
echo -e "\033[1;32m[\033[1;32mPass ✅\033[1;32m] \033[1;37m ⇢  \033[1;33mCollecting binaries...\033[0m"
echo -e "\033[1;32m      ♻️ \033[1;37m      \033[1;33mPlease wait...\033[0m"
sudo apt-get update && sudo apt-get upgrade -y; clear && clear
local dependencies=("curl" "bc" "grep" "wget" "nano" "net-tools" "figlet" "lolcat" "git" "netcat" "openssl")
for dependency in "${dependencies[@]}"; do
if ! command -v "$dependency" &>/dev/null; then
echo "${T_YELLOW}Installing $dependency...${T_RESET}"
apt update && apt install -y "$dependency" >/dev/null 2>&1
fi
done
sudo apt-get install wget nano net-tools figlet lolcat -y
export PATH="/usr/games:$PATH"
sudo ln -s /usr/games/lolcat /usr/local/bin/lolcat
apt install sudo -y > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -qq install -yqq --no-install-recommends ca-certificates > /dev/null 2>&1
clear
echo -e "\033[1;32m[\033[1;32mPass ✅\033[1;32m] \033[1;37m ⇢  \033[1;33mCollecting binaries...\033[0m"
echo -e "\033[1;32m      ♻️ \033[1;37m      \033[1;33mPlease wait...\033[0m"
}
configger(){
read -p "Enter your domain name (or use 0.0.0.0): " domain
if [ -z "$domain" ]; then
domain="0.0.0.0"
fi
netty=$(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1)
}
fetcher () {
print_status "Fetching with latest commits..."
rm -rf /etc/M &>/dev/null
git clone -q https://github.com/JohnReaJR/M.git /etc/M
if [ $? -ne 0 ]; then
echo "Failed to fetch repo!"
exit 1
fi
print_status "Setting permissions..."
chown -R root:root /etc/M &>/dev/null
chmod -R 755 /etc/M &>/dev/null
if [ -f /etc/systemd/system/lnk-server.service ]; then
print_status "LinkLayer Service already exists."
print_status "Stopping and disabling the existing service..."
systemctl stop lnk-server.service &>/dev/null
systemctl disable lnk-server.service &>/dev/null
rm -rf /etc/systemd/system/lnk-server.service &>/dev/null
print_status "Existing service stopped, disabled, and removed."
fi
print_status "Creating lnk-server.service file..."
cat << EOF > /etc/systemd/system/lnk-server.service
[Unit]
Description=Linklayer VPN Server ResleevedNet
After=network.target

[Service]
Type=simple
WorkingDirectory=/etc/M
ExecStart=/etc/M/lnk-linux-amd64 -cfg /etc/M/cfg/config.json
Restart=always

[Install]
WantedBy=multi-user.target
EOF
print_status "Configure Config.json"
obfs_key=$(cat /etc/M/cfg/obfs_key)
cat <<EOF >/etc/M/cfg/domain
$domain
EOF
cat <<EOF >/etc/M/cfg/config.json
{
    "auth":"system",
    "banner":"          🔥   ResleevedNet v.5 Ultimate Script   🔥",
    "limit_conn_single":-1,
    "limit_conn_request":-1,
     "services":[
{
 "type":"httpdual",
        "cfg":{
          "Listen":"0.0.0.0:8000"
        }
},

       {
         "type":"tls",
         "cfg":{
          "Cert":"/etc/M/cfg/cert.pem",
           "Key":"/etc/M/cfg/key.pem",
           "Listen":"0.0.0.0:8001"
         }
       },
       {
        "type":"http",
        "cfg":{
          "Response":"HTTP/1.1 206 OK\r\n\r\n",
          "Listen":"0.0.0.0:8002"

        }
       },
	{
	"type":"http",
        "cfg":{
          "Response":"HTTP/1.1 200 OK\r\n\r\n",
          "Listen":"0.0.0.0:80"

        }
        },
       {"type":"httptls",
       "cfg":{
         "Http":{
            "Response":"HTTP/1.1 206 OK\r\n\r\n"
         },
         "TLS":{
          "Cert":"/etc/M/cfg/cert.pem",
          "Key":"/etc/M/cfg/key.pem"
         },
         "Listen":"0.0.0.0:8990"
       }
      },

{"type":"httptls",
       "cfg":{
         "Http":{
            "Response":"HTTP/1.1 200 OK\r\n\r\n"
         },
         "TLS":{
          "Cert":"/etc/M/cfg/cert.pem",
          "Key":"/etc/M/cfg/key.pem"
         },
         "Listen":"0.0.0.0:443"
       }
     
},
       {"type":"udp",
       "cfg":{
        "listen":":36718","exclude":"53,68,5300,7300","net":"$netty","cert":"/etc/M/layers/cfgs/lnklyr.crt","key":"/etc/M/layers/cfgs/lnklyr.key","obfs":"$obfs_key","max_conn_client":500000
      }
      },
       
       {"type":"dnstt",
       "cfg":{
         "Domain":"$domain",
         "Net":"$netty"
       }
      }
     ]
}
EOF
clear && clear
print_status "Terminating processes running on specified ports..."
echo "$(netstat -tulpn | grep -E '(:80|:443|:8000|:8001|:8002|:8990|:36718)' | awk '{print $4}')"
terminate_process_on_port() {
local port=$1
local pid
pid=$(lsof -t -i:"$port")
if [ -n "$pid" ]; then
kill "$pid" && echo "Process on port $port terminated."
else
echo "No process found on port $port."
fi
}
terminate_process_on_port 80
terminate_process_on_port 443
terminate_process_on_port 8000
terminate_process_on_port 8001
terminate_process_on_port 8002
terminate_process_on_port 8990
terminate_process_on_port 36718
echo "All processes terminated."
sleep 2
clear && clear
print_status "Starting Linklayer Service........"
systemctl daemon-reload &>/dev/null
systemctl enable lnk-server.service &>/dev/null
systemctl start lnk-server.service &>/dev/null
rm -f /root/install.sh && cat /dev/null >~/.bash_history && history -c
find / -type f -name "install.sh" -delete >/dev/null 2>&1
}
banner() {
clear && clear
sed -i '/figlet -k ResleevedNet | lolcat/,/echo -e ""/d' ~/.bashrc
echo 'clear' >>~/.bashrc
echo 'echo ""' >>~/.bashrc
echo 'figlet -k ResleevedNet | lolcat' >>~/.bashrc
echo 'echo -e "\t\e[1;33m         • ResleevedNet Ultimate Installer "' >>~/.bashrc
echo 'echo -e "\t\e[1;33m                  • ResleevedNet  "' >>~/.bashrc
echo 'echo ""' >>~/.bashrc
echo 'echo -e "\033[1;34m               нαωkiиѕ | ResleevedNet v.5 | нєιι ♡ нαωkiиѕ \033[0m"' >>~/.bashrc
echo 'echo -e "\033[1;36m         ╰═════════════════════════════════════════════════════╯\033[0m"' >>~/.bashrc
echo ""
echo 'echo "" ' >>~/.bashrc
echo 'echo -e ""' >>~/.bashrc
}
verification() {
clear && clear
figlet -k Resleeved | lolcat
echo -e "\033[1;34m   ResleevedNet v.5 \033[0m  | \033[1;33m v.5 Release  | ResleevedNet \033[0m"
echo -e "\033[1;36m╰═════════════════════════════════════════════════════╯\033[0m"
echo -e " 〄 \033[1;37m ⌯  \033[1;33mYou must have purchased a Key\033[0m"
echo -e " 〄 \033[1;37m ⌯  \033[1;33mif you didn't, contact ResleevedNet\033[0m"
echo -e " 〄 \033[1;37m ⌯ ⇢ \033[1;33mhttps://t.me/VeCNa_rK_bot \033[0m"
echo -e " 〄 \033[1;37m ⌯  \033[1;33mYou can also contact @VeCNa_rK_bot on Telegram\033[0m"
echo -e "\033[1;36m──────────────────────────────────────────────────────────•\033[0m"
read -p "┈➤ Please enter the Installation key ↩︎" key
sleep 2
echo ""
echo -e "\033[1;33m┈➤ Verification successful..........\033[0m"
echo ""
echo -e "\033[1;32m┈➤ ♻️ Proceeding with the installation..........\033[0m"
sleep 1
echo ""
linklayer_inst() {
configger
fetcher
}
linklyr() {
figlet -k LinkLayer | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1'
echo -e "\033[1;36m──────────────────────────────────────────────────────────•\033[0m"
echo -e "\033[1;32m[\033[1;32mPass ✅\033[1;32m] \033[1;37m ⇢  \033[1;33mChecking libs...\033[0m"
echo ""
echo -e "\033[1;32m      ♻️ \033[1;37m      \033[1;33mPlease wait...\033[0m"
mv /etc/M/bin/link /usr/bin/link &>/dev/null
chmod +x /usr/bin/link &>/dev/null
}
linklayer_inst
linklyr
sleep 2
clear
}
main() {
clear && clear
checkRoot
update_packages
banner
verification
clear && clear
figlet -k LinkLayer | lolcat
echo -e "\033[1;36mLinkLaYerVPN v.5 Installation Script\033[0m"
echo -e "\033[1;36m──────────────────────────────────────────────────────────•\033[0m"
echo -e "\033[1;32mLinkLaYerVPN Installation completed!\033[0m"
echo -e "\033[1;36mType: \033[1;33mlink \033[1;33m\033[1;36mto access the menu\033[0m"
echo ""
read -p "┈➤ Press any key to exit ↩︎" key
}
main
