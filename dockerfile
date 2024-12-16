FROM node:14
WORKDIR /usr/src/app
COPY server.js .
RUN npm install
EXPOSE 8080
CMD ["node", "server.js"]
