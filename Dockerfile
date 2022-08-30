FROM rust:1.63-buster as build

COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
COPY ./src ./src

RUN cargo build --release

# our final base
FROM debian:buster-slim

# copy the build artifact from the build stage
COPY --from=build /target/release/rust-datafusion-kubernetes-job .
COPY data data

# set the startup command to run your binary
CMD ["./rust-datafusion-kubernetes-job"]
