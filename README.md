# pandocfilters

A Ruby gem for writing pandoc filters.

This is a Ruby port of origin [Python pandocfilters](https://github.com/jgm/pandocfilters).

## Installation

```ruby
gem 'pandocfilters'
```

or, use edge-version at GitHub:

```ruby
gem 'pandocfilters', github: 'AndorChen/pandocfilters'
```

## Usage

### Create a filter

```ruby
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

Write previous code into `page_break` file, then run `chmode u+x page_break` to make it excutable.

When use pandoc convert Markdown to docx, set `--filter` option to `page_break` file's path:

```sh
$ pandoc -f markdown -t docx -i sample.md --filter /path/to/page_break
```

### Use a build-in filter

Use `PandocFilters.filter('page_break')` to get the file path to build-in `page_break` filter, then set `--filter` option to this path when use pandoc.

## Author

[Andor Chen](http://about.ac)

## License

[MIT](LICENSE)

