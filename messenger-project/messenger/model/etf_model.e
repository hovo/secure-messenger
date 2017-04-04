note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create messenger.make
			count := 0
			--report := success_ok
			status := success_ok
			command_type := command_type_default
		end

feature -- model attributes
	count: INTEGER
	messenger: MESSENGER

feature {ETF_COMMAND} -- ERROR MESSAGES
	command_type: STRING
		attribute
			create Result.make_empty
		end

	status: STRING
		attribute
			create Result.make_empty
		end

	report: STRING
		attribute
			create Result.make_empty
		end

	success_ok: STRING
		-- OK
		attribute
			Result := "  OK"
		end

	error: STRING
		-- ERROR
		attribute
			Result := "  ERROR"
		end

	err_non_positive_id: STRING
		-- ID must be a positive integer.
		attribute
			Result := "ID must be a positive integer."
		end

	err_id_in_use: STRING
		-- ID already in use.
		attribute
			Result := "ID already in use."
		end

	err_user_name_start: STRING
		-- User name must start with a letter.
		attribute
			Result := "User name must start with a letter."
		end

	err_group_name_start: STRING
		-- Group name must start with a letter.
		attribute
			Result := "Group name must start with a letter."
		end

	err_user_dne: STRING
		-- User with this ID does not exist.
		attribute
			Result := "User with this ID does not exist."
		end

	err_group_dne: STRING
	 	-- Group with this ID does not exist.
		attribute
			Result := "Group with this ID does not exist."
		end

	err_registration_exists: STRING
		-- This registration already exists.
		attribute
			Result := "This registration already exists."
		end

	err_empty_message: STRING
	 	-- A message may not be an empty string.
		attribute
			Result := "A message may not be an empty string."
		end

	err_not_authorized_to_send: STRING
	 	-- User not authorized to send messages to the specified group.
		attribute
			Result := "User not authorized to send messages to the specified group."
		end

	err_message_dne: STRING
		-- Message with this ID does not exist.
		attribute
			Result := "Message with this ID does not exist."
		end

	err_not_auhorized_to_access: STRING
		-- User not authorized to access this message.
		attribute
			Result := "User not authorized to access this message."
		end

	err_message_unavailable: STRING
		-- Message with this ID unavailable.
		attribute
			Result := "Message with this ID unavailable."
		end

	err_message_already_read: STRING
		-- Message has already been read. See `list_old_messages'.
		attribute
			Result := "Message has already been read. See `list_old_messages'."
		end

	err_message_not_found_in_new_old: STRING
		-- Message with this ID not found in old/read messages.
		attribute
			Result := "Message with this ID not found in old/read messages."
		end

	err_message_lenght: STRING
		-- Message length must be greater than zero.
		attribute
			Result := "Message length must be greater than zero."
		end

	warn_no_groups: STRING
		-- There are no groups registered in the system yet.
		attribute
			Result := "There are no groups registered in the system yet."
		end

	warn_no_users: STRING
		-- There are no users registered in the system yet.
		attribute
			Result := "There are no users registered in the system yet."
		end

	warn_no_new_messages: STRING
		attribute
			Result := "There are no new messages for this user."
		end

	warn_no_old_messages: STRING
		attribute
			Result := "There are no old messages for this user."
		end


	command_type_list_users: STRING
		attribute
			Result := "list_users"
		end

	command_type_list_groups: STRING
		attribute
			Result := "list_groups"
		end

	command_type_list_new_messages: STRING
		attribute
			Result := "list_new_messages"
		end

	command_type_list_old_messages: STRING
		attribute
			Result := "list_old_messages"
		end

	command_type_default: STRING
		attribute
			Result := "command"
		end

feature
	set_command_type (type: STRING)
		do
			command_type := type
		end
	set_report (new_report: STRING)
		do
			report := new_report
		end

	set_status (new_status: STRING)
		do
			status := new_status
		end

	update_count
		do
			count := count + 1
		end

feature -- model operations
	reset
			-- Reset model state.
		do
			command_type := command_type_default
		end

	reset_report
		do
			report := ""
		end

feature -- queries
	out : STRING
		do
			create Result.make_empty
			Result := "  " + count.out + ":" + status +  "%N"
			-- count keeps number of commands entered
			-- when count is zero we only print the above output

			if count > 0 then
				-- check command type
				if command_type = command_type_default then -- handle commands
					if status = error then
						Result.append ("  " + report + "%N")
					else
						Result.append (
						  "  Users:%N" + messenger.print_sorted_users +
						  "  Groups:%N" + messenger.print_sorted_groups +
					  	  "  Registrations:%N" + messenger.list_registrations +
					  	  "  All messages:%N" + messenger.list_all_messages +
					      "  Message state:%N" + messenger.message_states)
					end
				else -- handle queries
					Result.append ("  " + report + "%N")
				end
			end

		end

end




