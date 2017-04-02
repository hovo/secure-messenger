note
	description: "Summary description for {GROUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GROUP

inherit
	COMPARABLE
		undefine
			out
		redefine
			is_equal,
			is_greater,
			is_greater_equal,
			is_less,
			is_less_equal
		end
	ANY
		undefine
			is_equal
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

feature -- Redefined COMPARABLE routines
	is_equal (other: like Current): BOOLEAN
		do
			Result:= Current.name.is_equal (other.name) and Current.gid.is_equal (other.gid)
		end

	is_greater alias ">" (other: like Current): BOOLEAN
		do
			if not Current.name.is_equal (other.name) then
				Result := Current.name.is_greater (other.name)
			else
				Result := Current.gid.is_greater (other.gid)
			end
		end

	is_greater_equal alias ">=" (other: like Current): BOOLEAN
		do
			Result := Current.is_equal (other) or Current.is_greater (other)
		end

	is_less alias "<" (other: like Current): BOOLEAN
		do
			if not Current.name.is_equal (other.name) then
				Result := Current.name.is_less (other.name)
			else
				Result := Current.gid.is_less (other.gid)
			end
		end

	is_less_equal alias "<=" (other: like Current): BOOLEAN
		do
			Result := Current.is_equal (other) or Current.is_less (other)
		end

end
