# The base image is expected to contain /bin/opm (with a serve subcommand) and /bin/grpc_health_probe
FROM quay.io/openshift/origin-operator-registry:4.16

ENTRYPOINT ["/bin/opm"]
CMD ["serve", "/configs", "--cache-dir=/tmp/cache","--termination-log=/tmp/termination.log"]

COPY cluster-logging/configs/cluster-logging /configs/cluster-logging/
COPY loki-operator/configs/loki-operator /configs/loki-operator

RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only","--termination-log=/tmp/termination.log"]