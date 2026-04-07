SHELL := /bin/bash
SCRIPT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CACHE_DIR := $(SCRIPT_DIR).cache
DOCKERFILE := Dockerfile.cft

define DOWNLOAD_IF_MISSING
	@if [ -f "$(1)" ]; then \
		echo "File '$(1)' already exists. Skipping."; \
	else \
		echo "Downloading $(2) -> $(1)"; \
		curl -sSL -o "$(1)" "$(2)"; \
	fi
endef

define DOCKER_BUILD
	@echo ">>> Using $(DOCKERFILE)..."
	@docker build \
		-f "$(DOCKERFILE)" \
		--build-arg CHROME_URL="$(CHROME_URL)" \
		--build-arg CHROME_DRIVER_URL="$(CHROME_DRIVER_URL)" \
		--build-arg CHROME_CACHE_PATH=".cache/$(notdir $(CACHE_DIR)/$(CHROME_VERSION)-chrome)" \
		--build-arg CHROME_DRIVER_CACHE_PATH=".cache/$(notdir $(CACHE_DIR)/$(CHROME_DRIVER_VERSION)-chromedriver)" \
		--build-arg CHROME_MAJOR_VERSION="$(firstword $(subst ., ,$(CHROME_VERSION)))" \
		--build-arg CHROME_VERSION="$(CHROME_VERSION)" \
		--build-arg CHROME_DRIVER_MAJOR_VERSION="$(firstword $(subst ., ,$(CHROME_DRIVER_VERSION)))" \
		--build-arg CHROME_DRIVER_VERSION="$(CHROME_DRIVER_VERSION)" \
		-t "chrome:$*" \
		--progress=plain \
		.
	@echo ">>> Built: chrome:$*"
endef

.PHONY: help clean build-% chrome-% test-%

## ── Target-Specific Variables ─────────────────────────

# Chrome 48
build-48: DOCKERFILE := Dockerfile.slimjet
build-48: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_48.0.2564.109.deb
build-48: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.21/chromedriver_linux64.zip
build-48: CHROME_VERSION := 48.0.2564.109
build-48: CHROME_DRIVER_VERSION := 2.21

# Chrome 49
build-49: DOCKERFILE := Dockerfile.slimjet
build-49: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_49.0.2623.75.deb
build-49: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.22/chromedriver_linux64.zip
build-49: CHROME_VERSION := 49.0.2623.75
build-49: CHROME_DRIVER_VERSION := 2.22

# Chrome 50
build-50: DOCKERFILE := Dockerfile.slimjet
build-50: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_50.0.2661.75.deb
build-50: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.22/chromedriver_linux64.zip
build-50: CHROME_VERSION := 50.0.2661.75
build-50: CHROME_DRIVER_VERSION := 2.22

# Chrome 51
build-51: DOCKERFILE := Dockerfile.slimjet
build-51: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_51.0.2704.84.deb
build-51: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.23/chromedriver_linux64.zip
build-51: CHROME_VERSION := 51.0.2704.84
build-51: CHROME_DRIVER_VERSION := 2.23

# Chrome 52
build-52: DOCKERFILE := Dockerfile.slimjet
build-52: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_52.0.2743.116.deb
build-52: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.23/chromedriver_linux64.zip
build-52: CHROME_VERSION := 52.0.2743.116
build-52: CHROME_DRIVER_VERSION := 2.23

# Chrome 53
build-53: DOCKERFILE := Dockerfile.slimjet
build-53: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_53.0.2785.116.deb
build-53: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.26/chromedriver_linux64.zip
build-53: CHROME_VERSION := 53.0.2785.116
build-53: CHROME_DRIVER_VERSION := 2.26

# Chrome 54
build-54: DOCKERFILE := Dockerfile.slimjet
build-54: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_54.0.2840.71.deb
build-54: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.27/chromedriver_linux64.zip
build-54: CHROME_VERSION := 54.0.2840.71
build-54: CHROME_DRIVER_VERSION := 2.27

