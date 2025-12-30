FROM jekyll/jekyll:latest

# Install image optimization tools
RUN apk add --no-cache jpegoptim optipng imagemagick
