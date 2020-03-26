# Font Setup

* Install `Fira Code iScript` from [here](https://github.com/kencrocken/FiraCodeiScript)
* Set following preferences
```
"editor.fontFamily": "'Fira Code iScript'",
    "editor.fontLigatures": true,
    "editor.tokenColorCustomizations": {
        "textMateRules": [{
            "scope": [
              "comment",
              "entity.name.type.class",
              "keyword",
              "constant",
              "storage",
            ],
            "settings": {
              "fontStyle": "italic"
            }
          },
          {
            "scope": [
              "invalid",
              "keyword.operator",
              "constant.numeric.css",
              "keyword.other.unit.px.css",
              "constant.numeric.decimal.js",
              "constant.numeric.json",
              "storage.type.function.arrow",
            ],
            "settings": {
              "fontStyle": ""
            }
          }
        ]
    }
```