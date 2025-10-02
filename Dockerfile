# builder
FROM golang:1.22-alpine AS builder
WORKDIR /app
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64
ENV GONOPROXY=github.com/mag1666888-del/* GONOSUMDB=github.com/mag1666888-del/* GOPRIVATE=github.com/mag1666888-del/*
RUN apk add --no-cache git
COPY go.mod go.sum ./
RUN git config --global url."https://github.com/mag1666888-del/".insteadOf "git@github.com:mag1666888-del/"
RUN git clone https://github.com/mag1666888-del/protocol.git /protocol
RUN go mod download
COPY . .
# 根据项目结构构建chat-api
RUN go build -o /out/chat-api ./cmd/api/chat-api

# runtime
FROM alpine:3.19
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app
COPY --from=builder /out/chat-api /app/chat-api
COPY --from=builder /app/config /app/config
COPY --from=builder /app/start-config.yml /app/start-config.yml
EXPOSE 8080
ENTRYPOINT ["/app/chat-api", "-c", "/app/config"]
