# ------------------------------------------------------------------------------
# Build Stage
# ------------------------------------------------------------------------------

FROM rust:latest as cargo-build

WORKDIR /usr/src/

COPY Cargo.toml Cargo.toml

RUN mkdir src/

COPY . .

RUN cargo build --release


# ------------------------------------------------------------------------------
# Packacge Stage
# ------------------------------------------------------------------------------

FROM ubuntu:latest

# create user to limit access in container
RUN groupadd -g 1001 json_rpc_snoop && useradd -r -u 1001 -g json_rpc_snoop json_rpc_snoop
RUN apt update && apt install -y libssl3

USER json_rpc_snoop

WORKDIR /home/json_rpc_snoop/bin/

COPY --from=cargo-build /usr/src/target/release/json_rpc_snoop .
COPY ./dual_snoopers.sh .
COPY ./version.txt /

RUN chown json_rpc_snoop:json_rpc_snoop /home/json_rpc_snoop/bin/

USER root

RUN mkdir -p /opt/besu/bin

COPY ./besu_faker.sh /opt/besu/bin/besu.sh

USER json_rpc_snoop

CMD ./dual_snoopers.sh
