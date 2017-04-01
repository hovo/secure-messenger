note
	description: "Summary description for {MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE

create
	make

feature
	mid: INTEGER_64
	sender: INTEGER_64
	to_group: INTEGER_64
	content: STRING

feature
	make (uid: INTEGER_64; gid: INTEGER_64; text: STRING)
		-- Create message
		require
			positive_uid: uid > 0
			positive_gid: gid > 0
			not_empty_text: not text.is_empty
		do
			mid := mid + 1
			sender := uid
			to_group := gid
			content := text
		ensure
			increment_mid: mid = old mid + 1
		end

end
