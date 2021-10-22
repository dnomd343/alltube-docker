get_github_latest_version() {
  VERSION=$(curl --silent "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/');
}

apk add curl wget
mkdir -p /tmp
get_github_latest_version "Rudloff/alltube"
wget https://github.com/Rudloff/alltube/releases/download/$VERSION/alltube-$VERSION.zip -O /tmp/alltube.zip
unzip -d /tmp/ /tmp/alltube.zip
wget https://install.phpcomposer.com/installer -O /tmp/alltube/composer-setup.php
mv /nginx.conf /tmp/alltube/
mv /init.sh /tmp/alltube/
