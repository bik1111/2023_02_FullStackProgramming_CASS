# Use the official Node.js 16 Alpine image
FROM node:16-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install --silent

# Copy the entire project to the working directory
COPY . .

EXPOSE 3000

WORKDIR /app/backend


CMD ["node", "app.js"]
