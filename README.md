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

## Blog Structure

### Adding Authors

This blog uses Jekyll Collections to automatically generate author pages. Adding a new author is simple and requires no manual page creation.

#### How to Add a New Author

1. **Create an author file** in the `_authors/` directory:
   ```bash
   touch _authors/jane.md
   ```

2. **Add the author details** with frontmatter:
   ```yaml
   ---
   name: Jane Doe
   slug: jane
   website: https://janedoe.com
   avatar: assets/images/jane-avatar.png
   bio: "Jane's bio here. Keep it concise and informative."
   ---
   ```

3. **That's it!** Jekyll will automatically:
   - Generate an author page at `/author-jane.html`
   - Include the author in the authors list page
   - Link all posts with `author: jane` to this author page

#### Author File Fields

- **name**: Display name of the author (required)
- **slug**: URL-friendly identifier used in permalinks and post references (required)
- **website**: Author's website URL (optional)
- **avatar**: Path to author's avatar image relative to site root (required)
- **bio**: Short biography text (required)

#### How It Works

- **Collection**: `_authors/` directory is configured as a Jekyll collection
- **Auto-generation**: Each `.md` file in `_authors/` becomes a page at `/author-{slug}.html`
- **Layout**: All author pages use the `_layouts/author.html` template
- **Post linking**: Posts reference authors using the `slug` field (e.g., `author: jane`)
- **GitHub Pages compatible**: Uses standard Jekyll collections, no custom plugins required

#### Example Directory Structure

```
_authors/
  polo.md          # Creates /author-polo.html
  jane.md          # Creates /author-jane.html

_layouts/
  author.html      # Template for all author pages

_posts/
  2023-01-01-my-post.md
    ---
    author: polo   # References polo.md by slug
    ---
```

### Troubleshooting

**Gems re-installing on every run?**
The Jekyll image verifies gems on each startup - this should only take a few seconds if gems are cached. Full re-downloads only happen when `Gemfile.lock` changes.

**Need to rebuild the image?**
```bash
make clean
make build
```
