if [ "$EUID" -ne 0 ]; then
echo -e "\033[1;31mHey dude, run me as root!\033[0m"
exit 1
fi
banner1() {
clear
figlet -k LinkLayer | lolcat
echo -e "\033[1;34m  VPN Manager\033[0m | \033[1;33m3.0 Public | @ResleevedNet | @Am_The_Last_Envoy\033[0m"
echo -e "\033[1;36m╰═════════════════════════════════════════════════════╯\033[0m"
echo ""
}
[[ ! -e /usr/lib/voltx ]] && rm -rf /bin/ > /dev/null 2>&1
database="/etc/M/layers/authy/accounts.db"
banner1
echo -e "\033[1;33m  ⌯ Account Remover\033[1;33m"
echo -e "\033[1;36m•═══════════════════════════════════════════════════•\033[0m"
echo ""
echo -e "\e[36m 01⎬➤ Remove Account"
echo -e "\e[36m 00⎬➤ Return"
echo ""
read -p "$(echo -e "\033[1;32m・ Pick an option \033[1;31m:\033[1;37m : ")" -e -i 1 resp
if [[ "$resp" = "1" ]]; then
clear
banner1
echo -e "\033[1;33m  ⌯ Remove Account ⌯  \033[1;33m"
echo -e "\033[1;36m•═══════════════════════════════════════════════════•\033[0m"
echo ""
echo -e "\033[1;33m・ List Of Accounts Available: \033[0m"
echo -e "\033[1;36m•═══════════════════════════════════════════════════•\033[0m"
echo""
_userT=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody)
i=0
unset _userPass
while read _user; do
i=$(expr $i + 1)
_oP=$i
[[ $i == [1-9] ]] && i=0$i && oP+=" 0$i"
echo -e "\033[1;31m[\033[1;36m$i\033[1;31m] \033[1;37m- \033[1;32m$_user\033[0m"
_userPass+="\n${_oP}:${_user}"
done <<< "${_userT}"
echo ""
echo -e "\033[1;36m•═══════════════════════════════════════════════════•\033[0m"
num_user=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody | wc -l)
echo -ne "\033[1;32m・ Enter or select an account \033[1;33m[\033[1;36m1\033[1;31m-\033[1;36m$num_user\033[1;33m]\033[1;37m: " ; read option
user=$(echo -e "${_userPass}" | grep -E "\b$option\b" | cut -d: -f2)
if [[ -z $option ]]; then
echo " ・ User is empty or invalid!   "
sleep 3
remove_user
elif [[ -z $user ]]; then
echo "・ User is empty or invalid! "
sleep 3
remove_user
else
if cat /etc/passwd |grep -w $user > /dev/null; then
echo ""
pkill -f "$user" > /dev/null 2>&1
deluser --force $user > /dev/null 2>&1
echo -e "\E[41;1;37m・ User $user successfully removed! \E[0m"
grep -v ^$user[[:space:]] /etc/M/layers/authy/accounts.db > /tmp/ph ; cat /tmp/ph > /etc/M/layers/authy/accounts.db
rm /etc/M/layers/authy/passwds/$user 1>/dev/null 2>/dev/null
exit 1
elif [[ "$(cat "$database"| grep -w $user| wc -l)" -ne "0" ]]; then
ps x | grep $user | grep -v grep | grep -v pt > /tmp/rem
if [[ `grep -c $user /tmp/rem` -eq 0 ]]; then
deluser --force $user > /dev/null 2>&1
echo ""
echo -e "\E[41;1;37m・ Account $user successfully removed! \E[0m"
grep -v ^$user[[:space:]] /etc/M/layers/authy/accounts.db > /tmp/ph ; cat /tmp/ph > /etc/M/layers/authy/accounts.db
rm /etc/M/layers/authy/passwds/$user 1>/dev/null 2>/dev/null
remove_user
else
echo ""
echo "・ Account logged out. Disconnecting..."
pkill -f "$user" > /dev/null 2>&1
deluser --force $user > /dev/null 2>&1
echo -e "\E[41;1;37m・ Account $user successfully removed! \E[0m"
grep -v ^$user[[:space:]] /etc/M/layers/authy/accounts.db > /tmp/ph ; cat /tmp/ph > /etc/M/layers/authy/accounts.db
rm /etc/M/layers/authy/passwds/$user 1>/dev/null 2>/dev/null
sudo userdel -r "$user" 1>/dev/null 2>/dev/null
if [[ -e /etc/openvpn/server.conf ]]; then
remove_ovp $user
fi
remove_user
fi
else
echo "・ The User $user does not exist!"
fi
fi
elif [[ "$resp" = "2" ]]; then
link
else
echo -e "\n\033[1;31mNot a valid option!\033[0m"
sleep 1.5s
link
fi
