FROM node:19-bullseye-slim

WORKDIR /app
COPY package* .
COPY server.js .
COPY public public

RUN npm install
CMD ["node", "server.js"]
