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
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
			add_boolean_case (agent t7)
			add_boolean_case (agent t8)
			add_boolean_case (agent t9)
			add_boolean_case (agent t10)
			add_boolean_case (agent t11)
			add_boolean_case (agent t12)
			add_boolean_case (agent t13)
			add_boolean_case (agent t14)
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
			create message.make (messenger.message_count, user1.uid, group.gid, "hello world")
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
			create message.make (messenger.message_count, user1.uid, group1.gid, "hey")
			messenger.send_message (message)
			Result := messenger.user_at_uid (user1.uid).old_messages.has (message.mid)
			Check Result end
			-- Delete message
			messenger.delete_message (user1.uid, message.mid)
			Result := not messenger.user_at_uid (user1.uid).old_messages.has (message.mid)
		end

	t5: BOOLEAN
		local
			messenger: MESSENGER
			message: MESSAGE
			group: GROUP
			user1, user2: USER
		do
			comment ("t5: read message")
			create messenger.make
			create user1.make (1, "hovo")
			create user2.make (2, "vahe")
			messenger.add_user (user1)
			messenger.add_user (user2)
			create group.make (1, "fam")
			messenger.add_group (group)
			messenger.register_user (user1.uid, group.gid)
			messenger.register_user (user2.uid, group.gid)
			create message.make (messenger.message_count, user1.uid, group.gid, "hey")
			messenger.send_message (message)

			Result := messenger.user_at_uid (user2.uid).new_messages.has (message.mid) and
					  message.read_by.has (user1.uid) and not message.read_by.has (user2.uid)
			Check Result end
			messenger.read_message (user2.uid, message.mid)
			Result := not messenger.user_at_uid (user2.uid).new_messages.has (message.mid) and
					  messenger.user_at_uid (user2.uid).old_messages.has (message.mid) and
					  message.read_by.has (user2.uid)
		end

	t6: BOOLEAN
		local
			messenger: MESSENGER
			message1, message2, message3: MESSAGE
			group: GROUP
			user1, user2: USER
		do
			comment ("t6: list new message")
			create messenger.make
			create user1.make (1, "hovo")
			create user2.make (2, "vahe")
			messenger.add_user (user1)
			messenger.add_user (user2)
			create group.make (1, "fam")
			messenger.add_group (group)
			messenger.register_user (user1.uid, group.gid)
			messenger.register_user (user2.uid, group.gid)
			create message1.make (messenger.message_count, user1.uid, group.gid, "hey")
			messenger.send_message (message1)
			create message2.make (messenger.message_count, user1.uid, group.gid, "a")
			messenger.send_message (message2)
			create message3.make (messenger.message_count, user1.uid, group.gid, "c")
			messenger.send_message (message3)
			sub_comment (messenger.list_new_messages (user2.uid))

			Result := messenger.user_at_uid (user2.uid).new_messages.at (1) = message1.mid and
					  messenger.user_at_uid (user2.uid).new_messages.at (2) = message2.mid and
					  messenger.user_at_uid (user2.uid).new_messages.at (3) = message3.mid
		end

	t7: BOOLEAN
		local
			messenger: MESSENGER
			message1, message2, message3: MESSAGE
			group: GROUP
			user1, user2: USER
		do
			comment ("t7: list old message")
			create messenger.make
			create user1.make (1, "hovo")
			create user2.make (2, "vahe")
			messenger.add_user (user1)
			messenger.add_user (user2)
			create group.make (1, "fam")
			messenger.add_group (group)
			messenger.register_user (user1.uid, group.gid)
			messenger.register_user (user2.uid, group.gid)
			create message1.make (messenger.message_count, user1.uid, group.gid, "hey")
			messenger.send_message (message1)
			create message2.make (messenger.message_count, user1.uid, group.gid, "a")
			messenger.send_message (message2)
			create message3.make (messenger.message_count, user1.uid, group.gid, "c")
			messenger.send_message (message3)
			sub_comment (messenger.list_new_messages (user2.uid))

			Result := messenger.user_at_uid (user1.uid).old_messages.at (1) = message1.mid and
					  messenger.user_at_uid (user1.uid).old_messages.at (2) = message2.mid and
					  messenger.user_at_uid (user1.uid).old_messages.at (3) = message3.mid
		end

	t8: BOOLEAN
		local
			messenger: MESSENGER
		do
			comment ("t8: update message preview length")
			create messenger.make
			Result := messenger.message_preview_length = 15
			Check Result end
			messenger.set_message_preview (10)
			Result := messenger.message_preview_length = 10
		end

	t9: BOOLEAN
		local
			messenger: MESSENGER
			group1, group2, group3, group4: GROUP
		do
			comment ("t9: list groups")
			create messenger.make
			create group1.make (5, "z")
			messenger.add_group (group1)
			create group2.make (6, "abc")
			messenger.add_group (group2)
			create group3.make (2, "abc")
			messenger.add_group (group3)
			create group4.make (1, "a")
			messenger.add_group (group4)

			sub_comment (messenger.list_groups)
			Result := true
		end

	t10: BOOLEAN
		local
			messenger: MESSENGER
			user1, user2, user3, user4: USER
		do
			comment ("t10: list users")
			create messenger.make
			create user1.make (12, "abc")
			messenger.add_user (user1)
			create user2.make (2, "a")
			messenger.add_user (user2)
			create user3.make (1, "a")
			messenger.add_user (user3)
			create user4.make (10, "abcd")
			messenger.add_user (user4)

			sub_comment(messenger.list_users)
			Result := true
		end

	t11: BOOLEAN
		local
			m1, m2, m3, m4: MESSAGE
			messenger: MESSENGER
			u: USER
			g: GROUP
		do
			comment ("t11: sorted messages")
			create messenger.make
			create u.make (1, "abc")
			messenger.add_user (u)
			create g.make (1, "g")
			messenger.add_group (g)
			messenger.register_user (u.uid, g.gid)
			create m1.make (messenger.message_count, u.uid, g.gid, "abc")
			messenger.send_message (m1)
			create m2.make (messenger.message_count, u.uid, g.gid, "ab")
			messenger.send_message (m2)
			create m3.make (messenger.message_count, u.uid, g.gid, "a")
			messenger.send_message (m3)
			create m4.make (messenger.message_count, u.uid, g.gid, "z")
			messenger.send_message (m4)

			sub_comment (messenger.list_all_messages)
			Result := true
		end

	t12: BOOLEAN
		local
			messenger: MESSENGER
			g1, g2, g3: GROUP
			u1, u2: USER
		do
			comment ("t12: print registrations")
			create messenger.make
			create g1.make (1, "family")
			messenger.add_group (g1)
			create g2.make (3, "study")
			messenger.add_group (g2)
			create g3.make (2, "personl space invaders")
			messenger.add_group (g3)

			create u1.make (4, "Diana")
			messenger.add_user (u1)
			create u2.make (2, "Diana Lee")
			messenger.add_user (u2)

			messenger.register_user (u1.uid, g1.gid)
			messenger.register_user (u2.uid, g1.gid)
			messenger.register_user (u2.uid, g2.gid)
			messenger.register_user (u2.uid, g3.gid)

			sub_comment (messenger.list_registrations)
			Result := messenger.user_at_uid (u2.uid).registered_to.count = 3 and messenger.user_at_uid (u1.uid).registered_to.count = 1
		end

	t13: BOOLEAN
		local
			messenger: MESSENGER
			g1: GROUP
			u1, u2, u3: USER
			m1, m2, m3: MESSAGE
		do
			comment ("t13: print message state")
			create messenger.make
			create g1.make (1, "fam")
			messenger.add_group (g1)
			create u1.make (1, "hovo")
			messenger.add_user (u1)
			create u2.make (2, "vahe")
			messenger.add_user (u2)
			messenger.register_user (u2.uid, g1.gid)
			create u3.make (3, "davo")
			messenger.add_user (u3)
			messenger.register_user (u1.uid, g1.gid)
			create m1.make (messenger.message_count, u1.uid, g1.gid, "hey")
			messenger.send_message (m1)
			create m2.make (messenger.message_count, u1.uid, g1.gid, "test")
			messenger.send_message (m2)
			create m3.make (messenger.message_count, u1.uid, g1.gid, "lala")
			messenger.send_message (m3)

			sub_comment (messenger.message_states)
			result := true
		end

	t14: BOOLEAN
		local
			g1, g2, g3, g4, g5: GROUP
			messenger: MESSENGER
		do
			comment ("t14: sort group by gid in ascending order")
			create messenger.make
			create g1.make (5, "abc")
			messenger.add_group (g1)
			create g2.make (4, "abc")
			messenger.add_group (g2)
			create g3.make (1, "z")
			messenger.add_group (g3)
			create g4.make (2, "ab")
			messenger.add_group (g4)
			create g5.make (9, "a")
			messenger.add_group (g5)

			sub_comment (messenger.print_sorted_groups)

			Result := messenger.sort_group_by_gid.at (1) = g3.gid and
					  messenger.sort_group_by_gid.at (2) = g4.gid and
					  messenger.sort_group_by_gid.at (3) = g2.gid and
					  messenger.sort_group_by_gid.at (4) = g1.gid and
					  messenger.sort_group_by_gid.at (5) = g5.gid
		end

end
