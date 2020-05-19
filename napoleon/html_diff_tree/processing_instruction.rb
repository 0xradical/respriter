module Napoleon::HTMLDiffTree
  class ProcessingInstruction < StringNode
    def to_lmth(lmth, level, parent)
      lmth << '<?xml '
      lmth << value
      lmth << '>'
      lmth
    end
  end
end
