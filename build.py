#!/usr/bin/env python3
"""Chrome Headless Build Script - Replaces Makefile with CfT API integration."""

import os
import sys
from pathlib import Path

# Auto-detect and use venv if available
SCRIPT_DIR = Path(__file__).parent
VENV_DIR = SCRIPT_DIR / ".venv"
VENV_PYTHON = VENV_DIR / "bin" / "python3"

# Check if we're already running the venv python by comparing the executable path
# Don't resolve symlinks - we want to know if we're running .venv/bin/python3
if VENV_DIR.exists() and Path(sys.executable) != VENV_PYTHON:
    os.execv(str(VENV_PYTHON), [str(VENV_PYTHON), __file__] + sys.argv[1:])

import argparse
import json
import subprocess
import time
import urllib.request
from urllib.parse import urlparse, parse_qs
CACHE_DIR = SCRIPT_DIR / ".cache"
CFT_API_URL = "https://googlechromelabs.github.io/chrome-for-testing/latest-versions-per-milestone-with-downloads.json"
CFT_CACHE_FILE = CACHE_DIR / "cft-milestones-with-downloads.json"
CFT_CACHE_MAX_AGE = 3600  # 1 hour

LEGACY_VERSIONS = {
    "48": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_48.0.2564.109.deb",
        "chrome_version": "48.0.2564.109",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.21/chromedriver_linux64.zip",
        "chromedriver_version": "2.21"
    },
    "49": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_49.0.2623.75.deb",
        "chrome_version": "49.0.2623.75",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.22/chromedriver_linux64.zip",
        "chromedriver_version": "2.22"
    },
    "50": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_50.0.2661.75.deb",
        "chrome_version": "50.0.2661.75",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.22/chromedriver_linux64.zip",
        "chromedriver_version": "2.22"
    },
    "51": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_51.0.2704.84.deb",
        "chrome_version": "51.0.2704.84",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.23/chromedriver_linux64.zip",
        "chromedriver_version": "2.23"
    },
    "52": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_52.0.2743.116.deb",
        "chrome_version": "52.0.2743.116",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.23/chromedriver_linux64.zip",
        "chromedriver_version": "2.23"
    },
    "53": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_53.0.2785.116.deb",
        "chrome_version": "53.0.2785.116",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.26/chromedriver_linux64.zip",
        "chromedriver_version": "2.26"
    },
    "54": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_54.0.2840.71.deb",
        "chrome_version": "54.0.2840.71",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.27/chromedriver_linux64.zip",
        "chromedriver_version": "2.27"
    },
    "55": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_55.0.2883.75.deb",
        "chrome_version": "55.0.2883.75",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.28/chromedriver_linux64.zip",
        "chromedriver_version": "2.28"
    },
    "56": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_56.0.2924.87.deb",
        "chrome_version": "56.0.2924.87",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip",
        "chromedriver_version": "2.29"
    },
    "57": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_57.0.2987.133.deb",
        "chrome_version": "57.0.2987.133",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip",
        "chromedriver_version": "2.29"
    },
    "58": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_58.0.3029.96.deb",
        "chrome_version": "58.0.3029.96",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip",
        "chromedriver_version": "2.31"
    },
    "59": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_59.0.3071.86.deb",
        "chrome_version": "59.0.3071.86",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.32/chromedriver_linux64.zip",
        "chromedriver_version": "2.32"
    },
    "60": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_60.0.3112.90.deb",
        "chrome_version": "60.0.3112.90",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.33/chromedriver_linux64.zip",
        "chromedriver_version": "2.33"
    },
    "61": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_61.0.3163.79.deb",
        "chrome_version": "61.0.3163.79",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.34/chromedriver_linux64.zip",
        "chromedriver_version": "2.34"
    },
    "62": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_62.0.3202.75.deb",
        "chrome_version": "62.0.3202.75",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.35/chromedriver_linux64.zip",
        "chromedriver_version": "2.35"
    },
    "63": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_63.0.3239.108.deb",
        "chrome_version": "63.0.3239.108",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.36/chromedriver_linux64.zip",
        "chromedriver_version": "2.36"
    },
    "64": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_64.0.3282.140.deb",
        "chrome_version": "64.0.3282.140",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.37/chromedriver_linux64.zip",
        "chromedriver_version": "2.37"
    },
    "65": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_65.0.3325.181.deb",
        "chrome_version": "65.0.3325.181",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.38/chromedriver_linux64.zip",
        "chromedriver_version": "2.38"
    },
    "66": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_66.0.3359.181.deb",
        "chrome_version": "66.0.3359.181",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.40/chromedriver_linux64.zip",
        "chromedriver_version": "2.40"
    },
    "67": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_67.0.3396.79.deb",
        "chrome_version": "67.0.3396.79",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip",
        "chromedriver_version": "2.41"
    },
    "68": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_68.0.3440.84.deb",
        "chrome_version": "68.0.3440.84",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.42/chromedriver_linux64.zip",
        "chromedriver_version": "2.42"
    },
    "69": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F69.0.3497.92%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "69.0.3497.92",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.44/chromedriver_linux64.zip",
        "chromedriver_version": "2.44"
    },
    "70": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F70.0.3538.77%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "70.0.3538.77",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip",
        "chromedriver_version": "2.45"
    },
    "71": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F71.0.3578.80%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "71.0.3578.80",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip",
        "chromedriver_version": "2.45"
    },
    "75": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F75.0.3770.80%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "75.0.3770.80",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/75.0.3770.140/chromedriver_linux64.zip",
        "chromedriver_version": "75.0.3770.140"
    },
    "76": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F76.0.3809.100%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "76.0.3809.100",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/76.0.3809.126/chromedriver_linux64.zip",
        "chromedriver_version": "76.0.3809.126"
    },
    "78": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F78.0.3904.97%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "78.0.3904.97",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/78.0.3904.105/chromedriver_linux64.zip",
        "chromedriver_version": "78.0.3904.105"
    },
    "79": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F79.0.3945.88%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "79.0.3945.88",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_linux64.zip",
        "chromedriver_version": "79.0.3945.36"
    },
    "80": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F80.0.3987.149%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "80.0.3987.149",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_linux64.zip",
        "chromedriver_version": "80.0.3987.106"
    },
    "81": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F81.0.4044.92%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "81.0.4044.92",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/81.0.4044.138/chromedriver_linux64.zip",
        "chromedriver_version": "81.0.4044.138"
    },
    "83": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F83.0.4103.116%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "83.0.4103.116",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/83.0.4103.39/chromedriver_linux64.zip",
        "chromedriver_version": "83.0.4103.39"
    },
    "84": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F84.0.4147.135%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "84.0.4147.135",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/84.0.4147.30/chromedriver_linux64.zip",
        "chromedriver_version": "84.0.4147.30"
    },
    "86": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F86.0.4240.75%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "86.0.4240.75",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/86.0.4240.22/chromedriver_linux64.zip",
        "chromedriver_version": "86.0.4240.22"
    },
    "90": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F90.0.4430.72%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "90.0.4430.72",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/90.0.4430.24/chromedriver_linux64.zip",
        "chromedriver_version": "90.0.4430.24"
    },
    "102": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F102.0.5005.63%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "102.0.5005.63",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/102.0.5005.61/chromedriver_linux64.zip",
        "chromedriver_version": "102.0.5005.61"
    },
    "103": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F103.0.5060.53%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "103.0.5060.53",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/103.0.5060.134/chromedriver_linux64.zip",
        "chromedriver_version": "103.0.5060.134"
    },
    "104": {
        "dockerfile": "Dockerfile.slimjet",
        "chrome_url": "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F104.0.5112.102%2Fgoogle-chrome-stable_current_amd64.deb",
        "chrome_version": "104.0.5112.102",
        "chromedriver_url": "https://chromedriver.storage.googleapis.com/104.0.5112.79/chromedriver_linux64.zip",
        "chromedriver_version": "104.0.5112.79"
    }
}

