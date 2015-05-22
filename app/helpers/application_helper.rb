module ApplicationHelper
  def text_modal(label, title, text)
    id = SecureRandom.uuid
    render partial: 'shared/text_modal', locals: { id: id, label: label , title: title, text: text }
  end

  def text_field(label, value = nil)
    if block_given?
      value = capture do
        yield
      end
    end
    render(partial: 'shared/text_field', locals: { label: label, value: value })
  end
end
