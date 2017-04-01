note
	description: "Summary description for {STUDENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT

inherit
	ES_TEST

create
	make

feature
	make
		do
			add_boolean_case (agent t0)
			add_boolean_case (agent t1)
		end

feature -- Tests
	t0: BOOLEAN
		local
			user_1: USER
			messenger: MESSENGER
		do
			comment("t0: create new user")
			create user_1.make (1, "John")
			create messenger
			messenger.add_user (user_1)
			Result := user_1.name ~ "John" and user_1.uid = 1
			Check Result end
			Result := messenger.users.has (user_1.uid)
		end

	t1: BOOLEAN
		local
			group: GROUP
			messenger: MESSENGER
		do
			comment("t1: create new group")
			create group.make (1, "study group")
			create messenger
			messenger.add_group(group)
			Result := messenger.groups.has (group.gid)

		end

end
