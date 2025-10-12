# ------------------------------------------------------------
# Stage 1 – Build the Flutter web app (official Flutter image)
# ------------------------------------------------------------
FROM cirrusci/flutter:stable AS builder

# ------------------------------------------------------------
# 1️⃣ Create a non‑root user (UID 1000) – avoids “running as root”
# ------------------------------------------------------------
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=flutter

RUN addgroup --gid $GROUP_ID $USER_NAME && \
    adduser --uid $USER_ID --gid $GROUP_ID --disabled-password --gecos "" $USER_NAME

# ----------------------------------------------------------------
# 2️⃣ Make the SDK owned by the same user that will run Flutter
# ----------------------------------------------------------------
#ENV FLUTTER_ROOT=/opt/flutter
#RUN chown -R $USER_NAME:$USER_NAME $FLUTTER_ROOT

# ----------------------------------------------------------------
# 3️⃣ Tell Git the SDK directory is safe (pre‑empt the “dubious ownership” warning)
# ----------------------------------------------------------------
RUN git config --system --add safe.directory $FLUTTER_ROOT

# ----------------------------------------------------------------
# 4️⃣ Switch to the non‑root user for the rest of the build
# ----------------------------------------------------------------
USER $USER_NAME
WORKDIR /app

# ----------------------------------------------------------------
# 5️⃣ Cache pub dependencies (copy only pubspec files first)
# ----------------------------------------------------------------
COPY --chown=$USER_NAME:$USER_NAME pubspec.yaml pubspec.lock ./
RUN flutter pub get

# ----------------------------------------------------------------
# 6️⃣ Copy the rest of the source and build the web release
# ----------------------------------------------------------------
COPY --chown=$USER_NAME:$USER_NAME . .
RUN flutter build web --release --web-renderer html

# ------------------------------------------------------------
# Stage 2 – Serve the compiled web files with Caddy (tiny HTTPS server)
# ------------------------------------------------------------
FROM caddy:2-alpine AS runtime
COPY --from=builder /app/build/web /srv

EXPOSE 80 443
HEALTHCHECK --interval=30s --timeout=5s CMD wget -qO- http://localhost/ || exit 1