# Stage 1: Get a binary to copy
FROM busybox:1.36 AS builder
RUN cp /bin/echo /myapp

# Stage 2: Copy the binary and try to execute it as non-root
FROM busybox:1.36

# Copy the binary from builder stage
COPY --from=builder /myapp /usr/local/bin/myapp

# This works - running as root
RUN /usr/local/bin/myapp "Running as root works"

# Switch to non-root user
USER nobody

# This should fail with permission denied because the copied binary
# doesn't have execute permissions for the nobody user
RUN /usr/local/bin/myapp "This should fail with permission denied"

