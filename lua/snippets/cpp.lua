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
}
