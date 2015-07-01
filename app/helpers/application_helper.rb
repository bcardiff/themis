module ApplicationHelper
  def local_wday(wday)
    I18n.t('date.day_names')[wday]
  end

  def number_to_currency(number, options = {})
    super(number, options.reverse_merge(precision: 2, format: '%u%n'))
  end

  def text_modal(label, title, text)
    id = SecureRandom.uuid
    render partial: 'shared/text_modal', locals: { id: id, label: label , title: title, text: text }
  end

  def plain_text_field(label, value = nil)
    if block_given?
      value = capture do
        yield
      end
    end
    render(partial: 'shared/plain_text_field', locals: { label: label, value: value })
  end

  def side_box(title)
    haml_tag :div, class: 'well well-sm status-well' do
      haml_tag :div, class: 'row' do
        haml_tag :div, class: 'col-md-12' do
          haml_tag :h3 do
            haml_concat title
          end
        end
      end

      haml_tag :div, class: 'row' do
        yield
      end
    end
  end

  def side_box_data_full(legend)
    haml_tag :div, class: 'col-md-12' do
      haml_tag :h1 do
        yield
      end
      haml_tag :label do
        haml_concat legend
      end
    end
  end

  def side_box_data(legend)
    haml_tag :div, class: 'col-md-6' do
      haml_tag :h1 do
        yield
      end
      haml_tag :label do
        haml_concat legend
      end
    end
  end
end