# Chrome 55
build-55: DOCKERFILE := Dockerfile.slimjet
build-55: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_55.0.2883.75.deb
build-55: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.28/chromedriver_linux64.zip
build-55: CHROME_VERSION := 55.0.2883.75
build-55: CHROME_DRIVER_VERSION := 2.28

# Chrome 56
build-56: DOCKERFILE := Dockerfile.slimjet
build-56: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_56.0.2924.87.deb
build-56: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip
build-56: CHROME_VERSION := 56.0.2924.87
build-56: CHROME_DRIVER_VERSION := 2.29

# Chrome 57
build-57: DOCKERFILE := Dockerfile.slimjet
build-57: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_57.0.2987.133.deb
build-57: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip
build-57: CHROME_VERSION := 57.0.2987.133
build-57: CHROME_DRIVER_VERSION := 2.29

# Chrome 58
build-58: DOCKERFILE := Dockerfile.slimjet
build-58: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_58.0.3029.96.deb
build-58: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip
build-58: CHROME_VERSION := 58.0.3029.96
build-58: CHROME_DRIVER_VERSION := 2.31

# Chrome 59
build-59: DOCKERFILE := Dockerfile.slimjet
build-59: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_59.0.3071.86.deb
build-59: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.32/chromedriver_linux64.zip
build-59: CHROME_VERSION := 59.0.3071.86
build-59: CHROME_DRIVER_VERSION := 2.32

# Chrome 60
build-60: DOCKERFILE := Dockerfile.slimjet
build-60: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_60.0.3112.90.deb
build-60: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.33/chromedriver_linux64.zip
build-60: CHROME_VERSION := 60.0.3112.90
build-60: CHROME_DRIVER_VERSION := 2.33

# Chrome 61
build-61: DOCKERFILE := Dockerfile.slimjet
build-61: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_61.0.3163.79.deb
build-61: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.34/chromedriver_linux64.zip
build-61: CHROME_VERSION := 61.0.3163.79
build-61: CHROME_DRIVER_VERSION := 2.34

# Chrome 62
build-62: DOCKERFILE := Dockerfile.slimjet
build-62: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_62.0.3202.75.deb
build-62: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.35/chromedriver_linux64.zip
build-62: CHROME_VERSION := 62.0.3202.75
build-62: CHROME_DRIVER_VERSION := 2.35

# Chrome 63
build-63: DOCKERFILE := Dockerfile.slimjet
build-63: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_63.0.3239.108.deb
build-63: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.36/chromedriver_linux64.zip
build-63: CHROME_VERSION := 63.0.3239.108
build-63: CHROME_DRIVER_VERSION := 2.36

# Chrome 64
build-64: DOCKERFILE := Dockerfile.slimjet
build-64: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_64.0.3282.140.deb
build-64: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.37/chromedriver_linux64.zip
build-64: CHROME_VERSION := 64.0.3282.140
build-64: CHROME_DRIVER_VERSION := 2.37

# Chrome 65
build-65: DOCKERFILE := Dockerfile.slimjet
build-65: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_65.0.3325.181.deb
build-65: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.38/chromedriver_linux64.zip
build-65: CHROME_VERSION := 65.0.3325.181
build-65: CHROME_DRIVER_VERSION := 2.38

# Chrome 66
build-66: DOCKERFILE := Dockerfile.slimjet
build-66: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_66.0.3359.181.deb
build-66: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.40/chromedriver_linux64.zip
build-66: CHROME_VERSION := 66.0.3359.181
build-66: CHROME_DRIVER_VERSION := 2.40

# Chrome 67
build-67: DOCKERFILE := Dockerfile.slimjet
build-67: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_67.0.3396.79.deb
build-67: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
build-67: CHROME_VERSION := 67.0.3396.79
build-67: CHROME_DRIVER_VERSION := 2.41

# Chrome 68
build-68: DOCKERFILE := Dockerfile.slimjet
build-68: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_68.0.3440.84.deb
build-68: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.42/chromedriver_linux64.zip
build-68: CHROME_VERSION := 68.0.3440.84
build-68: CHROME_DRIVER_VERSION := 2.42

