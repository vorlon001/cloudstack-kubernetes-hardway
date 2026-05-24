#!/usr/bin/bash

export KUBECONFIG=/etc/kubernetes/admin.kubeconfig
kubectl get node,pod -A -o wide --insecure-skip-tls-verify
