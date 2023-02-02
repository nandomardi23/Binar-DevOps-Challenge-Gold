FROM node:18-alpine

WORKDIR /app/frontend
COPY frontend/. .

RUN npm install
RUN npm run build

EXPOSE 8081
CMD ["npm","start"]
