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
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
		end

feature -- Tests
	t0: BOOLEAN
		local
			user_1: USER
			messenger: MESSENGER
		do
			comment("t0: create new user")
			create user_1.make (1, "John")
			create messenger.make
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
			create messenger.make
			messenger.add_group(group)
			Result := messenger.gid_exists (group.gid)
		end

	t2: BOOLEAN
		local
			user: USER
			group: GROUP
			messenger: MESSENGER
		do
			comment("t2: register user to group")
			-- Create messenger
			create messenger.make
			-- Create user
			create user.make (1, "Jackie")
			-- Add user
			messenger.add_user (user)
			-- Create group
			create group.make (1, "new group")
			-- Add group
			messenger.add_group (group)
			-- Register user to goup
			messenger.register_user (user.uid, group.gid)
			-- Check result
			Result := messenger.uid_exists (user.uid)
			Check Result end
			Result := group.users.has (user.uid)
		end

	t3: BOOLEAN
		local
			user1, user2: USER
			messenger: MESSENGER
			message: MESSAGE
			group: GROUP
		do
			comment("t3: send message")
			-- initialize messenger
			create messenger.make
			-- create users
			create user1.make (1, "hovo")
			create user2.make (2, "vahe")
			-- Add users
			messenger.add_user (user1)
			messenger.add_user (user2)
			-- create group
			create group.make (1, "study group")
			-- Add group
			messenger.add_group (group)
			-- register users to group
			messenger.register_user (user1.uid, group.gid)
			messenger.register_user (user2.uid, group.gid)
			-- create a message
			create message.make (user1.uid, group.gid, "hello world")
			-- send messge to group
			messenger.send_message (message)
			Result := message.read_by.has (user1.uid)
		end

	t4: BOOLEAN
		local
			messenger: MESSENGER
			group1, group2: GROUP
			message: MESSAGE
			user1, user2: USER
		do
			comment ("t4: test delete message")
			-- create messenger
			create messenger.make
			-- Create groups & add
			create group1.make (1, "g1")
			create group2.make (2, "g2")
			messenger.add_group (group1)
			messenger.add_group (group2)
			-- Create users & add
			create user1.make (1, "hovo")
			create user2.make (2, "vahe")
			messenger.add_user (user1)
			messenger.add_user (user2)
			-- Register users to group
			messenger.register_user (user1.uid, group1.gid)
			messenger.register_user (user2.uid, group2.gid)
			-- Create message and send
			create message.make (user1.uid, group1.gid, "hey")
			messenger.send_message (message)
			Result := messenger.user_at_uid (user1.uid).old_messages.has (message.mid)
			Check Result end
			-- Delete message
			messenger.delete_message (user1.uid, message.mid)
			Result := not messenger.user_at_uid (user1.uid).old_messages.has (message.mid)
		end

end
