# Stage 1: Create a script with restricted permissions
FROM busybox:1.36 AS builder
RUN echo '#!/bin/sh' > /myapp && \
    echo 'echo "$@"' >> /myapp && \
    chmod 700 /myapp
# chmod 700 = rwx------ (only owner can execute)

# Stage 2: Copy the script and try to execute it as non-root
FROM busybox:1.36

# Copy the script from builder stage (owned by root, only root can execute)
COPY --from=builder /myapp /usr/local/bin/myapp

# This works - running as root
RUN /usr/local/bin/myapp "Running as root works"

# Switch to non-root user
USER nobody

# This should fail with permission denied because myapp has chmod 700
# (only owner/root can execute, nobody cannot)
RUN /usr/local/bin/myapp "This should fail with permission denied"

