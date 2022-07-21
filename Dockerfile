FROM --platform=$BUILDPLATFORM golang:1.16.15-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY server/ /src/server/
ARG TARGETOS TARGETARCH
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o gotv-plus-go ./server

FROM alpine
MAINTAINER Aseem Manna <hello@aseemmanna.me>
ENV PORT=8080
ENV AUTH=gopher
ENV DEBUG=false
ENV SERVER_ADDR=0.0.0.0
COPY --from=build /src/gotv-plus-go /
COPY server/templates/ /templates
EXPOSE $PORT
RUN chmod +x gotv-plus-go
ENTRYPOINT ./gotv-plus-go -addr $SERVER_ADDR:$PORT -auth $AUTH