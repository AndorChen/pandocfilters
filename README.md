# pandocfilters

A Ruby gem for writing pandoc filters.

This is a Ruby port of origin [Python pandocfilters](https://github.com/jgm/pandocfilters).

## Installation

```
gem 'pandocfilters', github: 'AndorChen/pandocfilters'
```

## Usage

```
#!/usr/bin/env ruby

# Identify paragraph contains `<!--PAGEBREAK-->' as page break in docx.
# Then replace the page break with raw OOXML xml'.

require 'pandocfilters'

filter = lambda do |key, value, format, meta|
  if key == 'RawBlock' && value[1] == '<!--PAGEBREAK-->'
    xml = %(<w:p><w:r><w:br w:type="page"/></w:r></w:p>)

    return PandocFilters::Node.raw_block('openxml', xml)
  end
end

PandocFilters.process &filter
```

## Author

[Andor Chen](http://about.ac)

## License

[MIT](LICENSE)

