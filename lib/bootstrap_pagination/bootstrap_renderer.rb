require "bootstrap_pagination/version"

module BootstrapPagination
  # Contains functionality shared by all renderer classes.
  module BootstrapRenderer

    def to_html
      html = pagination.map do |item|
        item.is_a?(Fixnum) ? page_number(item) : send(item)
      end.join(@options[:link_separator])

      html = html_container(html) if @options[:container]

      tag("nav", tag("ul", html, class: ul_class))
    end

    def container_attributes
      super.except(*[:link_options])
    end

    protected

    def page_number(page)
      link_options = @options[:link_options] || {}

      if page == current_page
        tag("li", link(page, "#", class: "page-link"), class: "page-item active")
      else
        tag("li", link(page, page, link_options.merge(rel: rel_value(page), class: "page-link")), class: "page-item")
      end
    end

    def previous_or_next_page(page, text, classname)
      link_options = @options[:link_options] || {}

      if page
        tag("li", link(text, page, link_options.merge(class: "page-link")), class: "%s page-item" % classname)
      else
        tag("li", link(text, "#", class: "page-link"), class: "%s page-item disabled" % classname)
      end
    end

    def gap
      tag("li", link("&hellip;", "#", class: "page-link"), class: "page-item disabled")
    end

    def previous_page
      num = @collection.current_page > 1 && @collection.current_page - 1
      previous_or_next_page(num, @options[:previous_label], "Previous")
    end

    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], "Next")
    end

    def ul_class
      ["pagination", @options[:class]].compact.join(" ")
    end
  end
end
