FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git -b stable /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"

RUN flutter doctor
RUN flutter precache

WORKDIR /app

# Build arguments
ARG API_BASE_URL=http://184.174.39.92:8081/v1
ARG BUILD_VARIANT=yocombi-prod

# Create API configuration
RUN mkdir -p lib/config
RUN echo "const String apiBaseUrl = '${API_BASE_URL}';" > lib/config/api_config.dart

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# Build Flutter web app for production
RUN flutter build web --release \
    --dart-define=API_BASE_URL=${API_BASE_URL} \
    --dart-define=BUILD_VARIANT=${BUILD_VARIANT} \
    -t lib/main.dart

FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html
COPY docker/nginx/yocombi.conf /etc/nginx/conf.d/default.conf

EXPOSE 80