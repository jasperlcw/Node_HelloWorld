FROM node:19-bullseye-slim

RUN mkdir -p /app
WORKDIR /app
COPY . .

RUN npm install
USER node
EXPOSE 8080
CMD ["node", "server.js"]
