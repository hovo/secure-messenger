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
			create s.make_empty
			i := 0
			create messenger.make
			count := 1

		end

feature -- model attributes
	s: STRING
	i: INTEGER
	count: INTEGER
	messenger: MESSENGER

feature {ETF_COMMAND} -- ERROR MESSAGES
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



feature
	set_report (new_report: STRING)
		do
			report := new_report
		end

	update_count
		do
			count := count + 1
		end

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  ")
			Result.append ("System State: default model state ")
			Result.append ("(")
			Result.append (i.out)
			Result.append (")")
		end

end




