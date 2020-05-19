module Napoleon
  class SafeMarkdownRenderer < Redcarpet::Render::HTML
    def self.render(payload)
      Redcarpet::Markdown.new(self.new).render payload
    end

    def self.valid?(payload)
      render payload
      true
    rescue UnsafeMarkdown
      false
    end

    def block_html(raw_html)
      raise UnsafeMarkdown, 'could not have raw html'
    end

    def autolink(link, link_type)
      raise UnsafeMarkdown, 'should ot autolink'
    end

    def image(link, title, alt_text)
      raise UnsafeMarkdown, 'could not have any image'
    end

    def link(link, title, content)
      raise UnsafeMarkdown, 'could not have any link'
    end

    def raw_html(raw_html)
      raise UnsafeMarkdown, 'could not have raw html'
    end

    class UnsafeMarkdown < StandardError; end
  end
end
