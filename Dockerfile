FROM rust:1.63-buster as build

COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
COPY ./src ./src

RUN cargo build --release

# our final base
FROM debian:buster

COPY --from=build /target/release/rust-datafusion-kubernetes-job .
COPY data data

CMD ["./rust-datafusion-kubernetes-job"]
