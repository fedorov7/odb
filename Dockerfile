FROM fedorov7/build2 as builder

RUN mkdir /install
RUN bpkg create -d odb-build config.install.root=/install
RUN cd odb-build
RUN bpkg --trust-yes build -y odb@https://pkg.cppget.org/1/beta
RUN bpkg test odb
RUN bpkg install odb

FROM gcc:9.3

LABEL maintainer="Alexander Fedorov <fedorov7@gmail.com>"
LABEL name="build2"
LABEL summary="Build2 C++ build toolchain in Docker"
LABEL version="0.12.0"

# Install buildable executables
COPY --from=builder /install /usr/local
