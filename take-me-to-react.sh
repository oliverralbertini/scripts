read url
url="$(echo $url | sed -e "s/8001/3000/" -e "s/dashboard/react-dashboard/")"
if [[ $url =~ "http" ]]; then
  echo "$url"
else
  echo "http://$url"
fi
# "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" "${url}"
