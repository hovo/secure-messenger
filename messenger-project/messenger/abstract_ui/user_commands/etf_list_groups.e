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
			if model.messenger.groups.is_empty then
				model.set_report (model.warn_no_groups)
			else
				-- Add model.messenger.print_sorted_groups
			end
			model.update_count
			model.set_status (model.success_ok)
			etf_cmd_container.on_change.notify ([Current])
    	end

end
