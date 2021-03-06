FROM fedorov7/build2 as builder

ARG PACKAGE="https://pkg.cppget.org/1/beta"

RUN apk add --no-cache gmp-dev

RUN mkdir /install \
 && mkdir /build \
 && cd /build \
 && bpkg create config.install.root=/install \
 && bpkg add $PACKAGE \
 && bpkg fetch --trust-yes \
 && bpkg build -y odb \
 && bpkg build -y libodb \
 && bpkg build -y libodb-pgsql \
 && bpkg install --all --recursive \
 && cd - \
 && rm -r /install/share \
 && rm -r /build

FROM fedorov7/gcc

LABEL maintainer="Alexander Fedorov <fedorov7@gmail.com>"
LABEL name="odb"
LABEL summary="ODB: C++ Object-Relational Mapping (ORM) in Docker"
LABEL version="2.5.0"

# Install buildable executables
COPY --from=builder /install /usr
