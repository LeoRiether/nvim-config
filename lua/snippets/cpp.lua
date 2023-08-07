local function cursor_position(_args, _snip)
    local cursor = vim.api.nvim_win_get_cursor(0)
    return tostring(cursor[1]) .. ":" .. tostring(cursor[2])
end

local function escape_quotes(args, snip)
    return args[1][1]:gsub('"', '\\"')
end

return {
    s('all', {
        i(1), t(".begin(), "), rep(1), t(".end()"), i(0),
    }),
    s('sort', fmta('sort(<>.begin(), <>.end());', { i(1), rep(1) })),

    -- SystemC
    s('SC_MODULE', fmta([[
        SC_MODULE(<>) {
            <>

            SC_CTOR(<>) {
                <>
            }
        };
        ]], { i(1), i(2), rep(1), i(0) })),
    s('sc', fmt([[
        sc_!?<!?> !?{"!?"};
    ]], { i(1), i(2), i(3), rep(3) }, { delimiters = '!?' })),

    -- std::cerr << "[line:column] my_variable = " << my_variable << std::endl;
    s('db', {
        t('std::cerr << "['), f(cursor_position, {}), t("] "),
        f(escape_quotes, {1}), t(' = " << '), i(1), t(" << std::endl;"), i(0),
    }),

    -- cout << x << '\n';
    -- "cout line"
    s('cl', {
        t("cout << "), i(0), t(" << '\\n';")
    }),
}
