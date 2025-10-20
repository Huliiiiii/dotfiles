function unproxy
    set -ge http_proxy
    set -ge https_proxy
    set -ge HTTP_PROXY
    set -ge HTTPS_PROXY

    echo "Proxy disabled"
end
