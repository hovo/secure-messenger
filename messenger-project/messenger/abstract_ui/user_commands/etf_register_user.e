note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REGISTER_USER
inherit
	ETF_REGISTER_USER_INTERFACE
		redefine register_user end
create
	make
feature -- command
	register_user(uid: INTEGER_64 ; gid: INTEGER_64)
		require else
			register_user_precond(uid, gid)
    	do
    		if uid <= 0  or gid <= 0 then
				model.set_report (model.err_non_positive_id)
			elseif not model.messenger.uid_exists (uid) then
				model.set_report (model.err_user_dne)
			elseif not model.messenger.gid_exists (gid) then
				model.set_report (model.err_group_dne)
			elseif model.messenger.user_at_uid (uid).registered_to.has (gid) then
				model.set_report (model.err_registration_exists)
			else
				model.messenger.register_user (uid, gid)
				model.update_count
    		end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
