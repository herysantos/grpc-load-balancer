# Nginx Ingress Controller para GRPC

Documentação: https://kubernetes.github.io/ingress-nginx/user-guide/grpc/

Medium: https://faun.pub/grpc-loadbalancing-in-gke-using-nginx-ingress-controller-40d0b1971c3c


## Instalação

### Helm

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
```
* No momento que o ingress-nginx é instalado, ele cria um LoadBalancer no GCP, que pode ser acessado pelo IP externo (ou interno se preferir).


### Kubectl

Antes de aplicar o manifesto crie o secret tls:

```bash
kubectl create secret tls xip-tls --cert=certs/xip.crt --key=certs/xip.key
```

```bash
kubectl apply -f manifests/*
```

## Exemplo de uso

Antes de continuar, adicione o IP externo do LoadBalancer no seu arquivo `/etc/hosts` apontando para o domínio `127.0.0.1.xip.io`: :

### Se comunicando com o servidor grpc através do comando grpcurl

```bash
grpcurl -insecure -d '{"name": "World"}' 127.0.0.1.xip.io:443 hello.Greeter/SayHello
```


### Testando o cliente grpc

```bash
python3 client/client.py
```
