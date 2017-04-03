note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DELETE_MESSAGE
inherit
	ETF_DELETE_MESSAGE_INTERFACE
		redefine delete_message end
create
	make
feature -- command
	delete_message(uid: INTEGER_64 ; mid: INTEGER_64)
		require else
			delete_message_precond(uid, mid)
    	do
    		if uid <= 0 or mid <= 0 then
    			model.set_report (model.err_non_positive_id)
    		elseif not model.messenger.uid_exists (uid) then
				model.set_report (model.err_user_dne)
			elseif not model.messenger.mid_exists (mid) then
				model.set_report (model.err_message_dne)
			elseif not model.messenger.user_at_uid (uid).old_messages.has (mid) then
				model.set_report (model.err_message_not_found_in_new_old)
			elseif not model.messenger.user_at_uid (uid).new_messages.has (mid) then
				model.set_report (model.err_message_not_found_in_new_old)
			else
				model.messenger.delete_message (uid, mid)
				model.update_count
    		end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
