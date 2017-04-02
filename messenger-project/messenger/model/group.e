note
	description: "Summary description for {GROUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GROUP

inherit
	ANY
		redefine
			out
		end

create
	make

feature -- attributes
	gid: INTEGER_64
	name: STRING
	users: LIST[INTEGER_64]

feature
	make (group_id: INTEGER_64; group_name: STRING)
	-- Create a new group
	require
		positive_gid: group_id > 0
		valid_group_name: group_name.count > 0 and group_name.at (1).is_alpha
	do
		gid := group_id
		name := group_name
		create {ARRAYED_LIST[INTEGER_64]} users.make (0)
	end

feature
	out: STRING
		-- Print group
		local
			format: STRING
		do
			format := gid.out + "->" + name
			Result := format
		end

end
