# ---- build stage (ant) ----
FROM openjdk:8-jdk AS builder

# Install ant
RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy source and build.xml
COPY . /app

# Optional: if build.xml produces AndKasir.jar via "ant jar" (adjust target if different)
RUN ant -f build.xml jar || (ant -f build.xml && true)

# Try to find the generated jar (fallback to AndKasir.jar)
RUN ls -la || true

# ---- runtime stage ----
FROM openjdk:8-jre-slim

LABEL maintainer="yasminnaila"

WORKDIR /opt/andkasir

# copy jar from builder (adjust jar filename if different)
COPY --from=builder /app/AndKasir.jar ./AndKasir.jar
# if build puts jar in dist/ or build/, copy accordingly:
# COPY --from=builder /app/dist/AndKasir.jar ./AndKasir.jar

# Copy config (so user can override config.properties via docker-compose volume)
COPY config.properties ./config.properties

# Expose nothing by default (app is CLI/DB-migration). If your app listens on a port, expose it:
# EXPOSE 8080

# Default command: run jar (adjust args if needed)
CMD ["java", "-jar", "AndKasir.jar"]
