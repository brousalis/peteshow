module Peteshow
  module Helpers
    def peteshow_include_tag(*args)
      config = Peteshow.config
      country = args.first.is_a?(String) ? args.shift : nil
      options = args.first || {}

      return unless config.enabled == true

      tags = []
      tags << javascript_include_tag('peteshow.min.js',     options)
      tags << javascript_include_tag("peteshow.#{country}", options) if country
      tags << stylesheet_link_tag('peteshow')

      tags.join.html_safe
    end
  end
end
