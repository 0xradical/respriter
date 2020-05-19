class Nokogiri::XML::Document
  def to_diff_tree
    diff_tree = Napoleon::HTMLDiffTree::Document.new
    children.each do |node|
      if node_tree = node.to_diff_tree
        diff_tree.children << node_tree
      end
    end
    diff_tree
  end
end

# TODO: Keep track of DTD creating HTMLDiff and Tokens for it
class Nokogiri::XML::DTD
  def to_diff_tree
    nil
  end
end

class Nokogiri::XML::Element
  def to_diff_tree
    diff_tree = Napoleon::HTMLDiffTree::Element.new name, attributes, line: line
    children.each do |node|
      if node_tree = node.to_diff_tree
        diff_tree.children << node_tree
      end
    end
    diff_tree
  end
end

class Nokogiri::XML::Text
  # TODO: Handle space-wise tags, like <pre> converting from Nokogiri to DiffTree
  def to_diff_tree
    parsed_text = text.gsub /\s+/, ' '
    if parsed_text != ''
      Napoleon::HTMLDiffTree::Text.new parsed_text, line: line
    else
      nil
    end
  end
end

class Nokogiri::XML::CDATA
  def to_diff_tree
    Napoleon::HTMLDiffTree::CDATA.new text, line: line
  end
end

class Nokogiri::XML::Comment
  def to_diff_tree
    Napoleon::HTMLDiffTree::Comment.new text, line: line
  end
end

class Nokogiri::XML::ProcessingInstruction
  def to_diff_tree
    Napoleon::HTMLDiffTree::ProcessingInstruction.new text, line: line
  end
end
