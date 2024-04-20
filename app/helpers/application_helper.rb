module ApplicationHelper
  # Check for blank value, and return "Not Available" if blank.
  def pretty_null_display(table_value)
    if table_value.is_a?(Integer) && table_value > 0 then
      table_value
    elsif !table_value.blank?
      strip_tags(table_value)
    else
      "Not Available"
    end
  end
end
