TeenyCloud.github.io
====================

My personal website data

## Development Setup

This blog uses Jekyll and runs entirely in Docker containers - no need to install Ruby, Jekyll, or any dependencies on your Mac.

### Prerequisites

- Docker Desktop for Mac

### First Time Setup

1. **Build the Docker image** (includes Jekyll + image optimization tools):
   ```bash
   make build
   ```

2. **Start the development server**:
   ```bash
   make serve
   ```

   The first run will automatically install gem dependencies. Your site will be available at `http://localhost:4000` with live reload enabled.

### Daily Development

**Start the server:**
```bash
make serve
```

**Serve with drafts:**
```bash
make serve-drafts
```

**Optimize images:**
```bash
make imgmin
```

**Access container shell (for debugging):**
```bash
make shell
```

**Update gem dependencies:**
```bash
make update
```

**Clean up containers and volumes:**
```bash
make clean
```

### How It Works

- **Docker Volume**: All Ruby gems are stored in a Docker volume (`jekyll-vendor`), completely isolated from your Mac filesystem
- **Live Reload**: The server automatically refreshes your browser when you make changes
- **Automatic Install**: The Jekyll image automatically runs `bundle install` on startup, using cached gems for fast subsequent runs
- **Zero Local Dependencies**: You only need Docker - all Jekyll dependencies stay inside the container

### Troubleshooting

**Gems re-installing on every run?**
The Jekyll image verifies gems on each startup - this should only take a few seconds if gems are cached. Full re-downloads only happen when `Gemfile.lock` changes.

**Need to rebuild the image?**
```bash
make clean
make build
```
