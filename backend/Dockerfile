FROM node:18-alpine

WORKDIR /app/backend
COPY . .

RUN npm install
# RUN npm run build

EXPOSE 8080
CMD ["npm","start"]
