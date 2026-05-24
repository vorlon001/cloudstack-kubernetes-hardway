#!/usr/bin/bash


cat <<EOF | kubectl apply -f -
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 3
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - image: harbor.iblog.pro/dockerio/library/nginx
          name: web
          ports:
            - containerPort: 80
              protocol: TCP
          readinessProbe:
            failureThreshold: 3
            httpGet:
              path: /
              port: 80
              scheme: HTTP
      tolerations:
        - effect: NoSchedule
          key: node-role.kubernetes.io/control-plane
---
apiVersion: v1
kind: Service
metadata:
  name: test-lb-200
  labels:
    color: vlan200
spec:
  allocateLoadBalancerNodePorts: true
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: 80
  selector:
    app: nginx
  type: LoadBalancer
---
apiVersion: v1
kind: Service
metadata:
  name: test-lb-400
  labels:
    color: vlan400
spec:
  allocateLoadBalancerNodePorts: true
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: 80
  selector:
    app: nginx
  type: LoadBalancer
---
apiVersion: v1
kind: Service
metadata:
  name: test-lb-600
  labels:
    color: vlan600
spec:
  allocateLoadBalancerNodePorts: true
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: 80
  selector:
    app: nginx
  type: LoadBalancer
---
apiVersion: v1
kind: Service
metadata:
  name: test-lb-800
  labels:
    color: vlan800
spec:
  allocateLoadBalancerNodePorts: true
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: 80
  selector:
    app: nginx
  type: LoadBalancer
EOF

