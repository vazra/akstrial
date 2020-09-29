FROM golang:alpine
RUN mkdir /app
ADD . /app
EXPOSE 80
WORKDIR /app
RUN go build -o main .
CMD ["/app/main"]