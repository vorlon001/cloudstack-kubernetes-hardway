#!/usr/bin/bash

systemctl disable kubelet.service
systemctl stop kubelet.service
systemctl status kubelet.service
