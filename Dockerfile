# Use busybox as base
FROM busybox:1.36

# Run command as root - this works fine
RUN echo "Running as root - this works"

# Switch to non-root user
USER nobody

# Try to run a command as nobody - this should fail with permission denied
RUN echo "This should fail with permission denied"
RUN ls -la /bin/busybox

