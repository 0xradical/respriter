module Napoleon::HTMLDiffTree
  class Comment < StringNode
    def to_lmth(lmth, level, parent)
      lmth << '<!--'
      lmth << value
      lmth << '-->'
      lmth
    end
  end
end
