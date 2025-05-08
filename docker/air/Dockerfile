FROM golang:1.23-alpine
RUN apk update
RUN apk add --no-cache ffmpeg ffmpegthumbnailer
RUN go install github.com/air-verse/air@latest
ENTRYPOINT ["/go/bin/air"]
