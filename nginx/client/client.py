import grpc
import hello_pb2_grpc
import hello_pb2
import time


def main():
    request = hello_pb2.HelloRequest(name="timus")

    response = stub.SayHello(request)
    print(response)


if __name__ == '__main__':
    with open('../certs/xip.crt', 'rb') as f:
        creds = grpc.ssl_channel_credentials(f.read())
    channel = grpc.secure_channel('127.0.0.1.xip.io:443', creds)
    stub = hello_pb2_grpc.GreeterStub(channel)
    while True:
        main()
        time.sleep(1)