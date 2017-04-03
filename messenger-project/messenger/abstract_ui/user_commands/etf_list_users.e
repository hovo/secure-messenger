note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LIST_USERS
inherit
	ETF_LIST_USERS_INTERFACE
		redefine list_users end
create
	make
feature -- command
	list_users
    	do
			if model.messenger.users.is_empty then
				model.set_report (model.warn_no_users)
			else
				-- add model.messenger.print_sorted_users
			end
			model.update_count
			model.set_status (model.success_ok)
			etf_cmd_container.on_change.notify ([Current])
    	end

end
