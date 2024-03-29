#!/usr/bin/env bashio
set -e

# https://github.com/hassio-addons/bashio


#!/usr/bin/env bashio
set +u

CONFIG_PATH=/data/options.json
# SYSTEM_USER=/data/system_user.json

HOST=$(jq --raw-output ".host" $CONFIG_PATH)
URL=$(jq --raw-output ".url" $CONFIG_PATH)

cat $CONFIG_PATH
# cat $SYSTEM_USER

# bashio::log.info "Public key:"
cat /root/.ssh/id_rsa.pub

# BASE="ssh -o StrictHostKeyChecking=no"
# TUN="-o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -N"

configPath="/root/.cloudflared/config.yml"
mkdir -p /root/.cloudflared

PEM=$(jq --raw-output ".pem" $CONFIG_PATH)

cp -Rv /ssl/$PEM /root/.cloudflared/cert.pem

# echo $PEM >> /root/.cloudflared/cert.pem
# echo "log: stdout" > $configPath
bashio::log.info "Hello this is inf o log from bashio!"
# if bashio::var.has_value "$(bashio::addon.port 4040)"; then
#   echo "web_addr: 0.0.0.0:$(bashio::addon.port 4040)" >> $configPath
# fi
if bashio::var.has_value "$(bashio::config 'host')"; then
  echo "host: $(bashio::config 'host')" >> $configPath
fi

if bashio::var.has_value "$(bashio::config 'url')"; then
  echo "url: $(bashio::config 'url')" >> $configPath
fi

if bashio::var.has_value "$(bashio::config 'pem')"; then
  echo "$(bashio::config 'pem')" >> /root/.cloudflared/cert.pem
fi

# if bashio::var.has_value "$(bashio::config 'auth_token')"; then
#   echo "authtoken: $(bashio::config 'auth_token')" >> $configPath
# fi
# if bashio::var.has_value "$(bashio::config 'region')"; then
#   echo "region: $(bashio::config 'region')" >> $configPath
# else
#   echo "No region defined, default region is US."
# fi
# cat $configPath
configfile=$(cat $configPath)
bashio::log.info "Config file: \n${configfile}"
# bashio::log.info "Config :file \n${cat /root/.cloudflared/cert.pem}"
# cloudflared --url localhost:8123

echo "#!/usr/bin/env bashio" > go.sh
echo "cloudflared-$BUILD_ARCH" --hostname "$HOST" --url "$URL" >> go.sh
chmod +x ./go.sh

./go.sh