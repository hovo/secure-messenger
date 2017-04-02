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

feature
	make
		do
			create {ARRAYED_LIST[USER]} users.make (0)
			create {ARRAYED_LIST[GROUP]} groups.make(0)
			create {ARRAYED_LIST[MESSAGE]} messages.make (0)
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
		do
			user_at_uid (message.sender).old_messages.force (message.mid)
			message.read_by.force (message.sender)
			messages.force (message)

			group_users := i_th_group (message.to_group).users

			from
				group_users.start
			until
				group_users.after
			loop
				user_at_uid (group_users.item).new_messages.force (message.mid)
				group_users.forth
			end
		ensure
			is_read: message.read_by.has (message.sender)
		end

	delete_message (uid: INTEGER_64; mid: INTEGER_64)
		-- delete message from list
		require
			positive_uid: uid > 0
			positive_mid: mid > 0
			user_exists: uid_exists (uid)
			message_exists: mid_exists (mid)
			-- TODO: new/old
		do
			-- Remove from senders old list

			--user_at_uid (uid).old_messages.search (i_th_message (mid).sender).remove


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
