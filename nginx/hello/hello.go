package hello

import (
	"context"
	fmt "fmt"
	"log"
	"os"
)

type Server struct{}

func (s *Server) SayHello(ctx context.Context, in *HelloRequest) (*HelloResponse, error) {
	log.Println("Received: ", in.Name)
	hostname, err := os.Hostname()
	if err != nil {
		return nil, err
	}
	return &HelloResponse{Message: fmt.Sprintf("Hello %s from %s", in.Name,  hostname)}, nil
}