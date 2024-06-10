ARG BASE_IMAGE_TAG
FROM golang:$BASE_IMAGE_TAG

# RUN go install golang.org/x/lint/golint@latest \
#     && go install honnef.co/go/tools/cmd/staticcheck@latest \
#     && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest \

    
#     && go install github.com/mgechev/revive@latest

CMD ["echo", "hello"]
