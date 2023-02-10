const PROTO_PATH = __dirname + '/../../protos/helloworld.proto';

const grpc = require('@grpc/grpc-js');
const protoLoader = require('@grpc/proto-loader');

const packageDefinition = protoLoader.loadSync(
    PROTO_PATH,
    {keepCase: true,
     longs: String,
     enums: String,
     defaults: true,
     oneofs: true
    });
const hello_proto = grpc.loadPackageDefinition(packageDefinition).helloworld;

const client = new hello_proto.Greeter(
    process.env.SERVER_URL,
    grpc.credentials.createInsecure()
);

module.exports = client;