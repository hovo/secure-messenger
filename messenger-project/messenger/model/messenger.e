note
	description: "Summary description for {MESSENGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSENGER

feature
	-- List of users
	users: LIST[USER]
		once
			create {ARRAYED_LIST[USER]} Result.make (02)
		end

	-- List of groups
	groups: HASH_TABLE[GROUP, INTEGER_64]
		once
			create Result.make(0)
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
			unique_group: not groups.has (group.gid)
		do
			groups.extend (group, group.gid)
		ensure
			has_group: groups.has (group.gid)
		end

	register_user (uid: INTEGER_64; gid: INTEGER_64)
		-- Register a user to a group
		require
			positive_uid: uid > 0
			positive_gid: gid > 0
			user_id_exists: uid_exists (uid)
			gid_exists: groups.has (gid)
			new_registration: not users.at (find_by_uid (uid)).registered_to.has (gid)

		do
			users.at (find_by_uid (uid)).registered_to.force (gid)
		ensure
			registered: users.at (find_by_uid (uid)).registered_to.has (gid)
		end

	send_message (message: MESSAGE)
		-- send message to gid
		require
			user_id_exists: uid_exists (message.sender)
			group_id_exists: groups.has (message.to_group)
			-- TODO: User not authorized to send messages to the specified group.
		do
			-- TODO: add message to group
		end

feature -- Helper
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
