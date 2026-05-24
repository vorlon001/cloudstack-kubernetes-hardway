#!/usr/bin/bash
#https://get.helm.sh/helm-v3.12.2-linux-amd64.tar.gz
set -x

export HELMVERSION=( "4.1.3" "3.20.1" )
export platform="amd64"

for item in ${HELMVERSION[*]}
do
    export HELMFILE="helm-v${item}-linux-${platform}.tar.gz"
    tar -zxvf ${HELMFILE}
    mv linux-${platform}/helm /usr/bin/helm-v${item}
    rm -R linux-${platform}
    chmod +x /usr/bin/helm-v${item}
    cp /usr/bin/helm-v${item} /usr/bin/helm
done


kustomize_version=( "5.8.1" "5.7.1" "5.6.0" "5.5.0" "5.4.3" "5.3.0" "5.2.1" "5.1.1" "5.0.3" "4.5.7" "4.5.5" "4.5.3" "4.4.1" "4.0.5" "3.10.0" "3.9.4" "3.8.10")

for item in ${kustomize_version[*]}
do
    printf "   %s\n" $item
    kustomize_file="kustomize_v${item}_linux_${platform}.tar.gz"
    tar -zxvf ${kustomize_file}
    mv kustomize kustomize_${item}
    mv kustomize kustomize_${item} /usr/bin
done


cp jq-linux-amd64-1.8.1 /usr/bin/jq
cp yq_linux_amd64-4.48.1 /usr/bin/yq


#CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)
#CLI_ARCH=amd64
#sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
#rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sudo tar xzvfC nerdctl-2.2.1-linux-amd64.tar.gz /usr/local/bin


tar zxvfC istioctl-1.29.1-linux-amd64.tar.gz /usr/local/bin
tar zxvfC helmify_Linux_x86_64.tar.gz /usr/local/bin
tar zxvfC helmfile_1.4.2_linux_amd64.tar.gz /usr/local/bin
