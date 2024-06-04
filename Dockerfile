FROM golang:1.22.3-bullseye

# Install basic tools:
RUN apt-get update && apt-get install -y \
    sudo \
    iputils-ping \
    openssh-client \
    gnupg2 \
    curl \
    wget \
    zip \
    unzip \
    git \
    vim \
    jq \
    # Clean apt cache
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user:
# https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
ENV USER=$USERNAME
ENV HOME=/home/$USERNAME
ENV GOPATH=$HOME/go
ENV GOCACHE=$HOME/.cache/go-build
ENV GOMODCACHE=$GOPATH/pkg/mod
ENV SHELL=/bin/bash
ENV HISTFILE=$HOME/.bash_history/.bash_history
ENV WORKDIR=/workspace
WORKDIR $WORKDIR

RUN \
    # Persist bash history
    # https://code.visualstudio.com/remote/advancedcontainers/persist-bash-history
    mkdir -p $(dirname $HISTFILE) \
    && echo "export PROMPT_COMMAND='history -a'" >> $HOME/.bashrc

# Install Go tools
# https://github.com/golang/vscode-go/blob/master/docs/tools.md
# https://github.com/golang/vscode-go/blob/master/extension/tools/allTools.ts.in
RUN \
    # Language Server from Google
    go install golang.org/x/tools/gopls@latest \
    # Go debugger (Delve)
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    # VS Code Go helper program
    && go install github.com/golang/vscode-go/vscgo@latest \
    # godoc
    && go install golang.org/x/tools/cmd/godoc@latest \
    # Generate unit tests
    # VS Code command - Go: Generate Unit Tests
    && go install github.com/cweill/gotests/gotests@latest \
    # Modify tags on structs
    # VS Code command - Go: Add Tags To Struct Fields
    # VS Code command - Go: Remove Tags From Struct Fields
    && go install github.com/fatih/gomodifytags@latest \
    # Stubs for interfaces
    # VS Code command - Go: Generate Interface Stubs
    && go install github.com/josharian/impl@latest \
    # The Go playground
    # VS Code command - Go: Run on Go Playground
    && go install github.com/haya14busa/goplay/cmd/goplay@latest \
    # Linters
    && go install golang.org/x/lint/golint@latest \
    && go install honnef.co/go/tools/cmd/staticcheck@latest \
    && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest \
    && go install github.com/mgechev/revive@latest \
    # Extra tools
    && go install github.com/go-bindata/go-bindata/...@latest \
    && go install github.com/spf13/cobra-cli@latest \
    # Clean up
    && go clean \
    # Create cache directories to avoid permission issues with docker volume
    && mkdir -p $GOCACHE $GOMODCACHE

CMD ["sleep", "infinity"]
