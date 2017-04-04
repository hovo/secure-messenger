note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_USER
inherit
	ETF_ADD_USER_INTERFACE
		redefine add_user end
create
	make
feature -- command
	add_user(uid: INTEGER_64 ; user_name: STRING)
		require else
			add_user_precond(uid, user_name)
		local
			user: USER
    	do
    		model.reset
			if uid <= 0 then
				model.set_status (model.error)
				model.set_report (model.err_non_positive_id)
			elseif model.messenger.uid_exists (uid) then
				model.set_status (model.error)
				model.set_report (model.err_id_in_use)
			elseif not (user_name.count > 0 and user_name.at (1).is_alpha) then
				model.set_status (model.error)
				model.set_report (model.err_user_name_start)
			else
				create user.make (uid, user_name)
				model.messenger.add_user (user)
				model.set_status (model.success_ok)
			end
			model.update_count
			etf_cmd_container.on_change.notify ([Current])
    	end

end
