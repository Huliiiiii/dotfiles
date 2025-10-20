function proxy
    argparse q/quiet -- $argv
    or return
    set -l proxy_url "http://127.0.0.1:7890"

    set -gx proxy $proxy_url
    set -gx http_proxy $proxy_url
    set -gx https_proxy $proxy_url
    set -gx HTTP_PROXY $proxy_url
    set -gx HTTPS_PROXY $proxy_url

    if not set -q _flag_quiet
        echo "Proxy set to: $proxy_url"
    end

end
