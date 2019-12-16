function json
    cat $argv[1] | python -m json.tool
end
