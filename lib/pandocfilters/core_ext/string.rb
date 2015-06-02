class String

  # Strips off underscores in string, then capitalize each words.
  #
  # @return [String] Camelized string.
  def camelize
    string = self
    string.split('_').map(&:capitalize).join('')
  end

end
