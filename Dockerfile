FROM rust:1.63-buster as build

# create a new empty shell project
RUN USER=root cargo new --bin rust-datafusion-kubernetes-job
WORKDIR /rust-datafusion-kubernetes-job

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
RUN rm ./target/release/deps/rust-datafusion-kubernetes-job*
RUN cargo build --release

# our final base
FROM debian:buster-slim

# copy the build artifact from the build stage
COPY --from=build /holodeck/target/release/rust-datafusion-kubernetes-job .
COPY test.csv .

# set the startup command to run your binary
CMD ["./rust-datafusion-kubernetes-job"]