FROM fedorov7/build2 as builder

ARG PACKAGE="odb@https://pkg.cppget.org/1/beta"

RUN mkdir /install \
 && mkdir /build \
 && cd /build \
 && bpkg create config.install.root=/install \
 && bpkg --trust-yes build -y $PACKAGE \
 && bpkg test odb \
 && bpkg install odb \
 && cd - \
 && rm -r /install/share \
 && rm -r /build

FROM gcc:9.3

LABEL maintainer="Alexander Fedorov <fedorov7@gmail.com>"
LABEL name="odb"
LABEL summary="ODB: C++ Object-Relational Mapping (ORM) in Docker"
LABEL version="2.5.0"

# Install buildable executables
COPY --from=builder /install /usr/local