# Chrome 69
build-69: DOCKERFILE := Dockerfile.slimjet
build-69: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F69.0.3497.92%2Fgoogle-build-stable_current_amd64.deb
build-69: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.44/chromedriver_linux64.zip
build-69: CHROME_VERSION := 69.0.3497.92
build-69: CHROME_DRIVER_VERSION := 2.44

# Chrome 70
build-70: DOCKERFILE := Dockerfile.slimjet
build-70: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F70.0.3538.77%2Fgoogle-build-stable_current_amd64.deb
build-70: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip
build-70: CHROME_VERSION := 70.0.3538.77
build-70: CHROME_DRIVER_VERSION := 2.45

# Chrome 71
build-71: DOCKERFILE := Dockerfile.slimjet
build-71: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F71.0.3578.80%2Fgoogle-build-stable_current_amd64.deb
build-71: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip
build-71: CHROME_VERSION := 71.0.3578.80
build-71: CHROME_DRIVER_VERSION := 2.45

# Chrome 75
build-75: DOCKERFILE := Dockerfile.slimjet
build-75: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F75.0.3770.80%2Fgoogle-build-stable_current_amd64.deb
build-75: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/75.0.3770.140/chromedriver_linux64.zip
build-75: CHROME_VERSION := 75.0.3770.80
build-75: CHROME_DRIVER_VERSION := 75.0.3770.140

# Chrome 76
build-76: DOCKERFILE := Dockerfile.slimjet
build-76: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F76.0.3809.100%2Fgoogle-build-stable_current_amd64.deb
build-76: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/76.0.3809.126/chromedriver_linux64.zip
build-76: CHROME_VERSION := 76.0.3809.100
build-76: CHROME_DRIVER_VERSION := 76.0.3809.126

# Chrome 78
build-78: DOCKERFILE := Dockerfile.slimjet
build-78: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F78.0.3904.97%2Fgoogle-build-stable_current_amd64.deb
build-78: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/78.0.3904.105/chromedriver_linux64.zip
build-78: CHROME_VERSION := 78.0.3904.97
build-78: CHROME_DRIVER_VERSION := 78.0.3904.105

# Chrome 79
build-79: DOCKERFILE := Dockerfile.slimjet
build-79: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F79.0.3945.88%2Fgoogle-build-stable_current_amd64.deb
build-79: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_linux64.zip
build-79: CHROME_VERSION := 79.0.3945.88
build-79: CHROME_DRIVER_VERSION := 79.0.3945.36

# Chrome 80
build-80: DOCKERFILE := Dockerfile.slimjet
build-80: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F80.0.3987.149%2Fgoogle-build-stable_current_amd64.deb
build-80: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_linux64.zip
build-80: CHROME_VERSION := 80.0.3987.149
build-80: CHROME_DRIVER_VERSION := 80.0.3987.106

# Chrome 81
build-81: DOCKERFILE := Dockerfile.slimjet
build-81: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F81.0.4044.92%2Fgoogle-build-stable_current_amd64.deb
build-81: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/81.0.4044.138/chromedriver_linux64.zip
build-81: CHROME_VERSION := 81.0.4044.92
build-81: CHROME_DRIVER_VERSION := 81.0.4044.138

# Chrome 83
build-83: DOCKERFILE := Dockerfile.slimjet
build-83: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F83.0.4103.116%2Fgoogle-build-stable_current_amd64.deb
build-83: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/83.0.4103.39/chromedriver_linux64.zip
build-83: CHROME_VERSION := 83.0.4103.116
build-83: CHROME_DRIVER_VERSION := 83.0.4103.39

# Chrome 84
build-84: DOCKERFILE := Dockerfile.slimjet
build-84: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F84.0.4147.135%2Fgoogle-build-stable_current_amd64.deb
build-84: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/84.0.4147.30/chromedriver_linux64.zip
build-84: CHROME_VERSION := 84.0.4147.135
build-84: CHROME_DRIVER_VERSION := 84.0.4147.30

