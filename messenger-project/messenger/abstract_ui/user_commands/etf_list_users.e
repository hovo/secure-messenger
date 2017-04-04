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
    		model.reset_report

			model.update_count
			model.set_status (model.success_ok)
			model.set_command_type (model.command_type_list_users)

			if model.messenger.users.is_empty then
				model.set_report (model.warn_no_users)
			else
				model.set_report (model.messenger.list_users)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
