note
	description: "Summary description for {GROUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GROUP

create
	make

feature -- attributes
	gid: INTEGER_64
	name: STRING

feature
	make (group_id: INTEGER_64; group_name: STRING)
	-- Create a new group
	require
		positive_gid: group_id > 0
		valid_group_name: group_name.count > 0 and group_name.at (1).is_alpha
	do
		gid := group_id
		name := group_name
	end

end
