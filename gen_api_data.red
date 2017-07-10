Red []

get-api-data: function [][
    collect/into [
    foreach w sort words-of system/words [
        if all [word? w any-function? get/any :w][
            h: (replace/all (mold fetch-help :w) "^^/" "\n")
            h: (replace/all h "^"" "\^"")
            h: (replace/all h "^^{" "")
            h: (replace/all h "^^}" "")
            h: (replace/all h "^{" "\^"")
            h: (replace/all h "^}" "\^"")
            h: append copy/part next h ((length? h) - 3) {"}
            ; h: (replace/all h "\^"" "^"")
            keep reduce ["  ['" w "'] = { description = " h " }," lf]
        ]
    ]
    ] copy ""
]
write %api.lua form reduce ["return {" newline get-api-data "}"]
