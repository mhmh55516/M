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
banner1
echo -e "\033[1;33m  ⌯ Account Details\033[1;33m"
echo -e "\033[1;36m•═══════════════════════════════════════════════════•\033[0m"
echo -e "\033[1;33m・Account    ・ Password     ・ limit    ・ validity \033[0m"
echo ""
[[ ! -e /bin/ver ]] && rm -rf /bin/menu
for users in `awk -F : '$3 > 900 { print $1 }' /etc/passwd |sort |grep -v "nobody" |grep -vi polkitd |grep -vi system- |grep -v "systemd-coredump" |grep -v "snap_daemon" |grep -v "ubuntu" |grep -v "lxd" |grep -v "core"`
do
if [[ $(grep -cw $users /etc/M/layers/authy/accounts.db) == "1" ]]; then
lim=$(grep -w $users /etc/M/layers/authy/accounts.db | cut -d' ' -f2)
else
lim="1"
fi
if [[ -e "/etc/M/layers/authy/passwds/$users" ]]; then
passwds=$(cat /etc/M/layers/authy/passwds/$users)
else
passwds="Null"
fi
datauser=$(chage -l $users |grep -i co |awk -F : '{print $2}')
if [ $datauser = never ] 2> /dev/null
then
data="\033[1;33mNever\033[0m"
else
databr="$(date -d "$datauser" +"%Y%m%d")"
hoje="$(date -d today +"%Y%m%d")"
if [ $hoje -ge $databr ]
then
data="\033[1;31mExpired\033[0m"
else
dat="$(date -d"$datauser" '+%Y-%m-%d')"
data=$(echo -e "$((($(date -ud $dat +%s)-$(date -ud $(date +%Y-%m-%d) +%s))/86400)) \033[1;37mDays\033[0m")
fi
fi
Users=$(printf ' %-15s' "$users")
Passwords=$(printf '%-13s' "$passwds")
Limit=$(printf '%-10s' "$lim")
Data=$(printf '%-1s' "$data")
echo -e "\033[1;33m$Users \033[1;37m$Passwords \033[1;37m$Limit \033[1;32m$Data\033[0m"
echo -e "\033[0;34m・ ────────────────────────────────────────────────・ \033[0m"
done
echo ""
_tuser=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody | wc -l)
echo -e "\033[1;33m  ⌯ Total.Acc: \033[1;37m$_tuser  \033[0m"
echo ""
