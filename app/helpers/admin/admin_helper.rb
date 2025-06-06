module Admin::AdminHelper
  def enum_i18n(value, type)
    return '-' if value.blank?
    I18n.t("enums.#{type}.#{value}", default: value.to_s.humanize)
  end
end