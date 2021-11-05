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
RUN mkdir -p /tmp/.ssh
RUN mv id_rsa /tmp/.ssh/id_rsa

ENV NODE_ENV production

RUN yarn build

EXPOSE 1337

CMD ["yarn", "start"]
