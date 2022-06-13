FROM httpd AS builder
WORKDIR /vue
COPY . ./
CMD yarn build

FROM httpd
COPY --from=builder ./vue/dist /usr/local/apache2/htdocs/
