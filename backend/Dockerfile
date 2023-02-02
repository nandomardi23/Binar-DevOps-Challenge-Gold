FROM node:18-alpine

WORKDIR /app/backend

COPY backend/. .
RUN npm install

# RUN npm run build

EXPOSE 8080
CMD ["npm","start"]
