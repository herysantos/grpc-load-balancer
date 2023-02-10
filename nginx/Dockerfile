FROM golang:1.18 as base

WORKDIR /

COPY . .

RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux go build -o app .

FROM gcr.io/distroless/static:nonroot AS release

WORKDIR /
COPY --from=base /app .
USER 65532:65532

ENTRYPOINT ["/app"]