
APP_VERSION ?= "default"

BASE_DIR    := $(shell pwd)
APP_DIR      = ./app/
SRC_DIR      = $(BASE_DIR)/src
BIN_DIR      = ./bin

APP_FILES    = $(shell find $(APP_DIR) -type f)
DEP_DIRS 	   = $(shell [ -d $(SRC_DIR) ] && find $(SRC_DIR) -type d)
DEP_FILES    = $(shell [ -d $(SRC_DIR) ] && find $(SRC_DIR) -type f -name '*')

DEPS         = $(SRC_DIR) $(DEP_DIRS) $(DEP_FILES)

error:
	@echo "Please choose one of the following targets: build-linux, build-mac, update, clean"
	@exit 0

deploy: deploy${version}

deploy$(version): $(BIN_DIR)/gotrygo${version}
	@docker build --build-arg EXECUTABLE=${BIN_DIR}/gotrygo${version} -t bryangwilliam/gotrygo:${version} .

build-linux: $(BIN_DIR)/gotrygo

build-mac: $(BIN_DIR)/gotrygo-darwin

update: clean-src $(SRC_DIR)

$(SRC_DIR):
	@echo "Installing dependencies"
	@GOPATH=$(BASE_DIR) go get -d $(APP_DIR)

$(BIN_DIR)/gotrygo${version}: $(DEPS) $(APP_FILES)
	@echo "Building linux executable"
	@GOPATH=$(BASE_DIR) CGO_ENABLED=0 GOOS=linux go build -a -ldflags "-X main.appVersion=${version}" -o $(BIN_DIR)/gotrygo${version} $(APP_DIR)

$(BIN_DIR)/gotrygo-darwin: $(DEPS) $(APP_FILES)
	@echo "Building macos executable"
	@GOPATH=$(BASE_DIR) CGO_ENABLED=0 GOOS=darwin go build -a -ldflags "-X main.appVersion=${version}" -o $(BIN_DIR)/gotrygo-darwin $(APP_DIR)

clean-src:
	@echo "Cleaning up $(SRC_DIR)"
	@rm -rf $(SRC_DIR)

clean: clean-src
	@echo "Cleaning up $(BIN_DIR)"
	@rm -rf $(BIN_DIR)
	@echo "Cleaning up go files"
	@GOPATH=$(BASE_DIR) go clean
