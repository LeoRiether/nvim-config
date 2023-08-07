local regular_snippets = {
    s("trig", t("loaded!!")),

    s(",a", t("\\alpha")),
    s(",b", t("\\beta")),
    s(",D", t("\\Delta")),
    s(",g", t("\\gamma")),
    s(",l", t("\\lambda")),
    s(",*", t("\\times")),
    s(",...", t("\\dots")),
    s(",^", { t("^{"), i(1), t("}"), i(0) }),
    s("v", { t("\\verb|"), i(1), t("|"), i(0) }),

    s("bf", { t("\\textbf{"), i(1), t("}"), i(0) }),
    s("it", { t("\\textit{"), i(1), t("}"), i(0) }),
    s("tt", { t("\\texttt{"), i(1), t("}"), i(0) }),

    s("env", { t("\\begin{"), i(1), t({ "}", "\t" }), i(0), t({ "", "\\end{" }), rep(1), t("}") }),
}

-- I don't know how to make these work...
local auto_snippets = {
}

return regular_snippets, auto_snippets
