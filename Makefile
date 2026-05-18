.PHONY: build clean test test-coverage fmt

COVERDIR ?= $(CURDIR)/.coverdata

build:
	go build -o oci-delta ./cmd/oci-delta

clean:
	rm -f oci-delta
	rm -rf $(COVERDIR)

test: build
	go test ./...
	python3 tests/test-synthetic.py
	tests/integration-test.sh

test-coverage:
	go build -cover -o oci-delta ./cmd/oci-delta
	rm -rf $(COVERDIR) && mkdir -p $(COVERDIR)/unit $(COVERDIR)/integration
	go test -cover ./... -args -test.gocoverdir=$(COVERDIR)/unit
	GOCOVERDIR=$(COVERDIR)/integration python3 tests/test-synthetic.py
	GOCOVERDIR=$(COVERDIR)/integration tests/integration-test.sh
	go tool covdata percent -i $(COVERDIR)/unit,$(COVERDIR)/integration

fmt:
	go fmt ./...

install:
	go install ./cmd/oci-delta
