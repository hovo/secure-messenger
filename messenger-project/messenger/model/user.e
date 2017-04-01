note
	description: "Summary description for {USER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER

inherit
	ANY
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
	registered_to: LIST[INTEGER_64]
	--test: COLLECTION_SORTER[INTEGER_64]

feature
	make (user_id: INTEGER_64; user_name: STRING)
	-- Create a user
		require
			positive_uid: user_id > 0
			valid_user_name: user_name.count > 0 and user_name.at (1).is_alpha

		do
			uid := user_id
			name := user_name
			create {ARRAYED_LIST[INTEGER_64]} registered_to.make (0)
		end

feature
	out: STRING
		-- print user
		local
			format: STRING
		do
			create Result.make_empty
			format := uid.out + "->" + name
			Result.append (format)
		end

end
