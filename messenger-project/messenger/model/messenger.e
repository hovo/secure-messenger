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
	-- List of users
	users: LIST[USER]

	-- List of groups
	groups: HASH_TABLE[GROUP, INTEGER_64]


feature
	make
		do
			create {ARRAYED_LIST[USER]} users.make (0)
			create groups.make(0)
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
			new_registration: not user_at_uid (uid).registered_to.has (gid)

		do
			user_at_uid (uid).registered_to.force (gid)
		ensure
			registered: user_at_uid (uid).registered_to.has (gid)
		end

	send_message (message: MESSAGE)
		-- send message to gid
		require
			user_id_exists: uid_exists (message.sender)
			group_id_exists: groups.has (message.to_group)
			user_in_group: user_at_uid (message.sender).registered_to.has (message.to_group)
		local
			user: USER
		do
			 user_at_uid (message.sender).read.force (message.mid)
			 from
			 	users.start
			 until
			 	users.after
			 loop
			 	user := users.item
			 	if user.registered_to.has (message.to_group) and user.uid /= message.sender then
			 		user.unread.force (message.mid)
			 	end
			 	users.forth
			 end

		ensure
			in_read: user_at_uid (message.sender).read.has (message.mid)
			--in_unread: users.at (find_by_uid (uid)).read.force (message.mid)
		end


feature -- Helper
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
