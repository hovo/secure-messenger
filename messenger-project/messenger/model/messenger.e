note
	description: "Summary description for {MESSENGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSENGER

create
	make

feature -- Attributes
	users: SORTED_TWO_WAY_LIST[USER]
	groups: SORTED_TWO_WAY_LIST[GROUP]
	messages: SORTED_TWO_WAY_LIST[MESSAGE]
	message_count: INTEGER_64
	message_preview_length: INTEGER_64

feature
	make
		do
			create users.make
			create groups.make
			create messages.make
			message_count := message_count + 1
			message_preview_length := 15
		end

feature -- Queries
	add_user (user: USER)
		-- Add new user to users list
		require
			unique_user: not uid_exists (user.uid)
		do
			users.extend (user)
			users.sort
		ensure
			has_user: uid_exists (user.uid)

		end

	add_group (group: GROUP)
		-- Add new group to groups list
		require
			unique_group: not gid_exists (group.gid)
		do
			groups.extend (group)
			groups.sort
		ensure
			has_group: gid_exists (group.gid)
		end

	register_user (uid: INTEGER_64; gid: INTEGER_64)
		-- Register a user to a group
		require
			positive_uid: uid > 0
			positive_gid: gid > 0
			user_id_exists: uid_exists (uid)
			gid_exists: gid_exists (gid)
			new_registration: not user_at_uid (uid).registered_to.has (gid)
		do
			user_at_uid (uid).registered_to.extend (gid)
			user_at_uid (uid).registered_to.sort
			i_th_group (gid).users.force (uid)
		ensure
			registered: user_at_uid (uid).registered_to.has (gid)
		end

	send_message (message: MESSAGE)
		-- send message to gid
		require
			user_id_exists: uid_exists (message.sender)
			group_id_exists: gid_exists (message.to_group)
			user_in_group: user_at_uid (message.sender).registered_to.has (message.to_group)
		local
			group_users: LIST[INTEGER_64]
			user, loop_user: USER
		do
			user := user_at_uid (message.sender) -- get sender's uid
			user.old_messages.extend (message.mid) -- Add mid to sender's old_messages
			user.old_messages.sort -- keep the list sorted
			message.read_by.force (message.sender) -- update read by list
			messages.extend (message) -- add message to list of messages
			messages.sort -- keep messages sorted

			group_users := i_th_group (message.to_group).users

			from
				group_users.start
			until
				group_users.after
			loop
				loop_user := user_at_uid (group_users.item)
				if loop_user.uid /= message.sender then
					loop_user.new_messages.extend (message.mid)
					loop_user.new_messages.sort
				end

				group_users.forth
			end
			message_count := message_count + 1
		ensure
			is_read: message.read_by.has (message.sender)
		end

	read_message (uid: INTEGER_64; mid: INTEGER_64)
		-- Mark message as read
		require
			positive_uid: uid > 0
			positive_mid: mid > 0
			user_exists: uid_exists (uid)
			message_exists: mid_exists (mid)
			--not_authorized: i_th_group (i_th_message (mid).to_group).users.has (uid)
			--message_unavailable: user_at_uid (uid).new_messages.has (mid)
			already_read: not user_at_uid (uid).old_messages.has (mid)
		local
			user: USER
			message: MESSAGE
    	do
    		-- Get the message
    		message := i_th_message(mid)
    		-- Remove from new_messages list
    		user := user_at_uid (uid)
    		user.new_messages.search (mid)
    		user.new_messages.remove
    		-- Add to old_messages list
    		user.old_messages.extend (mid)
    		user.old_messages.sort
    		-- Add to read_by list of message
			message.read_by.force (uid)

    	end

	delete_message (uid: INTEGER_64; mid: INTEGER_64)
		-- delete message from list
		require
			positive_uid: uid > 0
			positive_mid: mid > 0
			user_exists: uid_exists (uid)
			message_exists: mid_exists (mid)
			new_old_exists: user_at_uid (uid).new_messages.has (mid) or user_at_uid (uid).old_messages.has (mid)
		local
			sender: USER
			message: MESSAGE
		do
			sender := user_at_uid (uid)
			message := i_th_message (mid)
			sender.old_messages.search (message.mid)
			sender.old_messages.remove
		end

	set_message_preview (length: INTEGER_64)
		-- updates the message preview length
		require
			valid_length: length > 0
		do
			message_preview_length := length
		end


