note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_GROUP
inherit
	ETF_ADD_GROUP_INTERFACE
		redefine add_group end
create
	make
feature -- command
	add_group(gid: INTEGER_64 ; group_name: STRING)
		require else
			add_group_precond(gid, group_name)
		local
			group: GROUP
    	do
			if gid <= 0 then
				model.set_report (model.err_non_positive_id)
			elseif model.messenger.gid_exists (gid) then
				model.set_report (model.err_id_in_use)
			elseif not (group_name.count > 0 and group_name.at (1).is_alpha) then
				model.set_report (model.err_group_name_start)
			else
				create group.make (gid, group_name)
				model.messenger.add_group (group)
				model.update_count
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
