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
			create messenger.make
			i := 0
		end

feature -- model attributes
	s: STRING
	i: INTEGER
	messenger: MESSENGER

feature {ETF_COMMAND} -- ERROR MESSAGES
	report: STRING
		attribute
			create Result.make_empty
		end

	err_non_positive_id: STRING
		attribute
			Result := "ID must be a positive integer."
		end

	err_id_in_use: STRING
		attribute
			Result := "ID already in use."
		end

	err_user_name_start: STRING
		attribute
			Result := "User name must start with a letter."
		end

	err_group_name_start: STRING
		attribute
			Result := "Group name must start with a letter."
		end

	err_user_dne: STRING
		attribute
			Result := "User with this ID does not exist."
		end

	err_group_dne: STRING
		attribute
			Result := "Group with this ID does not exist."
		end

	err_registration_exists: STRING
		attribute
			Result := "This registration already exists."
		end

	err_empty_message: STRING
		attribute
			Result := "A message may not be an empty string."
		end

	err_not_authorized_to_send: STRING
		attribute
			Result := "User not authorized to send messages to the specified group."
		end

	err_message_dne: STRING
		attribute
			Result := "Message with this ID does not exist."
		end

	err_not_auhorized_to_access: STRING
		attribute
			Result := "User not authorized to access this message."
		end

	err_message_unavailable: STRING
		attribute
			Result := "Message with this ID unavailable."
		end

	err_message_already_read: STRING
		attribute
			Result := "Message has already been read. See `list_old_messages'."
		end

	err_message_not_found_in_new_old: STRING
		attribute
			Result := "Message with this ID not found in old/read messages."
		end

	err_message_lenght: STRING
		attribute
			Result := "Message length must be greater than zero."
		end

	

feature -- Set report
	set_report (new_report: STRING)
		do
			report := new_report
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




