# Nginx Ingress Controller para GRPC

Documentação: https://docs.nginx.com/nginx-ingress-controller/intro/overview/

Medium: https://faun.pub/grpc-loadbalancing-in-gke-using-nginx-ingress-controller-40d0b1971c3c

## Instalação

### Helm

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
```

- No momento que o ingress-nginx é instalado, ele cria um LoadBalancer no GCP, que pode ser acessado pelo IP externo (pode ser alterado para rede interna se preferir).

### Criando certificado auto assinado (Opcional)

Para uso do grpc no nginx ingress controller o uso de um certificado TLS e um domínio é obrigatório conforme a documentação.

O certificado auto assinado para esse exemplo já foi criado e está em certs, mas pra caso quiser criar um novo, segue o comando:

```bash
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout certs/xip.key -out certs/xip.crt -subj "/CN=127.0.0.1.xip.io" \
  -addext "subjectAltName=DNS:127.0.0.1.xip.io"
```

### Kubectl

Antes de aplicar o manifesto crie o secret tls contendo os certificados já criados anteriormente:

```bash
kubectl create secret tls xip-tls --cert=certs/xip.crt --key=certs/xip.key
```

```bash
kubectl apply -f manifests/
```

## Exemplo de uso

Antes de continuar, adicione o IP externo do LoadBalancer no seu arquivo `/etc/hosts` apontando para o domínio `127.0.0.1.xip.io`: :

### Se comunicando com o servidor grpc através do comando grpcurl

```bash
grpcurl -insecure -d '{"name": "World"}' 127.0.0.1.xip.io:443 hello.Greeter/SayHello
```

### Testando o cliente grpc

```bash
GRPC_SERVER="127.0.0.1.xip.io:443" python3 client/client.py
```

O resultado será algo como:

```bash
message: "Hello World from go-grpc-server-cf6d9b6cd-gdfm6"

message: "Hello World from go-grpc-server-cf6d9b6cd-ghdr9"

message: "Hello World from go-grpc-server-cf6d9b6cd-6tnv4"

message: "Hello World from go-grpc-server-cf6d9b6cd-r6f8j"

message: "Hello World from go-grpc-server-cf6d9b6cd-gdfm6"
```

O metódo de load balancing usado no arquivo está definido como round_robin, mas existem outros métodos disponíveis, como por exemplo: least_conn, random, etc.
Ver a documentaçao:
https://docs.nginx.com/nginx-ingress-controller/configuration/ingress-resources/advanced-configuration-with-annotations/#:~:text=Example-,nginx.org/lb%2Dmethod,-lb%2Dmethod
