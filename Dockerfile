# Use a lightweight web server image as the base
FROM nginx:stable-alpine

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy the website files into the Nginx web server's root directory
COPY . /usr/share/nginx/html

# Expose port 80, which Nginx listens on by default
EXPOSE 80

# Nginx will start automatically when the container runs,
# as it's the default command in the base image.
