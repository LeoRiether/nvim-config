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
    s(",v", { t("\\verb|"), i(1), t("|"), i(0) }),
}

-- I don't know how to make these work...
local auto_snippets = {
}

return regular_snippets, auto_snippets
