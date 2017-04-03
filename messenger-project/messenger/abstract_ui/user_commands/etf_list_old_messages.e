note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LIST_OLD_MESSAGES
inherit
	ETF_LIST_OLD_MESSAGES_INTERFACE
		redefine list_old_messages end
create
	make
feature -- command
	list_old_messages(uid: INTEGER_64)
		require else
			list_old_messages_precond(uid)
    	do
			if uid <= 0 then
				model.set_report (model.err_non_positive_id)
			elseif not model.messenger.uid_exists (uid) then
				model.set_report (model.err_user_dne)
			elseif model.messenger.user_at_uid (uid).old_messages.is_empty then
				model.set_report (model.warn_no_old_messages)
			else
				-- Add model.messenger.list_old_messages (uid)
				model.update_count
				model.set_report (model.success_ok)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
