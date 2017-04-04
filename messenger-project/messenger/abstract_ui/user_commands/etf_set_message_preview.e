note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SET_MESSAGE_PREVIEW
inherit
	ETF_SET_MESSAGE_PREVIEW_INTERFACE
		redefine set_message_preview end
create
	make
feature -- command
	set_message_preview(n: INTEGER_64)
    	do
    		model.reset
			if n <= 0 then
				model.set_status (model.error)
				model.set_report (model.err_message_lenght)
			else
				model.messenger.set_message_preview (n)
				model.set_status (model.success_ok)
			end
			model.update_count
			etf_cmd_container.on_change.notify ([Current])
    	end

end
