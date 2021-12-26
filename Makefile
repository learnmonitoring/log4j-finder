# Makefile template originated from https://github.com/learnmonitoring/scan4log4shell/blob/main/Makefile
PROJECTNAME=$(shell basename "$(PWD)")


# Make is verbose in Linux. Make it silent.
MAKEFLAGS += --silent

.PHONY: help
## help: Prints this help message
help: Makefile
	@echo
	@echo " Choose a command run in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


.PHONY: clean
## clean: cleanup build 
clean:
	@rm -f *~
	@rm -rf dist __pycache__ build
	@rm -rf /tmp/*log4j*

.PHONY: setup
## setup: Setup  dependencies
setup:
	@pip3 install --user vermin

.PHONY: test
## test: show help and scan /tmp 
test:  build
	@./dist/log4j-finder --help
	@./dist/log4j-finder -b /tmp

.PHONY: vermin
## vermin: show minimum version of Python
vermin: 
	@vermin -vv log4j-finder.py

.PHONY: build
## build: Use pyinstaller to bulid binary log4j-finder in dist
build: 
	@pyinstaller --onefile log4j-finder.spec

.PHONY: pull
## pull: run git pull 
pull:
	@git pull

.PHONY: get-jar
## get-jar: wget a few jar files into /tmp for scanning tests
archive=archive.apache.org/dist/logging/log4j
dlcdn=dlcdn.apache.org/logging/log4j/2.17.0
get-jar:
	@wget https://$(dlcdn)/apache-log4j-2.17.0-bin.tar.gz -O /tmp/apache-log4j-2.17.0-bin.tar.gz
	@(cd /tmp && tar xzf apache-log4j-2.17.0-bin.tar.gz)
	@wget https://$(archive)/2.9.1/apache-log4j-2.9.1-bin.tar.gz -O /tmp/apache-log4j-2.9.1-bin.tar.gz
	@(cd /tmp && tar xzf apache-log4j-2.9.1-bin.tar.gz)
	@wget https://$(archive)/1.0.4/jakarta-log4j-1.0.4.tar.gz -O /tmp/jakarta-log4j-1.0.4.tar.gz
	@(cd /tmp && tar xzf jakarta-log4j-1.0.4.tar.gz)


.PHONY: c7setup
## c7setup: CentOS 7 need SCL devtoolset-7+
c7setup:
	@sudo yum install -y centos-release-scl
	@sudo yum-config-manager --enable rhel-server-rhscl-7-rpms
	@sudo yum install -y devtoolset-7
	@scl enable devtoolset-7 bash
