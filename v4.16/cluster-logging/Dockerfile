# The base image is expected to contain /bin/opm (with a serve subcommand) and /bin/grpc_health_probe
FROM quay.io/openshift/origin-operator-registry:4.20

ENTRYPOINT ["/bin/opm"]
CMD ["serve", "/configs", "--cache-dir=/tmp/cache"]

COPY configs/cluster-logging /configs/cluster-logging/

RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

# Core bundle labels.

LABEL operators.operatorframework.io.bundle.mediatype.v1=registry+v1
LABEL operators.operatorframework.io.bundle.manifests.v1=manifests/
LABEL operators.operatorframework.io.bundle.metadata.v1=metadata/
LABEL operators.operatorframework.io.bundle.package.v1=cluster-logging
LABEL operators.operatorframework.io.bundle.channels.v1=stable-6.0
LABEL operators.operatorframework.io.metrics.builder=operator-sdk-v1.29.0
LABEL operators.operatorframework.io.metrics.mediatype.v1=metrics+v1
LABEL operators.operatorframework.io.metrics.project_layout=go.kubebuilder.io/v3
LABEL operators.operatorframework.io.index.configs.v1=/configs
