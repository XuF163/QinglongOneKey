#!bin/bash
if [ $EUID -ne 0 ]; then
    echo "需要以 root 权限运行脚本，请输入 root 密码："
    sudo -v
    if [ $? -ne 0 ]; then
        echo "认证失败，请检查密码是否正确。"
        exit 1
    fi
fi
sudo apt update 
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
docker pull whyour/qinglong:latest
docker run -dit \
	-v $pwd/ql/config:/ql/config \
	-v $pwd/ql/log:/ql/log \
	-v $pwd/ql/db:/ql/db \
	-v $pwd/ql/scripts:/ql/scripts \
	-v $pwd/ql/jbot:/ql/jbot \
	-p 5700:5700 \
	-e ENABLE_HANGUP=true \
	-e ENABLE_WEB_PANEL=true \
	--name qinglong \
	--hostname qinglong \
	--restart always \
	whyour/qinglong:latest
docker exec -it qinglong bash
curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/shufflewzc/QLDependency/main/Shell/QLOneKeyDependency.sh | sh

