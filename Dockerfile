FROM golang:alpine3.15 as build-stage
WORKDIR /build
COPY . .
RUN apk update && \
    apk add --no-cache gcc musl-dev bash make protoc protobuf-dev && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
RUN make build

FROM alpine:3.15
COPY --from=build-stage /build/ambassador-agent /usr/local/bin

EXPOSE 8080

CMD [ "ambassador-agent" ]