############################
# STEP 1 build executable binary
############################
FROM golang:alpine as builder
# Install git + SSL ca certificates.
# Git is required for fetching the dependencies.
# Ca-certificates is required to call HTTPS endpoints.
RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates
# Create appuser
ENV USER=appuser
ENV UID=10001
# See https://stackoverflow.com/a/55757473/12429735RUN 
RUN adduser \    
    --disabled-password \    
    --gecos "" \    
    --home "/nonexistent" \    
    --shell "/sbin/nologin" \    
    --no-create-home \    
    --uid "${UID}" \    
    "${USER}" 

WORKDIR $GOPATH/src/outyet/
COPY . .
# Fetch dependencies.
# Using go mod with go 1.11
RUN go mod verify
# RUN go build
# Build the binary
RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o /go/bin/outyet
RUN ls -al /go/bin
###########################
# STEP 2 build a small image
###########################
FROM scratch
# Import from builder.
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
# Copy our static executable
COPY --from=builder /go/bin/outyet /go/bin/outyet

# Use an unprivileged user.
USER appuser:appuser
# Run the outyet binary.
ENTRYPOINT ["/go/bin/outyet"]