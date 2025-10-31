function zswap --description 'Show zswap debug info'
    set msg 'Usage: zswap -s|--show -p|params'

    argparse --name=zswap s/show h/help p/params -- $argv
    or begin
        echo $msg
        return 1
    end

    if set -q _flag_h
        echo $msg
        return 0
    end

    if set -q _flag_s; or set -q _flag_show
        sudo grep -r . /sys/kernel/debug/zswap/
        return 0
    end

    if set -q _flag_p; or set -q _flag_params
        sudo grep -r . /sys/module/zswap/parameters/
        return 0
    end

    echo $msg
    return 1
end
