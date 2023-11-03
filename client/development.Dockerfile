# build stage
FROM node:20.9.0-alpine as build-stage

# Sets the path where the app is going to be installed
ENV VITE_ROOT /var/www/

# Creates the directory and all the parents (if they don't exist)
RUN mkdir -p $VITE_ROOT

# This is given by the Ruby Image.
# This will be the de-facto directory that 
# all the contents are going to be stored. 
WORKDIR $VITE_ROOT

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev", "--", "--host", "--port", "3000"]