def fetch_cft_api():
    """Fetch and cache the Chrome for Testing API data."""
    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    if CFT_CACHE_FILE.exists():
        age = time.time() - CFT_CACHE_FILE.stat().st_mtime
        if age < CFT_CACHE_MAX_AGE:
            with open(CFT_CACHE_FILE) as f:
                return json.load(f)

    print(f">>> Fetching CfT API: {CFT_API_URL}")
    req = urllib.request.Request(CFT_API_URL, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())

    with open(CFT_CACHE_FILE, "w") as f:
        json.dump(data, f)

    return data

def get_cft_version(major_version):
    """Get version info from CfT API for given major version."""
    data = fetch_cft_api()
    milestones = data.get("milestones", {})
    milestone_data = milestones.get(str(major_version))

    if not milestone_data:
        return None

    version = milestone_data.get("version")
    downloads = milestone_data.get("downloads", {})

    chrome_url = None
    chromedriver_url = None

    for item in downloads.get("chrome", []):
        if item.get("platform") == "linux64":
            chrome_url = item["url"]
            break

    for item in downloads.get("chromedriver", []):
        if item.get("platform") == "linux64":
            chromedriver_url = item["url"]
            break

    if not chrome_url:
        return None

    # Fallback to legacy chromedriver URL if not in CfT API (113-114)
    if not chromedriver_url:
        chromedriver_url = f"https://chromedriver.storage.googleapis.com/{version}/chromedriver_linux64.zip"
        print(f">>> Chromedriver not in CfT API, using legacy URL: {chromedriver_url}")

    return {
        "dockerfile": "Dockerfile.cft",
        "chrome_url": chrome_url,
        "chrome_version": version,
        "chromedriver_url": chromedriver_url,
        "chromedriver_version": version
    }

