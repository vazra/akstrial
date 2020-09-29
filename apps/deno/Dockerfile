FROM hayd/alpine-deno:latest

EXPOSE 80

WORKDIR /usr/app

COPY . .

CMD [ "run", "--allow-net", "server.ts" ]
