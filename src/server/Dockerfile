FROM node:14

RUN mkdir -p /home/node/server && chown -R node:node /home/node/server
WORKDIR /home/node/server

COPY --chown=node:node package*.json ./
RUN npm install && npm install typescript -g

COPY --chown=node:node . .
RUN npm run build

EXPOSE 3000
USER node
CMD [ "node", "build/app.js" ]
