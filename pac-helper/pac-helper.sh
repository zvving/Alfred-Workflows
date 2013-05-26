# set it by yourself
proxy_1=""
proxy_2=""

DEVICE=$(networksetup -listnetworkserviceorder | awk '
    BEGIN {
        "netstat -rn | grep default " | getline var
        split(var, ARRAY, " ")
    }

    { if ($5 ~ ARRAY[6]) { NAME=$3 } }

    END { print NAME }
')

proxy_url=""
disable_flag="flag"

case "{query}" in
    1)
		proxy_url="$proxy_1"
    ;;
    2)
		proxy_url="$proxy_2"
    ;;
    # set more pac in here.
    *)
		proxy_url="$disable_flag"
    ;;
esac

if [ -n "$proxy_url" ]; then
	if [ "$proxy_url" = "$disable_flag" ]; then
		networksetup -setautoproxystate ${DEVICE%,*} off
		echo "disable autoproxy"
	else
		networksetup -setautoproxyurl ${DEVICE%,*} ${proxy_url}
		echo "switch to ${proxy_url}"
	fi
else
	echo "please set your pac url."
fi
