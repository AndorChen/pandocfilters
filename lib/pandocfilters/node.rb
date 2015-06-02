require_relative 'core_ext/string'

module PandocFilters
  class Node
    # Pandoc build-in node types
    # see http://hackage.haskell.org/package/pandoc-types-1.12.4.3/docs/Text-Pandoc-Definition.html
    #
    # key: node type
    # value: expected arguments number
    NODES = {
      # block elements
      plain: 1,
      para: 1,
      code_block: 2,
      raw_block: 2,
      block_quote: 1,
      ordered_list: 2,
      bullet_list: 1,
      definition_list: 1,
      header: 3,
      horizontal_rule: 0,
      table: 5,
      div: 2,
      null: 0,

      # inline elements
      str: 1,
      emph: 1,
      strong: 1,
      strikeout: 1,
      superscript: 1,
      subscript: 1,
      small_caps: 1,
      quoted: 2,
      cite: 2,
      code: 2,
      space: 0,
      line_break: 0,
      math: 2,
      raw_inline: 2,
      link: 2,
      image: 2,
      note: 1,
      span: 2
    }

    class << self
      def method_missing(name, *args)
        raise "undefined #{name} node type" unless NODES.keys.include?(name)
        unless args.size == NODES[name]
          raise "#{name} expects #{NODES[name]} arguments, but given #{args.size}"
        end

        new(name.to_s.camelize, *args).to_hash
      end
    end

    attr_reader :type
    attr_reader :args

    def initialize(type, *args)
      @type = type
      @args = args
    end

    def to_hash
      xs = case args.size
      when 0
        []
      when 1
        args[0]
      else
        args
      end

      {'t': type, 'c': xs}
    end

  end
end
