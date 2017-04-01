note
	description: "Summary description for {MESSENGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSENGER

feature
	-- List of users
	users: HASH_TABLE[USER, INTEGER_64]
		once
			create Result.make(0)
		end

	-- List of groups
	groups: HASH_TABLE[GROUP, INTEGER_64]
		once
			create Result.make(0)
		end

feature -- Queries
	add_user (user: USER)
		-- Add user to users list
	require
		unique_user: not users.has (user.uid)
	do
		users.extend (user, user.uid)
	ensure
		has_user: users.has (user.uid)

	end

end
