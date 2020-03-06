FROM node:8.10.0-alpine
COPY . /app
WORKDIR /app
RUN npm install --production
EXPOSE 3000
CMD ["npm", "start"]
