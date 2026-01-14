# Stage 1: Create a simple script
FROM busybox:1.36 AS builder
RUN echo '#!/bin/sh' > /myapp && \
    echo 'echo "$@"' >> /myapp && \
    chmod +x /myapp

# Stage 2: Copy the script and try to execute it as non-root
FROM busybox:1.36

# Copy the script from builder stage
COPY --from=builder /myapp /usr/local/bin/myapp

# This works - running as root
RUN /usr/local/bin/myapp "Running as root works"

# Switch to non-root user
USER nobody

# This should fail with permission denied because the copied script
# doesn't have execute permissions for the nobody user in kaniko
RUN /usr/local/bin/myapp "This should fail with permission denied"

