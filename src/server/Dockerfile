FROM node:14
WORKDIR /home/node/server

COPY --chown=node:node package*.json ./
RUN npm install && npm install typescript -g

COPY --chown=node:node . .
RUN npm run build

USER node
EXPOSE 3000
CMD [ "node", "build/app.js" ]
