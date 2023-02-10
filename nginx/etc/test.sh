# change the IP address
export MY_IP=127.0.0.1

# create an SSL certificate
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout xip.key -out xip.crt -subj "/CN=$MY_IP.xip.io" \
  -addext "subjectAltName=DNS:$MY_IP.xip.io"

kubectl create secret tls xip-tls --cert=xip.crt --key=xip.key

echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grpcbin
  annotations:
    kubernetes.io/ingress.class: \"nginx\"
    nginx.ingress.kubernetes.io/backend-protocol: GRPC
    nginx.ingress.kubernetes.io/ssl-redirect: \"true\"
spec:
  tls:
    - hosts:
      - $MY_IP.xip.io
      secretName: xip-tls
  rules:
  - host: $MY_IP.xip.io
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: grpcbin
            port:
              number: 9000

---
kind: Pod
apiVersion: v1
metadata:
  name: grpcbin
  labels:
    app: grpcbin
spec:
  containers:
  - name: grpcbin
    image: moul/grpcbin

---
kind: Service
apiVersion: v1
metadata:
  name: grpcbin
spec:
  selector:
    app: grpcbin
  ports:
  - name: plain
    port: 9000
  - name: secured
    port: 9001

" | kubectl apply -f -