# Chrome 86
build-86: DOCKERFILE := Dockerfile.slimjet
build-86: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F86.0.4240.75%2Fgoogle-build-stable_current_amd64.deb
build-86: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/86.0.4240.22/chromedriver_linux64.zip
build-86: CHROME_VERSION := 86.0.4240.75
build-86: CHROME_DRIVER_VERSION := 86.0.4240.22

# Chrome 90
build-90: DOCKERFILE := Dockerfile.slimjet
build-90: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F90.0.4430.72%2Fgoogle-build-stable_current_amd64.deb
build-90: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/90.0.4430.24/chromedriver_linux64.zip
build-90: CHROME_VERSION := 90.0.4430.72
build-90: CHROME_DRIVER_VERSION := 90.0.4430.24

# Chrome 102
build-102: DOCKERFILE := Dockerfile.slimjet
build-102: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F102.0.5005.63%2Fgoogle-build-stable_current_amd64.deb
build-102: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/102.0.5005.61/chromedriver_linux64.zip
build-102: CHROME_VERSION := 102.0.5005.63
build-102: CHROME_DRIVER_VERSION := 102.0.5005.61

# Chrome 103
build-103: DOCKERFILE := Dockerfile.slimjet
build-103: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F103.0.5060.53%2Fgoogle-build-stable_current_amd64.deb
build-103: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/103.0.5060.134/chromedriver_linux64.zip
build-103: CHROME_VERSION := 103.0.5060.53
build-103: CHROME_DRIVER_VERSION := 103.0.5060.134

# Chrome 104
build-104: DOCKERFILE := Dockerfile.slimjet
build-104: CHROME_URL := https://www.slimjet.com/chrome/download-chrome.php?file=files%2F104.0.5112.102%2Fgoogle-build-stable_current_amd64.deb
build-104: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/104.0.5112.79/chromedriver_linux64.zip
build-104: CHROME_VERSION := 104.0.5112.102
build-104: CHROME_DRIVER_VERSION := 104.0.5112.79

# Chrome 113
build-113: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/113.0.5672.63/linux64/build-linux64.zip
build-113: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/113.0.5672.63/chromedriver_linux64.zip
build-113: CHROME_VERSION := 113.0.5672.63
build-113: CHROME_DRIVER_VERSION := 113.0.5672.63

# Chrome 114
build-114: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/114.0.5735.133/linux64/build-linux64.zip
build-114: CHROME_DRIVER_URL := https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip
build-114: CHROME_VERSION := 114.0.5735.133
build-114: CHROME_DRIVER_VERSION := 114.0.5735.90

# Chrome 115
build-115: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/115.0.5790.170/linux64/build-linux64.zip
build-115: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/115.0.5790.170/linux64/chromedriver-linux64.zip
build-115: CHROME_VERSION := 115.0.5790.170
build-115: CHROME_DRIVER_VERSION := 115.0.5790.170

# Chrome 116
build-116: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/116.0.5845.96/linux64/build-linux64.zip
build-116: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/116.0.5845.96/linux64/chromedriver-linux64.zip
build-116: CHROME_VERSION := 116.0.5845.96
build-116: CHROME_DRIVER_VERSION := 116.0.5845.96

# Chrome 117
build-117: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/117.0.5938.149/linux64/build-linux64.zip
build-117: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/117.0.5938.149/linux64/chromedriver-linux64.zip
build-117: CHROME_VERSION := 117.0.5938.149
build-117: CHROME_DRIVER_VERSION := 117.0.5938.149

# Chrome 118
build-118: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/118.0.5993.70/linux64/build-linux64.zip
build-118: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/118.0.5993.70/linux64/chromedriver-linux64.zip
build-118: CHROME_VERSION := 118.0.5993.70
build-118: CHROME_DRIVER_VERSION := 118.0.5993.70

