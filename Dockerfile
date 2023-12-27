FROM node:alpine as builder

WORKDIR /usr/src/app

COPY package.json ./

RUN npm install

# node_modules가 위에서 설치가 되므로 아래에 복사하면 시간만 늘어난다 (중복된 것을 복사하므로)
# 따라서 도커 환경에서 리엑트를 돌린다면 로컬에 있는 node_modules는 지워도 무방하다
COPY ./ ./

RUN npm run build

FROM nginx

# /usr/src/app/build에 저장되어 있는 파일들을 /usr/share/nginx/html로 복사 -> 브라우저에서 http 요청이 올때 알맞은 파일을 nginx가 보여줌
COPY --from=builder /usr/src/app/build /usr/share/nginx/html