feature -- print Queries
	list_all_messages: STRING
		local
			format: STRING
			preview_text: STRING
			message: MESSAGE
		do
			create Result.make_empty

			from
				messages.start
			until
				messages.after
			loop
				message := messages.item
				if message.content.count > message_preview_length then
					preview_text := messages.item.content.substring (1, message_preview_length.as_integer_32) + "..."
				else
					preview_text := messages.item.content
				end

				format := "      " + message.mid.out + "->[sender: " + message.sender.out +
						  ", group: " + message.to_group.out + ", content: " + preview_text + "]"

				Result.append (format + "%N")

				messages.forth
			end
		end

	list_new_messages (uid: INTEGER_64):STRING
		-- list user's new messages
		require
			positive_uid: uid > 0
			user_exists: uid_exists (uid)
		local
			message: MESSAGE
			new_message_list: SORTED_TWO_WAY_LIST[INTEGER_64]
			format: STRING
			preview_text: STRING
		do
			new_message_list := user_at_uid (uid).new_messages
			create Result.make_empty
			from
				new_message_list.start
			until
				new_message_list.after
			loop
				message := i_th_message (new_message_list.item)

				if message.content.count > message_preview_length then
					preview_text := message.content.substring (1, message_preview_length.as_integer_32) + "..."
				else
					preview_text := message.content
				end

				format := message.mid.out + "->[sender: " + message.sender.out +
						  ", group: " + message.to_group.out + ", content: " + preview_text + "]"

				Result.append (format)
				if not new_message_list.islast then
					Result.append ("%N")
				end
				new_message_list.forth
			end
		end

	list_old_messages (uid: INTEGER_64):STRING
		-- list user's old/read message
		require
			positive_uid: uid > 0
			user_exists: uid_exists (uid)
		local
			message: MESSAGE
			old_message_list: SORTED_TWO_WAY_LIST[INTEGER_64]
			format: STRING
			preview_text: STRING
		do
			old_message_list := user_at_uid (uid).old_messages
			create Result.make_empty
			from
				old_message_list.start
			until
				old_message_list.after
			loop
				message := i_th_message (old_message_list.item)

				if message.content.count > message_preview_length then
					preview_text := message.content.substring (1, message_preview_length.as_integer_32) + "..."
				else
					preview_text := message.content
				end

				format := message.mid.out + "->[sender: " + message.sender.out +
						  ", group: " + message.to_group.out + ", content: " + preview_text + "]"

				Result.append (format)
				if not old_message_list.islast then
					Result.append ("%N")
				end
				old_message_list.forth
			end
		end

	list_groups: STRING
		-- list all groups in alphabetical order
		local
			format: STRING
		do
			create Result.make_empty
			create format.make_empty
			from
				groups.start
			until
				groups.after
			loop
				if not groups.isfirst then
					format := "  "
				end
				format.append (groups.item.gid.out + "->" + groups.item.name)
				Result.append (format)
				if not groups.islast then
					Result.append ("%N")
				end
				groups.forth
			end
		end

	list_users: STRING
		-- list all users in alphabetical order
		local
			format: STRING
		do
			create Result.make_empty
			create format.make_empty
			from
				users.start
			until
				users.after
			loop
				if not users.isfirst then
					format := "  "
				end
				format.append (users.item.uid.out + "->" + users.item.name)
				Result.append (format)
				if not users.islast then
					Result.append ("%N")
				end
				users.forth
			end
		end

	list_registrations: STRING
		-- List all registrations
		local
			format: STRING
			groups_format: STRING
		do
			create Result.make_empty
			create groups_format.make_empty

			from
				users.start
			until
				users.after
			loop
				format := "      [" + users.item.uid.out + ", " + users.item.name + "]->{"
				from
					users.item.registered_to.start
				until
					users.item.registered_to.after
				loop
					groups_format := i_th_group (users.item.registered_to.item).gid.out + "->" + i_th_group (users.item.registered_to.item).name
					if not users.item.registered_to.islast then
						groups_format.append (", ")
					end
					format.append (groups_format)
					users.item.registered_to.forth
				end
				format.append ("}")
				if not users.item.registered_to.is_empty then
					Result.append (format + "%N")
				end

				users.forth
			end
		end

	message_states: STRING
		-- Print state of messages
		local
			format: STRING
			message_status: STRING
			sorted_user_list: SORTED_TWO_WAY_LIST[INTEGER_64]
		do
			create Result.make_empty
			create format.make_empty
			sorted_user_list := sort_user_by_uid

			from
				messages.start
			until
				messages.after
			loop
				from
					sorted_user_list.start
				until
					sorted_user_list.after
				loop
					if messages.item.read_by.has (sorted_user_list.item) then
						message_status := "read"
					elseif user_at_uid (sorted_user_list.item).new_messages.has (messages.item.mid) then
						message_status := "unread"
					else
						message_status := "unavailable"
					end
					format := "      (" + sorted_user_list.item.out + ", " + messages.item.mid.out + ")->" + message_status
					Result.append(format)
					if not sorted_user_list.islast then
						Result.append ("%N")
					end
					sorted_user_list.forth
				end
				if not messages.islast then
					Result.append ("%N")
				end
				messages.forth
			end
		end

	print_sorted_users: STRING
		-- print users sorted by their uid
		local
			sorted_users: SORTED_TWO_WAY_LIST[INTEGER_64]
			user: USER
		do
			create Result.make_empty
			sorted_users := sort_user_by_uid

			from
				sorted_users.start
			until
				sorted_users.after
			loop
				user := user_at_uid (sorted_users.item)
				Result.append ("      " + user.uid.out + "->" + user.name + "%N")
				sorted_users.forth
			end

		end

	print_sorted_groups: STRING
		-- print users sorted by their uid
		local
			sorted_groups: SORTED_TWO_WAY_LIST[INTEGER_64]
			group: GROUP
		do
			create Result.make_empty
			sorted_groups := sort_group_by_gid

			from
				sorted_groups.start
			until
				sorted_groups.after
			loop
				group := i_th_group (sorted_groups.item)
				Result.append ("      " + group.gid.out + "->" + group.name + "%N")
				sorted_groups.forth
			end

		end

