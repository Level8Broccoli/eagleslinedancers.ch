FROM alpine:3

RUN apk add --update --no-cache\
    nodejs\
    yarn

WORKDIR /srv/app

COPY ./package.json ./
COPY ./yarn.lock ./

RUN yarn install

COPY . .

ENV NODE_ENV production

RUN yarn build

EXPOSE 1337

CMD ["yarn", "start"]
