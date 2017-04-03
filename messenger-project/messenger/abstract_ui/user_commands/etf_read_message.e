note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_READ_MESSAGE
inherit
	ETF_READ_MESSAGE_INTERFACE
		redefine read_message end
create
	make
feature -- command
	read_message(uid: INTEGER_64 ; mid: INTEGER_64)
		require else
			read_message_precond(uid, mid)
		local
    	do

			if uid <= 0 or mid <= 0 then
				model.set_status (model.error)
				model.set_report (model.err_non_positive_id)
			elseif not model.messenger.uid_exists (uid) then
				model.set_status (model.error)
				model.set_report (model.err_user_dne)
			elseif not model.messenger.mid_exists (mid) then
				model.set_status (model.error)
				model.set_report (model.err_message_dne)
			elseif model.messenger.i_th_group (model.messenger.i_th_message (mid).to_group).users.has (uid) then
				model.set_status (model.error)
				model.set_report (model.err_not_auhorized_to_access)
			elseif not model.messenger.user_at_uid (uid).new_messages.has (mid) then
				model.set_status (model.error)
				model.set_report (model.err_message_unavailable)
			elseif model.messenger.user_at_uid (uid).old_messages.has (mid) then
				model.set_status (model.error)
				model.set_report (model.err_message_already_read)
			else
				model.messenger.read_message (uid, mid)
				model.set_status (model.success_ok)
			end
			model.update_count
			etf_cmd_container.on_change.notify ([Current])
    	end

end
