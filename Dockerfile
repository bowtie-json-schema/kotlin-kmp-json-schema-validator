FROM --platform=$BUILDPLATFORM gradle:8.14.2-jdk17 AS builder
WORKDIR /opt/app
COPY gradle/libs.versions.toml gradle/
COPY settings.gradle.kts .
COPY build.gradle.kts .
RUN gradle --no-daemon --parallel dependencies > /dev/null
COPY src/ src/
RUN gradle --no-daemon --parallel install

FROM bellsoft/liberica-openjdk-alpine:24
COPY --from=builder /opt/app/build /opt/app/build
CMD ["/opt/app/build/install/kmp-json-schema-validator/bin/kmp-json-schema-validator"]