def download_if_missing(filepath, url):
    """Download file if it doesn't exist."""
    if filepath.exists():
        print(f"File '{filepath}' already exists. Skipping.")
        return True

    print(f"Downloading {url} -> {filepath}")
    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req) as response:
            with open(filepath, "wb") as f:
                f.write(response.read())
        return True
    except Exception as e:
        print(f"Download failed: {e}")
        return False


def get_cache_filename(version, url):
    """Generate a cache filename prefixed with version."""
    parsed = urlparse(url)
    filename = Path(parsed.path).name

    # Handle Slimjet URLs with query params
    if not filename or filename.endswith('.php') or '?' in url:
        qs = parse_qs(parsed.query)
        if 'file' in qs:
            filename = qs['file'][0].split('/')[-1]
        elif 'chromedriver' in url:
            filename = f"chromedriver-linux64.zip"
        else:
            filename = f"chrome-{version}.deb"

    return f"{version}-{filename}"


def docker_build(config):
    """Build Docker image with Chrome version."""
    dockerfile = config["dockerfile"]
    chrome_url = config["chrome_url"]
    chromedriver_url = config["chromedriver_url"]
    chrome_version = config["chrome_version"]
    chromedriver_version = config["chromedriver_version"]

    chrome_major = chrome_version.split(".")[0]
    chromedriver_major = chromedriver_version.split(".")[0]

    chrome_cache_file = get_cache_filename(chrome_version, chrome_url)
    chromedriver_cache_file = get_cache_filename(chromedriver_version, chromedriver_url)

    chrome_cache_path = f".cache/{chrome_cache_file}"
    chromedriver_cache_path = f".cache/{chromedriver_cache_file}"

    print(f">>> Using {dockerfile}...")
    cmd = [
        "docker", "build",
        "--platform", "linux/amd64",
        "-f", dockerfile,
        "--build-arg", f"CHROME_URL={chrome_url}",
        "--build-arg", f"CHROME_DRIVER_URL={chromedriver_url}",
        "--build-arg", f"CHROME_CACHE_PATH={chrome_cache_path}",
        "--build-arg", f"CHROME_DRIVER_CACHE_PATH={chromedriver_cache_path}",
        "--build-arg", f"CHROME_MAJOR_VERSION={chrome_major}",
        "--build-arg", f"CHROME_VERSION={chrome_version}",
        "--build-arg", f"CHROME_DRIVER_MAJOR_VERSION={chromedriver_major}",
        "--build-arg", f"CHROME_DRIVER_VERSION={chromedriver_version}",
        "-t", f"chrome:{chrome_version}",
        "--progress=plain",
        "."
    ]

    result = subprocess.run(cmd)
    if result.returncode == 0:
        print(f">>> Built: chrome:{chrome_version}")
    return result.returncode

def run_selenium_test():
    """Run Selenium test directly (moved from test_chromedriver.py)."""
    from selenium import webdriver
    from selenium.webdriver.chrome.options import Options
    from selenium.webdriver.common.by import By
    from selenium.webdriver.support.ui import WebDriverWait
    from selenium.webdriver.support import expected_conditions as EC
    import time

    chrome_options = Options()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')

    max_retries = 5
    retry_delay = 2

    for attempt in range(max_retries):
        try:
            driver = webdriver.Remote(
                command_executor='http://localhost:9515',
                options=chrome_options
            )
            break
        except Exception as e:
            if attempt == max_retries - 1:
                print(f"Failed to connect to ChromeDriver after {max_retries} attempts: {e}")
                return 1
            print(f"Attempt {attempt + 1} failed, retrying in {retry_delay}s...")
            time.sleep(retry_delay)

    try:
        driver.get('https://example.org')
        WebDriverWait(driver, 10).until(EC.title_contains('Example'))

        title = driver.title
        h1 = driver.find_element(By.TAG_NAME, 'h1').text

        assert 'Example' in title, f"Title mismatch: {title}"
        assert h1 == 'Example Domain', f"H1 mismatch: {h1}"

        print("All tests passed!")
        return 0
    except Exception as e:
        print(f"Test failed: {e}")
        return 1
    finally:
        driver.quit()


