# build stage
FROM node:20.9.0-alpine as build-stage

WORKDIR /client

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# production stage
FROM nginx:1.25.3-alpine as production-stage
COPY --from=build-stage /client/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]