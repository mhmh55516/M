banner() {
sed -i '/figlet -k Resleeved | lolcat/,/echo -e ""/d' ~/.bashrc
sed -i '/figlet -k Hysteria | lolcat/,/echo -e ""/d' ~/.bashrc
echo 'clear' >>~/.bashrc
echo 'echo ""' >>~/.bashrc
echo 'figlet -k LinkLayer | lolcat' >>~/.bashrc
echo 'echo -e "\t\e\033[94m⚙︎ LinkLayer VPN Manager by ResleevedNet ⚙︎\033[0m"' >>~/.bashrc
echo 'echo -e "\t\e\033[94mTelegram: @ResleevedNet // \033[0m"' >>~/.bashrc
echo 'echo -e "\t\e\033[94m..SSHX.. (c)2021 </> 2024 // \033[0m"' >>~/.bashrc
echo 'echo "" ' >>~/.bashrc
echo 'echo -e "\t\033[92mTelegram   : @Am_The_Last_Envoy | ResleevedNet" ' >>~/.bashrc
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
