require 'json'
require_relative 'pandocfilters/node'

module PandocFilters

  # Fetch prebuild filter.
  #
  # @param name [String] Filter name.
  # @return     [String] Path to the filter.
  def self.filter(name)
    glob = File.expand_path('../pandocfilters/filters/*' ,__FILE__)
    filters = Dir.glob(glob).map { |f| File.basename(f) }

    raise "No build-in filter names #{name}" unless filters.include?(name)

    File.expand_path("../pandocfilters/filters/#{name}" ,__FILE__)
  end

  # Converts an action into a filter that reads a JSON-formatted
  # pandoc document from stdin, transforms it by walking the tree
  # with the action, and returns a new JSON-formatted pandoc document
  # to stdout.  The argument is a function action(key, value, format, meta),
  # where key is the type of the pandoc object (e.g. 'Str', 'Para'),
  # value is the contents of the object (e.g. a string for 'Str',
  # a list of inline elements for 'Para'), format is the target
  # output format (which will be taken for the first command line
  # argument if present), and meta is the document's metadata.
  # If the function returns None, the object to which it applies
  # will remain unchanged.  If it returns an object, the object will
  # be replaced.    If it returns a list, the list will be spliced in to
  # the list to which the target object belongs.    (So, returning an
  # empty list deletes the object.)
  #
  # action Callable object
  #
  # Return Manuplated JSON
  def self.process(&action)
    doc = JSON.load($stdin.read)
    if ARGV.size > 1
      format = ARGV[1]
    else
      format = ""
    end
    altered = self.walk(doc, format, doc[0]['unMeta'], &action)
    JSON.dump(altered, $stdout)
  end

  # Walks the tree x and returns concatenated string content,
  # leaving out all formatting.
  def self.stringify(x)
    result = []

    go = lambda do |key, val, format, meta|
      if ['Str', 'MetaString'].include? key
        result.push(val)
      elsif key == 'Code'
        result.push(val[1])
      elsif key == 'Math'
        result.push(val[1])
      elsif key == 'LineBreak'
        result.push(" ")
      elsif key == 'Space'
        result.push(" ")
      end
    end

    self.walk(x, "", {}, &go)

    result.join('')
  end

  # Returns an attribute list, constructed from the
  # dictionary attrs.
  def attributes(attrs)
    attrs ||= {}
    ident = attrs.fetch('id', '')
    classes = attrs.fetch("classes", [])
    keyvals = []
    attrs.keep_if { |k, v| k != "classes" && k != "id" }.each do |k, v|
      keyvals << [k, v]
    end

    [ident, classes, keyvals]
  end

  # Walk a tree, applying an action to every object.
  # Returns a modified tree.
  def self.walk(x, format, meta, &action)
    if x.is_a? Array
      array = []
      x.each do |item|
        if item.is_a?(Hash) && item.has_key?('t')
          res = action.call(item['t'], item['c'], format, meta)
          if res.nil?
            array.push(self.walk(item, format, meta, &action))
          elsif res.is_a? Array
            res.each { |z| array.push(self.walk(z, format, meta, &action)) }
          else
            array.push(self.walk(res, format, meta, &action))
          end
        else
          array.push(self.walk(item, format, meta, &action))
        end
      end
      return array
    elsif x.is_a? Hash
      hash = {}
      x.each { |k, _| hash[k] = self.walk(x[k], format, meta, &action) }
      return hash
    else
      return x
    end
  end

end
