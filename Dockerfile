FROM node AS builder
WORKDIR /vue
COPY . ./
RUN yarn build

FROM httpd
COPY --from=builder ./vue/dist /usr/local/apache2/htdocs/
