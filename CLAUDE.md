# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Jekyll-based personal blog that runs entirely in Docker containers. The site uses a custom theme based on Mundana with Jekyll Collections for author management and includes image optimization tooling.

## Development Commands

All development happens inside Docker containers - no local Ruby/Jekyll installation required.

### Initial Setup
```bash
make build    # Build Docker image (first time only)
make serve    # Start development server at http://localhost:4000
```

### Common Commands
```bash
make serve             # Serve site with live reload
make serve-drafts      # Serve site including _drafts/ posts
make imgmin            # Optimize JPG/PNG images
make png2jpg           # Convert PNGs to JPG (max 200KB) and delete originals
make update            # Update gem dependencies
make shell             # Open shell in container for debugging
make clean             # Remove containers and volumes
```

### Important Notes
- All commands use temporary containers (`docker-compose run --rm`) that auto-remove on exit
- Ruby gems persist in `jekyll-vendor` Docker volume for fast reinstalls
- Generated site outputs to `_site/` directory
- LiveReload runs on port 35729

## Site Architecture

### Content Structure

**Posts** (`_posts/`)
- Filename format: `YYYY-MM-DD-title.md`
- Front matter defaults: `layout: post`, `author: polo`
- Permalink format: `/blog/YEAR/MONTH/DAY/title`
- Support single or multiple authors via `author` field (slug or array of slugs)

**Drafts** (`_drafts/`)
- Same format as posts but without date in filename
- Only visible when using `make serve-drafts`

**Authors** (`_authors/`)
- Jekyll Collection that auto-generates author pages
- Each `.md` file creates page at `/author-{slug}.html`
- Required fields: `name`, `slug`, `avatar`, `bio`
- Optional fields: `website`, `linkedin`, `github`, `bluesky`, `twitter` (or `x`)
- Reference in posts via `author: slug` or `author: [slug1, slug2]`

**Pages** (`_pages/`)
- Static pages like privacy policy, credits, categories, tags, authors list
- Included in build via `include: ["_pages"]` in config

### Layouts & Templates

**Layouts** (`_layouts/`)
- `default.html` - Base template
- `post.html` - Blog post template with author box, image credits, share buttons
- `author.html` - Author profile page with posts list
- `page.html`, `page-sidebar.html`, `page-mundana.html` - Page variants

**Includes** (`_includes/`)
- Reusable components like cards, sidebar, search, menus
- `meta-read-time.html` - Calculates reading time
- `main-loop-card.html` - Post card component

### Image Credit System

Posts support three ways to credit images via front matter:

1. **Structured fields** (recommended):
```yaml
image-author: Name
image-author-link: https://...
image-site: Unsplash
image-site-link: https://...
image-link: https://...
```

2. **AI-generated**:
```yaml
image-ai: DALL-E 3
```

3. **Custom HTML** (legacy):
```yaml
image-credit: <span>Photo by <a href="...">...</a></span>
```

Template logic in `_layouts/post.html:97-105` renders these credits.

### Configuration

**_config.yml**
- Site metadata, plugins, collections, defaults
- Timezone: `Europe/Paris`
- Pagination: 10 posts per page
- Markdown: kramdown with rouge syntax highlighting
- FontAwesome version: 7.1.0

**Dockerfile**
- Based on `jekyll/jekyll:latest`
- Includes image optimization tools: jpegoptim, optipng, imagemagick

**docker-compose.yml**
- Platform: `linux/arm64`
- Jekyll environment: development
- Volume mounts: project root + gems volume
- Removed `--incremental` flag (caused missing page updates for metadata changes)

## Working with the Codebase

### Adding a New Post

1. Create file in `_posts/` with format `YYYY-MM-DD-title.md`
2. Add front matter:
```yaml
---
title: "Post Title"
description: "Description for SEO"
category: CategoryName
tags: [tag1, tag2, featured]
image: assets/images/image.jpg
author: polo  # or [polo, jane] for multiple authors
# Optional image credits - see Image Credit System above
---
```
3. Write content in Markdown
4. Test with `make serve` or `make serve-drafts` (if in `_drafts/`)

### Adding a New Author

1. Create `_authors/newauthor.md`
2. Add required front matter:
```yaml
---
name: Full Name
slug: shortname
avatar: assets/images/avatar.jpg
bio: "Author bio"
# Optional social links
website: https://...
linkedin: https://...
github: https://...
bluesky: https://...
twitter: https://...
---
```
3. Jekyll auto-generates page at `/author-shortname.html`
4. Reference in posts with `author: shortname`

### Image Optimization Workflow

When adding images to `assets/images/`:

1. Add images (PNG or JPG)
2. Run `make png2jpg` to convert PNGs → JPG (targets <200KB)
3. Run `make imgmin` to optimize all images
4. Commit optimized images

### Container Architecture

- **Ephemeral containers**: Each `make` command creates fresh container, auto-removed on exit
- **Persistent data**:
  - Source files: Mac filesystem (bind mount)
  - Ruby gems: `jekyll-vendor` Docker volume
  - Built site: `_site/` on Mac filesystem
- Can safely delete containers without losing work

### Jekyll Build Behavior

- Full rebuilds on every change (not incremental) to ensure metadata changes propagate
- Index pages, category pages, and author pages depend on post metadata
- Incremental builds previously caused stale pages
