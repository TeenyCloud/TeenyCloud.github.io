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

#### Container Lifecycle

All commands use **temporary containers** (`docker-compose run --rm`):
- Every `make` command creates a fresh container that's automatically removed when you exit
- Containers are ephemeral and don't persist after stopping
- No leftover containers cluttering your Docker environment

**What actually persists:**
- **Blog source files**: Stored on your Mac filesystem (bind mount), editable with any editor
- **Ruby gems**: Stored in the `jekyll-vendor` Docker volume for fast reinstalls
- **Generated site**: Written to `_site/` on your Mac (via bind mount)

This means you can safely delete containers without losing any work - all important data persists outside the container.

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

### Image Credits

Posts can include image credits in three different ways, giving you flexibility based on your needs:

#### Option 1: Structured Fields (Recommended)

Use individual metadata fields to automatically generate properly formatted credits:

```yaml
---
image: assets/images/photo.jpg
image-author: Yancy Min
image-author-link: https://unsplash.com/@yancymin
image-site: Unsplash
image-site-link: https://unsplash.com/s/photos/git
image-link: https://unsplash.com/photos/abc123
---
```

**Generates:** "Image by Yancy Min on Unsplash" (with appropriate links)

**Fields:**
- `image-author`: Name of the image creator (optional)
- `image-author-link`: URL to author's profile (optional)
- `image-site`: Name of the source site (optional)
- `image-site-link`: URL to the source site (optional)
- `image-link`: URL to the specific image (optional, makes "Image" clickable)

**Examples:**

```yaml
# Minimal - just author
image-author: Jane Doe
# Generates: "Image by Jane Doe"

# Author and site
image-author: Jane Doe
image-site: Unsplash
# Generates: "Image by Jane Doe on Unsplash"

# Site only
image-site: Pexels
image-site-link: https://pexels.com
# Generates: "Image on Pexels"

# Just image link
image-link: https://example.com/photo
# Generates: "Image" (linked)
```

#### Option 2: AI-Generated Images

For AI-generated images, use:

```yaml
---
image: assets/images/ai-generated.jpg
image-ai: DALL-E 3
---
```

**Generates:** "Image generated with DALL-E 3"

#### Option 3: Custom HTML (Legacy)

For complete control, provide raw HTML:

```yaml
---
image: assets/images/photo.jpg
image-credit: <span>Photo by <a href="...">Author</a> on <a href="...">Site</a></span>
---
```

The HTML will be rendered as-is. This option is useful for complex credits or backward compatibility.

### Troubleshooting

**Gems re-installing on every run?**
The Jekyll image verifies gems on each startup - this should only take a few seconds if gems are cached. Full re-downloads only happen when `Gemfile.lock` changes.

**Need to rebuild the image?**
```bash
make clean
make build
```
