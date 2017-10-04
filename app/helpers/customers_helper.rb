module CustomersHelper
  def cc_years
    yrs = []
    year_today = Date.today.strftime("%y").to_i
    year_today.upto(year_today+10).each do |y| yrs << y.to_s;end
    return yrs
  end

  def error_message obj, key
  	((obj.errors.try(:messages) || {})[key.to_sym] || []).join ', '
  end

  def has_error obj, key
  	obj.errors && @order.errors.messages[key.to_sym].present?
  end
end