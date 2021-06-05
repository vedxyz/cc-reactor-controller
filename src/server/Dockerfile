FROM node:14

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install
RUN npm install typescript -g

COPY . .
RUN npm run build

EXPOSE 3000

USER node
CMD [ "node", "build/app.js" ]