feature -- Helper Queries
	sort_user_by_uid: SORTED_TWO_WAY_LIST[INTEGER_64]
		-- Sort list by order of id
		local
			sorted_list: SORTED_TWO_WAY_LIST[INTEGER_64]
		do
			create sorted_list.make
			from
				users.start
			until
				users.after
			loop
				sorted_list.extend(users.item.uid)
				sorted_list.sort
				users.forth
			end

			Result := sorted_list
		end

	sort_group_by_gid: SORTED_TWO_WAY_LIST[INTEGER_64]
		-- Sort list by order of id
		local
			sorted_list: SORTED_TWO_WAY_LIST[INTEGER_64]
		do
			create sorted_list.make
			from
				groups.start
			until
				groups.after
			loop
				sorted_list.extend(groups.item.gid)
				sorted_list.sort
				groups.forth
			end

			Result := sorted_list
		end

	mid_exists (mid: INTEGER_64): BOOLEAN
		-- Returns true of mid exists
		do
			across messages as c loop
				if c.item.mid = mid then
					Result := true
				end
			end
		end

	index_of_mid (mid: INTEGER_64): INTEGER
		-- Returns the index of mid
		do
			across messages as c loop
				if c.item.mid = mid then
					Result := c.cursor_index
				end
			end
		end

	i_th_message (mid: INTEGER_64): MESSAGE
		do
			Result := messages.at (index_of_mid (mid))
		end

	gid_exists (gid: INTEGER_64): BOOLEAN
		-- Returns true if gid exists
		do
			across groups as c loop
				if c.item.gid = gid then
					Result := true
				end
			end
		end

	index_of_gid (gid: INTEGER_64): INTEGER
		-- Returns the index of gid
		do
			across groups as c loop
				if c.item.gid = gid then
					Result := c.cursor_index
				end
			end
		end

	i_th_group (gid: INTEGER_64): GROUP
		-- Get the ith group
		do
			Result := groups.at (index_of_gid (gid))
		end

	user_at_uid (uid: INTEGER_64): USER
		-- Get user by uid
		do
			Result := users.at (find_by_uid (uid))
		end

	find_by_uid (uid: INTEGER_64): INTEGER
		-- Finds the index of the user
		do
			across users as c loop
				if c.item.uid = uid then
					Result := c.cursor_index
				end
			end
		end

	uid_exists (uid: INTEGER_64): BOOLEAN
		-- Returns true if user by uid exists in the list
		do
			across users as c loop
				if c.item.uid = uid then
					Result := true
				end
			end
		end

end
