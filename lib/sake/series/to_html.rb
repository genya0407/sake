require 'erb'

module Sake::Series::ToHTML
  def to_html
    template_path = File.expand_path('./to_html.erb', __FILE__)
    ERB.new(File.read(template_path)).result(binding)
  end
end

