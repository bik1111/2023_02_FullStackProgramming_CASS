# Use the official Node.js 16 Alpine image
FROM node:16-alpine

# Set the working directory inside the container
WORKDIR /backend

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install --silent

# Copy the entire project to the working directory
COPY . .

# Expose the port your app runs on
EXPOSE 3000


# Command to run your application
CMD ["node", "app.js"]
