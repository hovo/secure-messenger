note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LIST_GROUPS
inherit
	ETF_LIST_GROUPS_INTERFACE
		redefine list_groups end
create
	make
feature -- command
	list_groups
    	do
    		model.reset_report

			model.update_count
			model.set_status (model.success_ok)
			model.set_command_type (model.command_type_list_groups)

			if model.messenger.groups.is_empty then
				model.set_report (model.warn_no_groups)
			else
				model.set_report (model.messenger.list_groups)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
