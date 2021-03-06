module Traco
  module ClassMethods

    def locales_for_column(column, options={})
      column_names.grep(/\A#{column}_([a-z]{2})\z/) {
        $1.to_sym
      }.sort_by { |locale|
        if locale == I18n.default_locale
         "0"
        else
          locale.to_s
        end
      }
    end

    def human_attribute_name(attribute, options={})
      default = super(attribute, options.merge(:default => ""))
      if default.blank? && attribute.to_s.match(/\A(\w+)_([a-z]{2})\z/)
        column, locale = $1, $2.to_sym
        if translates?(column)
          return "#{super(column, options)} (#{locale_name(locale)})"
        end
      end
      super
    end

    private

    def translates?(column)
      translatable_columns.include?(column.to_sym)
    end

    def locale_name(locale)
      I18n.t(locale, :scope => :"i18n.languages", :default => locale.to_s.upcase)
    end

  end
end
