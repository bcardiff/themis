module ApplicationHelper
  def recent_time_span
    to_date = School.today
    (to_date - 3.months)..to_date
  end

  def local_wday(wday)
    I18n.t('date.day_names')[wday]
  end

  def number_to_currency(number, options = {})
    super(number, options.reverse_merge(precision: 2, format: '%u%n'))
  end

  def human_balance_category(text)
    case text
    when 'TeacherCashIncomes::FixAmountIncome'
      '7. Ajustes de saldo (entrega de plata)'
    when 'TeacherCashIncomes::NewCardIncome'
      '2. Ingresos por tarjetas nuevas'
    when 'TeacherCashIncomes::PlaceCommissionExpense'
      '5. Gastos por comisión de sala'
    when 'TeacherCashIncomes::PlaceInsuranceExpense'
      '6. Gastos por seguro de sala'
    when 'TeacherCashIncomes::StudentPaymentIncome'
      '1. Ingresos por clases'
    when 'TeacherPayment'
      '3. Pagos a profesores'
    when 'TeacherOwedPayment'
      '4. Pagos a profesores (pendientes)'
    when 'TeacherCashIncomes::VenueRent'
      '8. Alquiler de sala'
    when 'NetIncome'
      'Ingresos neto'
    else
      text
    end
  end

  def text_modal(label, title, text)
    id = SecureRandom.uuid
    render partial: 'shared/text_modal', locals: { id: id, label: label, title: title, text: text }
  end

  def plain_text_field(label, value = nil, &block)
    value = capture(&block) if block_given?
    render(partial: 'shared/plain_text_field', locals: { label: label, value: value })
  end

  def side_box(title, &block)
    haml_tag :div, class: 'well well-sm status-well' do
      haml_tag :div, class: 'row' do
        haml_tag :div, class: 'col-md-12' do
          haml_tag :h3 do
            haml_concat title
          end
        end
      end

      haml_tag :div, class: 'row', &block
    end
  end

  def side_box_data_full(legend, &block)
    haml_tag :div, class: 'col-md-12' do
      haml_tag :h1, &block
      haml_tag :label do
        haml_concat legend
      end
    end
  end

  def side_box_data(legend, &block)
    haml_tag :div, class: 'col-md-6' do
      haml_tag :h1, &block
      haml_tag :label do
        haml_concat legend
      end
    end
  end

  def side_box_data_sub(legend, &block)
    haml_tag :div, class: 'col-md-12' do
      haml_tag :h3, &block
      haml_tag :label do
        haml_concat legend
      end
    end
  end

  def react_component_config
    {
      place_id: params[:place_id],
      place_name: Place.find(params[:place_id]).name,
      single_class_price_by_kind: PaymentPlan.single_class_by_kind
        .transform_values { |p| number_to_currency(p.price) },
      payment_plans: PaymentPlan.all.order(:order, :price).to_a.select do |p|
                       !p.other? && (p.price.to_f > 0.001 || p.description.downcase.include?('bonif'))
                     end.map do |p|
                       { code: p.code, description: p.description, price: p.price.to_f }
                     end,
      teachers: Teacher.for_classes.to_a.map { |t| { id: t.id, name: t.name } },
      new_card_fee: number_to_currency(FixedFee.new_card_fee),
      date: (Date.from_dmy(params[:date]) || School.today).to_dmy,
      today: School.today.to_dmy
    }
  end

  def markdown(source)
    Kramdown::Document.new(source).to_html.html_safe
  end

  def darken_color(color, amount)
    color = Sass::Script::Value::Color.from_hex(color)
    color.with(lightness: [color.lightness * (100 - amount) / 100, 0].max).inspect
  end

  def tracks_color_css
    Track.all.map do |t|
      css_class = t.css_class
      css_color = t.color.presence || '#777777'
      css_color_darken = darken_color(css_color, 20)

      %(
.#{css_class} { background-color: #{css_color}; }
.#{css_class}:hover, .#{css_class}:active { background-color: #{css_color_darken}; })
    end.join
  end
end