# Chrome 119
build-119: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/119.0.6045.105/linux64/build-linux64.zip
build-119: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/119.0.6045.105/linux64/chromedriver-linux64.zip
build-119: CHROME_VERSION := 119.0.6045.105
build-119: CHROME_DRIVER_VERSION := 119.0.6045.105

# Chrome 120
build-120: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/120.0.6099.109/linux64/build-linux64.zip
build-120: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/120.0.6099.109/linux64/chromedriver-linux64.zip
build-120: CHROME_VERSION := 120.0.6099.109
build-120: CHROME_DRIVER_VERSION := 120.0.6099.109

# Chrome 121
build-121: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/121.0.6167.184/linux64/build-linux64.zip
build-121: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/121.0.6167.184/linux64/chromedriver-linux64.zip
build-121: CHROME_VERSION := 121.0.6167.184
build-121: CHROME_DRIVER_VERSION := 121.0.6167.184

# Chrome 122
build-122: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/122.0.6261.128/linux64/build-linux64.zip
build-122: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/122.0.6261.128/linux64/chromedriver-linux64.zip
build-122: CHROME_VERSION := 122.0.6261.128
build-122: CHROME_DRIVER_VERSION := 122.0.6261.128

# Chrome 123
build-123: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/123.0.6312.122/linux64/build-linux64.zip
build-123: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/123.0.6312.122/linux64/chromedriver-linux64.zip
build-123: CHROME_VERSION := 123.0.6312.122
build-123: CHROME_DRIVER_VERSION := 123.0.6312.122

# Chrome 124
build-124: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/124.0.6367.207/linux64/build-linux64.zip
build-124: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/124.0.6367.207/linux64/chromedriver-linux64.zip
build-124: CHROME_VERSION := 124.0.6367.207
build-124: CHROME_DRIVER_VERSION := 124.0.6367.207

# Chrome 125
build-125: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/125.0.6422.141/linux64/build-linux64.zip
build-125: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/125.0.6422.141/linux64/chromedriver-linux64.zip
build-125: CHROME_VERSION := 125.0.6422.141
build-125: CHROME_DRIVER_VERSION := 125.0.6422.141

# Chrome 126
build-126: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/126.0.6478.182/linux64/build-linux64.zip
build-126: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/126.0.6478.182/linux64/chromedriver-linux64.zip
build-126: CHROME_VERSION := 126.0.6478.182
build-126: CHROME_DRIVER_VERSION := 126.0.6478.182

# Chrome 127
build-127: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/127.0.6533.119/linux64/build-linux64.zip
build-127: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/127.0.6533.119/linux64/chromedriver-linux64.zip
build-127: CHROME_VERSION := 127.0.6533.119
build-127: CHROME_DRIVER_VERSION := 127.0.6533.119

# Chrome 128
build-128: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/128.0.6613.137/linux64/build-linux64.zip
build-128: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/128.0.6613.137/linux64/chromedriver-linux64.zip
build-128: CHROME_VERSION := 128.0.6613.137
build-128: CHROME_DRIVER_VERSION := 128.0.6613.137

# Chrome 129
build-129: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/129.0.6668.100/linux64/build-linux64.zip
build-129: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/129.0.6668.100/linux64/chromedriver-linux64.zip
build-129: CHROME_VERSION := 129.0.6668.100
build-129: CHROME_DRIVER_VERSION := 129.0.6668.100

# Chrome 130
build-130: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/130.0.6723.116/linux64/build-linux64.zip
build-130: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/130.0.6723.116/linux64/chromedriver-linux64.zip
build-130: CHROME_VERSION := 130.0.6723.116
build-130: CHROME_DRIVER_VERSION := 130.0.6723.116

# Chrome 131
build-131: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/131.0.6778.264/linux64/build-linux64.zip
build-131: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/131.0.6778.264/linux64/chromedriver-linux64.zip
build-131: CHROME_VERSION := 131.0.6778.264
build-131: CHROME_DRIVER_VERSION := 131.0.6778.264

