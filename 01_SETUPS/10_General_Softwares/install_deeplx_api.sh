# This script installs DeepLX and sets it up for use.
# https://deeplx.owo.network/
#
# Environment Variables:
#
# DeepLX supports passing the following parameters for advanced deployments:
# - port or p: The port the server will listen on (default: 1188)
# - token: Access token to protect your API (default: null)
# - s: DeepL Pro Account dl_session cookie (default: null)
# - proxy: HTTP proxy server address (default: null, format: http://username:password@127.0.0.1:6152)
#
# Notes:
# - By default, it listens on port 1188 with no token protection.
# - If dl_session is not provided, Pro endpoint usage is not possible.
#
# Free Endpoint:
# - Simulates the DeepL iOS client for translation requests.
# - Endpoint: /translate (Method: POST)
# - Required Request Parameters:
#   - text: The text to translate (required)
#   - source_lang: Source language code (required)
#   - target_lang: Target language code (required)
#
# Free Endpoint Example:
# To translate text using the free endpoint:
# curl -X POST http://localhost:1188/translate \
# -H "Content-Type: application/json" \
# -H "Authorization: Bearer your_access_token" \
# -d '{
#     "text": "Hello, world!",
#     "source_lang": "EN",
#     "target_lang": "DE"
# }'
#
# Pro Endpoint Example:
# To translate text using the Pro endpoint:
# curl -X POST http://localhost:1188/v1/translate \
# -H "Content-Type: application/json" \
# -H "Authorization: Bearer your_access_token" \
# -d '{
#     "text": "Hello, world!",
#     "source_lang": "EN",
#     "target_lang": "DE"
# }'
#
# Official Endpoint Example:
# To translate text using the official endpoint:
# curl -X POST 'http://localhost:1188/v2/translate' \
# --header 'Authorization: DeepL-Auth-Key [yourAccessToken]' \
# --header 'Content-Type: application/json' \
# --data '{
#   "text": [
#     "Hello, world!"
#   ],
#   "target_lang": "DE"
# }'

install_deeplx(){
    last_version=$(curl -Ls "https://api.github.com/repos/OwO-Network/DeepLX/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [[ ! -n "$last_version" ]]; then
        echo -e "Failed to detect DeepLX version, probably due to exceeding Github API limitations."
        exit 1
    fi
    echo -e "DeepLX latest version: ${last_version}, Start install..."

    # Check if running as root
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root. Try using sudo."
        exit 1
    fi

    # Download DeepLX binary
    wget -q -N --no-check-certificate -O /usr/bin/deeplx https://github.com/OwO-Network/DeepLX/releases/download/${last_version}/deeplx_linux_amd64

    # Make the binary executable
    chmod +x /usr/bin/deeplx

    # Create systemd service directory if it doesn't exist
    mkdir -p /etc/systemd/system

    # Download systemd service file
    wget -q -N --no-check-certificate -O /etc/systemd/system/deeplx.service https://raw.githubusercontent.com/OwO-Network/DeepLX/main/deeplx.service

    # Reload systemd and enable/start the service
    systemctl daemon-reload
    systemctl enable deeplx
    systemctl start deeplx

    echo -e "Installed successfully, listening at 0.0.0.0:1188"
}

install_deeplx