def test_chrome(version):
    """Run ChromeDriver test in container."""
    print(f">>> Starting Chrome {version} container with ChromeDriver on port 9515...")

    run_cmd = [
        "docker", "run", "-d", "--rm", "--cap-add=SYS_ADMIN",
        "--platform", "linux/amd64",
        "-p", "9515:9515", f"chrome:{version}",
        "chromedriver", "--port=9515", "--no-sandbox", "--whitelisted-ips="
    ]

    result = subprocess.run(run_cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Failed to start container: {result.stderr}")
        return 1

    container_id = result.stdout.strip()

    try:
        print(">>> Waiting for ChromeDriver to be ready...")
        for i in range(30):
            try:
                req = urllib.request.Request("http://localhost:9515/status")
                with urllib.request.urlopen(req, timeout=2) as response:
                    data = json.loads(response.read().decode())
                    if data.get("value", {}).get("ready"):
                        print(">>> ChromeDriver is ready!")
                        break
            except Exception:
                pass

            if i == 29:
                print(">>> ChromeDriver failed to start within 30s")
                return 1
            time.sleep(1)

        print(">>> Running tests...")
        return run_selenium_test()

    finally:
        subprocess.run(["docker", "stop", container_id], capture_output=True)

def clean():
    """Remove cached files."""
    print(">>> Cleaning cache...")
    if CACHE_DIR.exists():
        import shutil
        shutil.rmtree(CACHE_DIR)
    print(">>> Cache cleaned.")

def setup_venv():
    """Setup virtual environment and install dependencies."""
    venv_dir = SCRIPT_DIR / ".venv"
    requirements_file = SCRIPT_DIR / "requirements.txt"

    if not venv_dir.exists():
        print(">>> Creating virtual environment...")
        subprocess.run([sys.executable, "-m", "venv", str(venv_dir)])
    else:
        print(">>> Virtual environment already exists.")

    pip = venv_dir / "bin" / "pip"
    print(">>> Installing dependencies...")
    subprocess.run([str(pip), "install", "-r", str(requirements_file)])

    print(">>> Setup complete!")
    print(f">>> Activate with: source {venv_dir}/bin/activate")


def show_help():
    """Show help information."""
    print("Chrome Docker Build System")
    print()
    print("Usage:")
    print("  python build.py <version>    Build and test Chrome version")
    print("  python build.py setup       Setup virtual environment and dependencies")
    print("  python build.py clean       Remove cached files")
    print("  python build.py help        Show this help")
    print()
    print("Available Chrome versions:")
    print("  Legacy (Slimjet): 48-71, 75-76, 78-84, 86, 90, 102-104")
    print("  CfT API (113+): Any milestone available in Chrome for Testing")
    print()
    print("Examples:")
    print("  python build.py 48     # Build + test Chrome 48 (legacy)")
    print("  python build.py 113    # Build + test Chrome 113 (CfT API)")
    print("  python build.py setup  # Create venv and install dependencies")

def main():
    parser = argparse.ArgumentParser(description="Chrome Headless Build Script", add_help=False)
    parser.add_argument("command", nargs="?", help="Version number, 'setup', 'clean', or 'help'")
    args = parser.parse_args()

    if not args.command or args.command == "help":
        show_help()
        return 0

    if args.command == "clean":
        clean()
        return 0

    if args.command == "setup":
        setup_venv()
        return 0

    major_version = args.command

    if not major_version.isdigit():
        print(f"Invalid version: {major_version}")
        return 1

    print(f">>> Building Chrome {major_version}...")

    config = None

    if int(major_version) >= 113:
        print(f">>> Checking CfT API for milestone {major_version}...")
        config = get_cft_version(major_version)
        if config:
            print(f">>> Found in CfT API: {config['chrome_version']}")
        else:
            print(f">>> Milestone {major_version} not found in CfT API")

    if not config:
        config = LEGACY_VERSIONS.get(major_version)
        if config:
            print(f">>> Found in legacy versions: {config['chrome_version']}")

    if not config:
        print(f"version unavailable: {major_version}")
        return 1

    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    chrome_cache_file = get_cache_filename(config['chrome_version'], config['chrome_url'])
    chromedriver_cache_file = get_cache_filename(config['chromedriver_version'], config['chromedriver_url'])

    chrome_cache = CACHE_DIR / chrome_cache_file
    chromedriver_cache = CACHE_DIR / chromedriver_cache_file

    if not download_if_missing(chrome_cache, config["chrome_url"]):
        return 1

    if not download_if_missing(chromedriver_cache, config["chromedriver_url"]):
        return 1

    build_result = docker_build(config)
    if build_result != 0:
        return build_result

    test_result = test_chrome(config["chrome_version"])
    return test_result

if __name__ == "__main__":
    sys.exit(main())
