note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SEND_MESSAGE
inherit
	ETF_SEND_MESSAGE_INTERFACE
		redefine send_message end
create
	make
feature -- command
	send_message(uid: INTEGER_64 ; gid: INTEGER_64 ; txt: STRING)
		require else
			send_message_precond(uid, gid, txt)
		local
			message: MESSAGE
    	do
    		if uid <= 0 or gid <= 0 then
    			model.set_report (model.err_non_positive_id)
    		elseif not model.messenger.uid_exists (uid) then
				model.set_report (model.err_user_dne)
			elseif not model.messenger.gid_exists (gid) then
				model.set_report (model.err_group_dne)
			elseif txt.is_empty then
				model.set_report (model.err_empty_message)
			elseif not model.messenger.user_at_uid (uid).registered_to.has (gid) then
				model.set_report (model.err_not_authorized_to_send)
			else
				create message.make (model.messenger.message_count, uid, gid, txt)
				model.messenger.send_message (message)
				model.update_count
				model.set_report (model.success_ok)
    		end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
