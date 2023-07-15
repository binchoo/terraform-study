#!/bin/bash
yum update -y
yum install -y https://dl.grafana.com/oss/release/grafana-10.0.2-1.x86_64.rpm

systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server.service