# Chrome 132
build-132: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/132.0.6834.159/linux64/build-linux64.zip
build-132: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/132.0.6834.159/linux64/chromedriver-linux64.zip
build-132: CHROME_VERSION := 132.0.6834.159
build-132: CHROME_DRIVER_VERSION := 132.0.6834.159

# Chrome 133
build-133: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/133.0.6943.141/linux64/build-linux64.zip
build-133: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/133.0.6943.141/linux64/chromedriver-linux64.zip
build-133: CHROME_VERSION := 133.0.6943.141
build-133: CHROME_DRIVER_VERSION := 133.0.6943.141

# Chrome 134
build-134: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/134.0.6998.165/linux64/build-linux64.zip
build-134: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/134.0.6998.165/linux64/chromedriver-linux64.zip
build-134: CHROME_VERSION := 134.0.6998.165
build-134: CHROME_DRIVER_VERSION := 134.0.6998.165

# Chrome 135
build-135: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/135.0.7049.114/linux64/build-linux64.zip
build-135: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/135.0.7049.114/linux64/chromedriver-linux64.zip
build-135: CHROME_VERSION := 135.0.7049.114
build-135: CHROME_DRIVER_VERSION := 135.0.7049.114

# Chrome 136
build-136: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/136.0.7103.113/linux64/build-linux64.zip
build-136: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/136.0.7103.113/linux64/chromedriver-linux64.zip
build-136: CHROME_VERSION := 136.0.7103.113
build-136: CHROME_DRIVER_VERSION := 136.0.7103.113

# Chrome 137
build-137: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/137.0.7151.119/linux64/build-linux64.zip
build-137: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/137.0.7151.119/linux64/chromedriver-linux64.zip
build-137: CHROME_VERSION := 137.0.7151.119
build-137: CHROME_DRIVER_VERSION := 137.0.7151.119

# Chrome 138
build-138: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/138.0.7204.183/linux64/build-linux64.zip
build-138: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/138.0.7204.183/linux64/chromedriver-linux64.zip
build-138: CHROME_VERSION := 138.0.7204.183
build-138: CHROME_DRIVER_VERSION := 138.0.7204.183

# Chrome 139
build-139: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/139.0.7258.154/linux64/build-linux64.zip
build-139: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/139.0.7258.154/linux64/chromedriver-linux64.zip
build-139: CHROME_VERSION := 139.0.7258.154
build-139: CHROME_DRIVER_VERSION := 139.0.7258.154

# Chrome 140
build-140: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/140.0.7339.207/linux64/build-linux64.zip
build-140: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/140.0.7339.207/linux64/chromedriver-linux64.zip
build-140: CHROME_VERSION := 140.0.7339.207
build-140: CHROME_DRIVER_VERSION := 140.0.7339.207

# Chrome 141
build-141: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/141.0.7390.122/linux64/build-linux64.zip
build-141: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/141.0.7390.122/linux64/chromedriver-linux64.zip
build-141: CHROME_VERSION := 141.0.7390.122
build-141: CHROME_DRIVER_VERSION := 141.0.7390.122

# Chrome 142
build-142: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/142.0.7444.175/linux64/build-linux64.zip
build-142: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/142.0.7444.175/linux64/chromedriver-linux64.zip
build-142: CHROME_VERSION := 142.0.7444.175
build-142: CHROME_DRIVER_VERSION := 142.0.7444.175

# Chrome 143
build-143: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/143.0.7499.192/linux64/build-linux64.zip
build-143: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/143.0.7499.192/linux64/chromedriver-linux64.zip
build-143: CHROME_VERSION := 143.0.7499.192
build-143: CHROME_DRIVER_VERSION := 143.0.7499.192

# Chrome 144
build-144: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/144.0.7559.133/linux64/build-linux64.zip
build-144: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/144.0.7559.133/linux64/chromedriver-linux64.zip
build-144: CHROME_VERSION := 144.0.7559.133
build-144: CHROME_DRIVER_VERSION := 144.0.7559.133

