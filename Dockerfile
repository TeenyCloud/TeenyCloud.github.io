FROM jekyll/jekyll:latest

# Install image optimization tools
RUN apt-get update && apt-get install -y --no-install-recommends \
      jpegoptim optipng imagemagick \
    && rm -rf /var/lib/apt/lists/*
