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
RUN apt update && apt install -y libssl1.1="1.1.1f-1ubuntu2"

USER json_rpc_snoop

WORKDIR /home/json_rpc_snoop/bin/

COPY --from=cargo-build /usr/src/target/release/json_rpc_snoop .

RUN chown json_rpc_snoop:json_rpc_snoop /home/json_rpc_snoop/bin/

ENTRYPOINT [""]
