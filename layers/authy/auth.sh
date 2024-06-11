USERS_FILE="/etc/M/layers/authy/auth.txt"
if [ ! -f "$USERS_FILE" ]; then
echo "Users file not found: $USERS_FILE"
exit 1
fi
declare -A valid_users
while IFS=":" read -r username password; do
valid_users["$username"]="$password"
done < "$USERS_FILE"
if [ $# -eq 2 ]; then
if [[ -n "${valid_users[$1]}" && "${valid_users[$1]}" = "$2" ]]; then
exit 0  # Authentication successful
fi
fi
exit 1  # Authentication failed
