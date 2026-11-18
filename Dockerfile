# Build the CSS with the standalone Tailwind CLI (no Node.js needed).
FROM alpine:3 AS build
ARG TAILWIND_VERSION=4.3.3
ARG TARGETARCH
WORKDIR /site
RUN case "$TARGETARCH" in arm64) arch=arm64 ;; *) arch=x64 ;; esac \
	&& wget -qO /usr/local/bin/tailwindcss \
		"https://github.com/tailwindlabs/tailwindcss/releases/download/v${TAILWIND_VERSION}/tailwindcss-linux-${arch}-musl" \
	&& chmod +x /usr/local/bin/tailwindcss
COPY src/ .
RUN tailwindcss -i input.css -o styles.css --minify && rm input.css

# Serve the static files.
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /site/ /usr/share/nginx/html/
