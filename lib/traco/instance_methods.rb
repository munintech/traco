module Traco
  module InstanceMethods

    private

    def read_localized_value(column, options={})
      locales_for_reading_column(column, options).each do |locale|
        value = send("#{column}_#{locale}")
        return value if value.present?
      end
      nil
    end

    def write_localized_value(column, value)
      send("#{column}_#{I18n.locale}=", value)
    end

    def locales_for_reading_column(column, options={})
      fallback_locales =
        if fallback = options[:fallback]
          if fallback.is_a?(Proc)
            fallback.call(self)
          else
            Array(fallback)
          end.map(&:to_sym)
        end
      # fallback = nil
      self.class.locales_for_column(column, options).select { |locale|
        fallback ? fallback_locales.include?(locale) : true
      }.sort_by { |locale|
        case locale
        when I18n.locale then "0"
        when I18n.default_locale then "1"
        else locale.to_s
        end
      }
    end

  end
end
