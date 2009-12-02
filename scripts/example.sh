[[ "$*" == "yes" ]] && echo 'say ^1It works!'
[[ "$*" == "time" ]] && echo "say POSIX time is ^2$(date +%s)"
