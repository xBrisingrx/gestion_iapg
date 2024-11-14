class BootstrapBuilder < ActionView::Helpers::FormBuilder
  # include ActionView::Helpers::TagHelper
  # include ActionView::Context

  # le indicamos que alguien mas se va a encargar de la vista
  delegate :content_tag, to: :@template

  # en options nos vienen todos los datos de este input,
  # podemos extraer las clases css si es q las tiene asi no las perdemos
  # ahi usamos nuestro metodo partition_custom
  def label(method, text = nil, options = {})
    content_tag :div, class: "col-3" do
      super(method, text, options.merge(class: "form-label"))
    end
  end

  def submit(*args)
    options  = args.extract_options!
    options[:class] = "btn btn-sm btn-primary"
    super(*args, options)
  end

  [ :text_field, :number_field, :date_field, :time_field ].each do |method|
    define_method method do |attribute, options = {}|
      style_options, custom_options = partition_custom_opts(options)
      content_tag :div, class: "col-6" do
        super(attribute, options.merge(class: "form-control #{style_options[:class]}"))
      end
    end
  end

  def text_area(attribute, options = {})
    super(attribute, options.reverse_merge(class: "form-control"))
  end

  # def select(object_name, method_name, template_object, options={})
  #   super(object_name, method_name, template_object, options.reverse_merge(class: "select"))
  # end

  # def div_radio_button(method, tag_value, options = {})
  #   @template.content_tag(:div,
  #     @template.radio_button(
  #       @object_name, method, tag_value, objectify_options(options)
  #     )
  #   )
  # end

  CUSTOM_OPTS = [ :class ].freeze
  def partition_custom_opts(opts)
    opts.partition { |k, v| CUSTOM_OPTS.include?(k) }.map(&:to_h)
  end
end
