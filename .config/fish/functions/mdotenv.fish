function mdotenv --description "Source a .env file, ignoring comments and blank lines"
    set --local env_file $argv[1]
 
    if test -z "$env_file"
        set env_file .env
    end
 
    if not test -f "$env_file"
        echo "load_env: file not found: $env_file" >&2
        return 1
    end
 
    while read --local line
        # Skip blank lines and comments
        string match --quiet --regex '^\s*$' $line; and continue
        string match --quiet --regex '^\s*#' $line; and continue
 
        # Strip optional leading "export " and inline comments
        set --local clean (string replace --regex '^\s*export\s+' '' $line)
        set --local clean (string replace --regex '\s*#.*$' '' $clean)
 
        # Split on the first '=' only
        set --local key (string match --regex '^[^=]+' $clean)[1]
        set --local val (string replace --regex '^[^=]+=?' '' $clean)
 
        # Strip surrounding quotes from the value
        set --local val (string match --regex '^"(.*)"$' $val)[2]; \
            or set val (string match --regex '^'\''(.*)'\''$' $val)[2]; \
            or true
 
        if test -n "$key"
            set --export --global $key $val
        end
    end < $env_file
end

