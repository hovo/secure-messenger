note
	description: "Summary description for {USER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER

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

feature -- Attributes
	uid: INTEGER_64
	name: STRING
		attribute
			create Result.make_empty
		end
	registered_to: SORTED_TWO_WAY_LIST[INTEGER_64]
	new_messages: SORTED_TWO_WAY_LIST[INTEGER_64]
	old_messages: SORTED_TWO_WAY_LIST[INTEGER_64]

feature
	make (user_id: INTEGER_64; user_name: STRING)
	-- Create a user
		require
			positive_uid: user_id > 0
			valid_user_name: user_name.count > 0 and user_name.at (1).is_alpha

		do
			uid := user_id
			name := user_name
			create registered_to.make
			create new_messages.make
			create old_messages.make
		end

feature
	out: STRING
		-- print user
		local
			format: STRING
		do
			format := uid.out + "->" + name
			Result := format
		end

	set_new_messages(msgs: SORTED_TWO_WAY_LIST[INTEGER_64])
		do
			new_messages := msgs
		end

	set_old_messages(msgs: SORTED_TWO_WAY_LIST[INTEGER_64])
		do
			old_messages := msgs
		end

feature -- Redefined COMPARABLE routines
	is_equal (other: like Current): BOOLEAN
		do
			Result:= Current.name.is_equal (other.name) and Current.uid.is_equal (other.uid)
		end

	is_greater alias ">" (other: like Current): BOOLEAN
		do
			if not Current.name.is_equal (other.name) then
				Result := Current.name.is_greater (other.name)
			else
				Result := Current.uid.is_greater (other.uid)
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
				Result := Current.uid.is_less (other.uid)
			end
		end

	is_less_equal alias "<=" (other: like Current): BOOLEAN
		do
			Result := Current.is_equal (other) or Current.is_less (other)
		end

end
