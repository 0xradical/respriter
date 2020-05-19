module Napoleon::HTMLDiffTree
  class Document < Node
    def to_lmth
      lmth = ''
      children.each do |child|
        child.to_lmth lmth, 0, self
      end
      lmth
    end
  end
end
