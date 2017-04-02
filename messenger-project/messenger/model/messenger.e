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
	users: LIST[USER]
	groups: LIST[GROUP]
	messages: LIST[MESSAGE]
	message_count: INTEGER_64
	message_preview_length: INTEGER

feature
	make
		do
			create {ARRAYED_LIST[USER]} users.make (0)
			create {ARRAYED_LIST[GROUP]} groups.make(0)
			create {ARRAYED_LIST[MESSAGE]} messages.make (0)
			message_count := message_count + 1
			message_preview_length := 15
		end

feature -- Queries
	add_user (user: USER)
		-- Add new user to users list
		require
			unique_user: not uid_exists (user.uid)
		do
			users.force (user)
		ensure
			has_user: uid_exists (user.uid)

		end

	add_group (group: GROUP)
		-- Add new group to groups list
		require
			unique_group: not gid_exists (group.gid)
		do
			groups.force (group)
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
			i_th_group (gid).users.force (uid)
			user_at_uid (uid).registered_to.force (gid)
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
			user := user_at_uid (message.sender)
			user.old_messages.extend (message.mid)
			user.old_messages.sort
			message.read_by.force (message.sender)
			messages.force (message)

			group_users := i_th_group (message.to_group).users

			from
				group_users.start
			until
				group_users.after
			loop
				loop_user := user_at_uid (group_users.item)
				loop_user.new_messages.extend (message.mid)
				loop_user.new_messages.sort

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
			not_authorized: i_th_group (i_th_message (mid).to_group).users.has (uid)
			message_unavailable: user_at_uid (uid).new_messages.has (mid)
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

	set_message_preview (length: INTEGER)
		-- updates the message preview length
		require
			valid_length: length > 0
		do
			message_preview_length := length
		end

feature -- print Queries
	list_new_messages (uid: INTEGER_64):STRING
		-- List new messages for user
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
					preview_text := message.content.substring (1, message_preview_length) + "..."
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
		-- List new messages for user
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
					preview_text := message.content.substring (1, message_preview_length) + "..."
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

feature -- Helper Queries
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
