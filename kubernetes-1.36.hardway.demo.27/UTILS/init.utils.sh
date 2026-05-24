#!/usr/bin/bash

#
# 4.1.3
# 
#
set -x

export HELMVERSION=( "3.20.1" "4.1.3" )
export platform="amd64"

for item in ${HELMVERSION[*]}
do
    export HELMFILE="helm-v${item}-linux-${platform}.tar.gz"
    curl -o ${HELMFILE} https://get.helm.sh/${HELMFILE}
done


kustomize_version=( "5.9.1" "5.7.1" "5.6.0" "5.5.0" "5.4.3" "5.3.0" "5.2.1" "5.1.1" "5.0.3" "4.5.7" "4.5.5" "4.5.3" "4.4.1" "4.0.5" "3.10.0" "3.9.4" "3.8.10")


for item in ${kustomize_version[*]}
do
    printf "   %s\n" $item
    kustomize_file="kustomize_v${item}_linux_${platform}.tar.gz"
    wget -O ${kustomize_file} https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${item}/${kustomize_file}
done



wget -O jq-linux-amd64-1.8.1 https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-amd64
chmod +x jq-linux-amd64-1.8.1

wget -O yq_linux_amd64-4.48.1 https://github.com/mikefarah/yq/releases/download/v4.48.1/yq_linux_amd64
chmod +x yq_linux_amd64-4.48.1


VERSION=1.2.0
ARCH=amd64
curl -L -o virtctl https://github.com/kubevirt/kubevirt/releases/download/v1.7.2/virtctl-v1.7.2-linux-amd64


CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
#sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
#sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
#rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}


wget  -O nerdctl-2.2.1-linux-amd64.tar.gz https://github.com/containerd/nerdctl/releases/download/v2.2.1/nerdctl-2.2.1-linux-amd64.tar.gz




wget https://github.com/istio/istio/releases/download/1.29.1/istioctl-1.29.1-linux-amd64.tar.gz

wget https://github.com/arttor/helmify/releases/download/v0.4.19/helmify_Linux_x86_64.tar.gz

wget https://github.com/helmfile/helmfile/releases/download/v1.4.2/helmfile_1.4.2_linux_amd64.tar.gz
