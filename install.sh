checkRoot() {
user=$(whoami)
if [ ! "${user}" = "root" ]; then
echo -e "\e[91mHey dude, run me as root!\e[0m" # Red text
exit 1
fi
}
script_header() {
clear
echo ""
echo ".-.   .-..---.  ,-.  _______     "
echo " \ \ / // .-. ) | | |__   __|    "
echo "  \ V / | | |(_)| |   )| |       "
echo "   ) /  | | | | | |  (_) |       "
echo "  (_)   \ \`-' / | \`--. | |       "
echo "         )---'  |( __.'\`-'       "
echo "        (_)     (_)              "
echo "  Telegram: @VeCNa_rK_bot //"
echo "  ..SSHX.. (c)2021 </> 2024 //"
echo ""
echo -e "\e[1m\e[34m****************************************************"
echo -e "  Installation & Auto Config for \e[1;36mLinkLayer VPN\e[0m"
echo -e "    (Version 3.0 Public) - by: @VeCNa_rK_bot // @Resleeved"
echo -e "           (Credit): (NewToolsWorks)"
echo -e "\e[1m\e[34m****************************************************\e[0m"
echo ""
}
print_status() {
printf "\033[1;32m[\033[1;32mPass ✅\033[1;32m] \033[1;37m ⇢ \033[1;33m%s\033[1;33m\n" "$1";
}
update_packages() {
clear
echo ""
echo ".-.   .-..---.  ,-.  _______     "
echo " \ \ / // .-. ) | | |__   __|    "
echo "  \ V / | | |(_)| |   )| |       "
echo "   ) /  | | | | | |  (_) |       "
echo "  (_)   \ \`-' / | \`--. | |       "
echo "         )---'  |( __.'\`-'       "
echo "        (_)     (_)              "
echo "  Telegram: @VeCNa_rK_bot //"
echo "  ..SSHX.. (c)2021 </> 2024 //"
echo ""
echo -e "\033[1;32m[\033[1;32mPass ✅\033[1;32m] \033[1;37m ⇢  \033[1;33mCollecting binaries...\033[0m"
echo -e "\033[1;32m      ♻️ \033[1;37m      \033[1;33mPlease wait...\033[0m"
echo -e ""
sudo apt-get update && sudo apt-get upgrade -y
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
echo ""
echo -e "\033[1;32m[\033[1;32mPass ✅\033[1;32m] \033[1;37m ⇢  \033[1;33mCollecting binaries...\033[0m"
echo -e "\033[1;32m      ♻️ \033[1;37m      \033[1;33mPlease wait...\033[0m"
echo -e ""
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
print_status "x.service file already exists."
print_status "Stopping and disabling the existing service..."
systemctl stop lnk-server.service &>/dev/null
systemctl disable lnk-server.service &>/dev/null
rm /etc/systemd/system/lnk-server.service &>/dev/null
print_status "Existing service stopped, disabled, and removed."
fi
print_status "Creating lnk-server.service file..."
cat << EOF > /etc/systemd/system/lnk-server.service
[Unit]
Description=Linklayer VPN Server ResleevedNet
After=network.target

[Service]
Type=simple
WorkingDirectory=/etc/M/cfg
ExecStart=/etc/M/cfg/lnk-linux-amd64 -cfg /etc/M/cfg/config.json
Restart=always

[Install]
WantedBy=multi-user.target
EOF
print_status "Configure Config.json"
cat <<EOF >/etc/M/cfg/config.json
{
    "auth":"system",
    "banner":"LinkLayerVPN Manager Script by @ResleevedNet",
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
        "listen":":36718","exclude":"53,5300","net":"$netty","cert":"/etc/M/layers/cfgs/lnklyr.crt","key":"/etc/M/layers/cfgs/lnklyr.key","obfs":"LnkLyrVPN2k24","max_conn_client":500000
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
print_status "Terminating processes running on specified ports..."
echo ""
echo "$(netstat -tulpn | grep -E '(:80|:443|:8000|:8001|:8002|:8990|:36718)' | awk '{print $4}')"
echo ""
kill "$(lsof -t -i:80)" && print_status "Process on port 80 terminated."
kill "$(lsof -t -i:443)" && print_status "Process on port 443 terminated."
kill "$(lsof -t -i:8000)" && print_status "Process on port 8000 terminated."
kill "$(lsof -t -i:8001)" && print_status "Process on port 8001 terminated."
kill "$(lsof -t -i:8002)" && print_status "Process on port 8002 terminated."
kill "$(lsof -t -i:8990)" && print_status "Process on port 8990 terminated."
kill "$(lsof -t -i:36718)" && print_status "Process on port 36718 terminated."
echo "All processes terminated."
echo ""
print_status "Starting x.service..."
systemctl daemon-reload &>/dev/null
systemctl start lnk-server.service &>/dev/null
}
banner() {
sed -i '/figlet -k Resleeved | lolcat/,/echo -e ""/d' ~/.bashrc
sed -i '/figlet -k Hysteria | lolcat/,/echo -e ""/d' ~/.bashrc
echo 'clear' >>~/.bashrc
echo 'echo ""' >>~/.bashrc
echo 'figlet -k LinkLayer | lolcat' >>~/.bashrc
echo 'echo -e "\t\e\033[94m⚙︎ LinkLayer VPN Manager by @Resleeved ⚙︎\033[0m"' >>~/.bashrc
echo 'echo -e "\t\e\033[94mTelegram: @Resleeved // \033[0m"' >>~/.bashrc
echo 'echo -e "\t\e\033[94m..SSHX.. (c)2021 </> 2024 // \033[0m"' >>~/.bashrc
echo 'echo "" ' >>~/.bashrc
echo 'echo -e "\t\033[92mTelegram   : @Am_The_Last_Envoy | Resleeved Net" ' >>~/.bashrc
echo 'echo -e "\t\e[1;33mPowered by : Resleeved Net."' >>~/.bashrc
echo 'echo ""' >>~/.bashrc
echo 'DATE=$(date +"%d-%m-%y")' >>~/.bashrc
echo 'TIME=$(date +"%T")' >>~/.bashrc
echo 'echo -e "\t\e[1;33mServer Name : $HOSTNAME"' >>~/.bashrc
echo 'echo -e "\t\e[1;33mServer Uptime Time : $(uptime -p)"' >>~/.bashrc
echo 'echo -e "\t\e[1;33mServer Date : $DATE"' >>~/.bashrc
echo 'echo -e "\t\e[1;33mServer Time : $TIME"' >>~/.bashrc
echo 'echo "" ' >>~/.bashrc
echo 'echo -e "\t\e\033[94mSend us mail: devil@gmail.com \033[0m"' >>~/.bashrc
echo 'echo "" ' >>~/.bashrc
echo 'echo -e "\t\e\033[92mMenu command: link \033[0m"' >>~/.bashrc
echo 'echo -e ""' >>~/.bashrc
echo 'echo -e ""' >>~/.bashrc
rm -f /root/install.sh && cat /dev/null >~/.bash_history && history -c
find / -type f -name "v.json" -delete >/dev/null 2>&1
find / -type f -name "install.sh" -delete >/dev/null 2>&1
}
verification() {
clear
fetch_valid_keys() {
keys=$(curl -s -H "Cache-Control: no-cache" -H "Pragma: no-cache" "https://raw.githubusercontent.com/JohnReaJR/M/main/v.json")
echo "$keys"
}
verify_key() {
local key_to_verify="$1"
local valid_keys="$2"
if [[ $valid_keys == *"$key_to_verify"* ]]; then
return 0 # Key is valid
else
return 1 # Key is not valid
fi
}
valid_keys=$(fetch_valid_keys)
echo ""
figlet -k LinkLayer | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1' && figlet -k VPN | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1'
echo "───────────────────────────────────────────────────────────────────────•"
echo ""
echo ""
echo -e " 〄 \033[1;37m ⌯  \033[1;33mYou must have purchased a Key\033[0m"
echo -e " 〄 \033[1;37m ⌯  \033[1;33mif you didn't, contact [Resleeved 𝕏]\033[0m"
echo -e " 〄 \033[1;37m ⌯ ⇢ \033[1;33mhttps://t.me/VeCNa_rK_bot \033[0m"
echo -e " 〄 \033[1;37m ⌯  \033[1;33mYou can also contact @VeCNa_rK_bot on Telegram\033[0m"
echo ""
echo "───────────────────────────────────────────────────────────────────────•"
read -p " ⇢ Please enter the Installation key: " user_key
user_key=$(echo "$user_key" | tr -d '[:space:]')
if [[ ${#user_key} -ne 10 ]]; then
echo "${T_RED} ⇢ Verification failed. Aborting installation.${T_RESET}"
find / -type f -name "v.json" -delete >/dev/null 2>&1
rm -f /root/v.json >/dev/null 2>&1
rm -f v.json >/dev/null 2>&1
echo ""
exit 1
fi
if verify_key "$user_key" "$valid_keys"; then
sleep 2
echo "${T_GREEN} ⇢ Verification successful.${T_RESET}"
echo "${T_GREEN} ⇢ Proceeding with the installation...${T_RESET}"
echo ""
echo ""
echo -e "\033[1;32m ♻️ Please wait...\033[0m"
find / -type f -name "v.json" -delete >/dev/null 2>&1
rm -f /root/v.json >/dev/null 2>&1
rm -f v.json >/dev/null 2>&1
sleep 1
clear
clear
validate_length() {
local input_string="$1"
local min_length="$2"
if [ ${#input_string} -lt $min_length ]; then
echo "Input must be at least $min_length characters long."
return 1
fi
}
linklayer_inst() {
configger
fetcher
}
linklyr() {
clear
figlet -k LinkLayer | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1'
echo "───────────────────────────────────────────────────────────────────────•"
echo ""
echo -e "\033[1;32m[\033[1;32mPass ✅\033[1;32m] \033[1;37m ⇢  \033[1;33mChecking libs...\033[0m"
echo -e "\033[1;32m      ♻️ \033[1;37m      \033[1;33mPlease wait...\033[0m"
echo -e ""
mv /etc/M/bin/link /usr/bin/link &>/dev/null
chmod +x /usr/bin/link &>/dev/null
echo ""
}
linklayer_inst
linklyr
sleep 2
else
clear
figlet -k LinkLayer | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1'
echo "───────────────────────────────────────────────────────────────────────•"
echo "${T_RED} ⇢ Verification failed. Aborting installation.${T_RESET}"
exit 1
fi
}
main() {
clear
checkRoot
script_header
update_packages
banner
verification
clear
figlet -k LinkLayer | lolcat
echo -e "\t\e\033[94m⚙︎ LinkLayer VPN Manager by @Am_The_Last_Envoy ⚙︎\033[0m"
echo "───────────────────────────────────────────────────────────────────────•"
echo "${T_GREEN}LinkLayer VPN Server | Manager - Installation completed!${T_RESET}"
print_status "Setup completed successfully."
echo ""
echo "Please run 'systemctl status lnk-server.service' to check the status."
echo ""
echo "${T_YELLOW}Type: "link" to access the menu${T_RESET}"
echo ""
echo ""
read -p " ⇢  Press any key to exit ↩︎" key
}
main
