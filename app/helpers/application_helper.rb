module ApplicationHelper

	def toast
		flash_messages = []
		flash.each do |type, message|
			type = 'success' if type == 'notice'
			type = 'error'   if type == 'alert'
			text = "<script>toastr.#{type}('#{message}');</script>"
			flash_messages << text.html_safe if message
		end
		flash_messages.join("\n").html_safe
	end

	def current_basket
		if session[:basket_id].present?
			found = Basket.find_by_id(session[:basket_id])
			found || Basket.new
		else
			Basket.new
		end
	end
end
