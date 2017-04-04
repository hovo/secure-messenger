note
	description: "Summary description for {MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE

inherit
	COMPARABLE
		redefine
			is_greater,
			is_less
		end

create
	make

feature
	mid: INTEGER_64
	sender: INTEGER_64
	to_group: INTEGER_64
	content: STRING
	read_by: LIST[INTEGER_64]

feature
	make (message_id: INTEGER_64; uid: INTEGER_64; gid: INTEGER_64; text: STRING)
		-- Create message
		require
			positive_uid: uid > 0
			positive_gid: gid > 0
			not_empty_text: not text.is_empty
		do
			mid := message_id
			sender := uid
			to_group := gid
			content := text
			create {ARRAYED_LIST[INTEGER_64]} read_by.make (0)
			read_by.compare_objects
		end

feature -- Redefined COMPARABLE routines
	is_greater alias ">" (other: like Current): BOOLEAN
		do
			Result := Current.mid.is_greater (other.mid)
		end

	is_less alias "<" (other: like Current): BOOLEAN
		do
			Result := Current.mid.is_less (other.mid)
		end

end
