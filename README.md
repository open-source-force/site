# OSF-Site

The Open Source Force website: static HTML styled with [Tailwind CSS](https://tailwindcss.com/), served by nginx.

- `src/`: the site. `index.html` is the home page, `projects/index.html` is the projects page, and `input.css` is the Tailwind input.
- `nginx.conf`: the server config, including the `/discord` redirect.
- `Dockerfile`: builds the CSS with the standalone Tailwind CLI, then serves `src/` with nginx on port 3000.

The header is copied into both pages, so change it in both places.

## Local development

Download the [standalone Tailwind CLI](https://github.com/tailwindlabs/tailwindcss/releases/tag/v4.3.3) for your platform, then rebuild the CSS on every change:

```bash
tailwindcss -i src/input.css -o src/styles.css --watch
```

In another terminal, serve `src/` with any static file server, for example:

```bash
npx serve src
# or
python -m http.server -d src
```

To run the production image:

```bash
docker build -t osf-site . && docker run --rm -p 3000:3000 osf-site
```

## Deployment

Every push to `main` builds the image and pushes it to `ghcr.io/open-source-force/osf-site`. Watchtower on the server pulls the new image (see `docker-compose.yaml`).
