module Napoleon::HTMLDiffTree
  class CDATA < StringNode
    def to_lmth(lmth, level, parent)
      if ['style', 'script'].include? parent.name
        lmth << value
        return lmth
      end

      lmth << '<![CDATA['
      lmth << value
      lmth << ']]>'
      lmth
    end
  end
end
