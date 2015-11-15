class MyFormErrors < ActionView::Helpers::FormBuilder
  def label(methd, text = nil, options = {}, &block)
    errors = object.errors[method.to_sym]
    if errors
      text += " <span class=\"error\>#{errors.first}</span>"
    end
    super(method, text.html_safe, options &block)
  end
end