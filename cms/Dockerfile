FROM alpine:3

RUN apk add --update --no-cache\
    git\
    npm\
    nodejs\
    yarn\
    curl\
    openssh

WORKDIR /srv/app

COPY ./package.json ./
COPY ./yarn.lock ./

RUN yarn install

COPY . .

RUN chmod +x cd.sh
RUN mkdir -p "$HOME/.ssh"
RUN mv id_rsa "$HOME/.ssh/id_rsa"
RUN mv ssh_known_hosts /etc/ssh/ssh_known_hosts

ENV NODE_ENV production

RUN yarn build

EXPOSE 1337

CMD ["yarn", "start"]
