function unproxy
    set -e http_proxy
    set -e https_proxy
    set -e HTTP_PROXY
    set -e HTTPS_PROXY

    echo "Proxy disabled"
end
