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
			add_boolean_case (agent t2)
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
			sub_comment(user_1.out)
			messenger.add_user (user_1)
			Result := user_1.name ~ "John" and user_1.uid = 1
			Check Result end
			Result := messenger.users.has (user_1)
		end

	t1: BOOLEAN
		local
			group: GROUP
			messenger: MESSENGER
		do
			comment("t1: create new group")
			create group.make (1, "study group")
			sub_comment(group.out)
			create messenger
			messenger.add_group(group)
			Result := messenger.groups.has (group.gid)

		end

	t2: BOOLEAN
		local
			user: USER
			group: GROUP
			messenger: MESSENGER
		do
			comment("t2: register user to group")
			create messenger
			create group.make (1, "new group")
			create user.make (1, "Jackie")
			messenger.register_user (user.uid, group.gid)
			Result := messenger.uid_exists (user.uid)
			Check Result end
			Result := messenger.users.first.registered_to.count = 1
			Check Result end
			Result := messenger.users.first.registered_to.has (group.gid)
		end

end
