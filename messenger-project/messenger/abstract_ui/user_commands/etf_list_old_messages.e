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
    		model.reset_report

    		model.update_count
    		model.set_command_type (model.command_type_list_old_messages)

			if uid <= 0 then
				model.set_status (model.error)
				model.set_report (model.err_non_positive_id)
			elseif not model.messenger.uid_exists (uid) then
				model.set_status (model.error)
				model.set_report (model.err_user_dne)
			elseif model.messenger.user_at_uid (uid).old_messages.is_empty then
				model.set_status (model.success_ok)
				model.set_report (model.warn_no_old_messages)
			else

				model.set_status (model.success_ok)
				model.set_report (model.messenger.list_old_messages (uid))
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
