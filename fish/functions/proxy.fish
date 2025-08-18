function proxy
    set -l proxy_url "http://127.0.0.1:7890"

    set -x http_proxy $proxy_url
    set -x https_proxy $proxy_url
    set -x HTTP_PROXY $proxy_url
    set -x HTTPS_PROXY $proxy_url

    echo "Proxy set to: $proxy_url"
end
