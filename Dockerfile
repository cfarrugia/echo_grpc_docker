FROM ealen/echo-server:latest
EXPOSE 80
RUN cd /bin
RUN apk update
RUN apk add gcc
RUN apk add musl-dev
RUN touch grpc_health_probe.c
RUN printf 'int main(void) {\n' >> grpc_health_probe.c
RUN printf 'return 0;\n' >> grpc_health_probe.c
RUN printf '}\n' >> grpc_health_probe.c
RUN gcc grpc_health_probe.c -o /bin/grpc_health_probe

