# Start with the official Node.js image on a x86_64 architecture
FROM --platform=linux/amd64 node:20-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json before other files
# Utilize Docker cache to save re-installing dependencies if unchanged
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy all files
COPY . .

# Build the application
RUN npm run build

# Expose the listening port
EXPOSE 80

# Run the application
CMD ["npm", "start", "--", "--port", "80"]