# Chrome 145
build-145: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/145.0.7632.117/linux64/build-linux64.zip
build-145: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/145.0.7632.117/linux64/chromedriver-linux64.zip
build-145: CHROME_VERSION := 145.0.7632.117
build-145: CHROME_DRIVER_VERSION := 145.0.7632.117

# Chrome 146
build-146: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/146.0.7680.165/linux64/build-linux64.zip
build-146: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/146.0.7680.165/linux64/chromedriver-linux64.zip
build-146: CHROME_VERSION := 146.0.7680.165
build-146: CHROME_DRIVER_VERSION := 146.0.7680.165

# Chrome 147
build-147: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/147.0.7727.117/linux64/build-linux64.zip
build-147: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/147.0.7727.117/linux64/chromedriver-linux64.zip
build-147: CHROME_VERSION := 147.0.7727.117
build-147: CHROME_DRIVER_VERSION := 147.0.7727.117

# Chrome 148
build-148: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/148.0.7778.56/linux64/build-linux64.zip
build-148: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/148.0.7778.56/linux64/chromedriver-linux64.zip
build-148: CHROME_VERSION := 148.0.7778.56
build-148: CHROME_DRIVER_VERSION := 148.0.7778.56

# Chrome 149
build-149: CHROME_URL := https://storage.googleapis.com/build-for-testing-public/149.0.7811.0/linux64/build-linux64.zip
build-149: CHROME_DRIVER_URL := https://storage.googleapis.com/build-for-testing-public/149.0.7811.0/linux64/chromedriver-linux64.zip
build-149: CHROME_VERSION := 149.0.7811.0
build-149: CHROME_DRIVER_VERSION := 149.0.7811.0

## ── Pattern Rule ──────────────────────────────────────

build-%:
	@echo ">>> Building Chrome $* ($(CHROME_VERSION))..."
	@mkdir -p "$(CACHE_DIR)"
	$(call DOWNLOAD_IF_MISSING,$(CACHE_DIR)/$(CHROME_VERSION)-chrome,$(CHROME_URL))
	$(call DOWNLOAD_IF_MISSING,$(CACHE_DIR)/$(CHROME_DRIVER_VERSION)-chromedriver,$(CHROME_DRIVER_URL))
	$(call DOCKER_BUILD)

## ── Test Target ────────────────────────────────────────

test-%:
	@echo ">>> Starting Chrome $* container with ChromeDriver on port 9515..."
	@container_id=$$(docker run -d --rm --cap-add=SYS_ADMIN -p 9515:9515 chrome:$* chromedriver --port=9515 --no-sandbox); \
	trap "docker stop $$container_id 2>/dev/null" EXIT; \
	echo ">>> Waiting for ChromeDriver to be ready..."; \
	for i in {1..30}; do \
		if curl -s http://localhost:9515/status | grep -q 'ready'; then \
			echo ">>> ChromeDriver is ready!"; \
			break; \
		fi; \
		if [ $$i -eq 30 ]; then \
			echo ">>> ChromeDriver failed to start within 30s"; \
			exit 1; \
		fi; \
		sleep 1; \
	done; \
	echo ">>> Running tests..."; \
	python3 test_chromedriver.py

chrome-%: build-% test-%
	@echo "Build & Test Complete"

## ── Helper Targets ─────────────────────────────────────

help:
	@echo "Chrome Docker Build System"
	@echo ""
	@echo "Usage:"
	@echo "  make build-X      Build Chrome version X (downloads & builds Docker image)"
	@echo "  make test-X       Test Chrome version X (starts container, runs selenium test)"
	@echo "  make chrome-X     Build and test Chrome version X"
	@echo ""
	@echo "Available Chrome versions:"
	@echo "  48-71, 75-76, 78-84, 86, 90, 102-104, 113-149"
	@echo ""
	@echo "Other targets:"
	@echo "  make clean        Remove cached files"
	@echo "  make help         Show this help"

clean:
	@echo ">>> Cleaning cache..."
	@rm -rf "$(CACHE_DIR)"
	@echo ">>> Cache cleaned."
