# Simple static site image using nginx (small and production-ready)
FROM nginx:1.25-alpine
# Remove default content and add ours
RUN rm -rf /usr/share/nginx/html/*
COPY index.html /usr/share/nginx/html/index.html
# Expose standard HTTP port
EXPOSE 80
# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]