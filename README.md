# Sui Move Modules

## Guestbook Module
A decentralized guestbook system where users can post and view messages.

**Features:**
- Post messages (max 100 characters)
- Delete all messages
- Track message count and sender addresses
- Shared object accessible to all users

**Key Functions:**
- `post_message()` - Add new message with validation
- `delete_messages()` - Clear all messages
- `create_message()` - Create message struct

## Tip Jar Module  
A decentralized tipping system where users can send tips to jar owners.

**Features:**
- Create personal tip jars
- Receive tips in SUI coins
- Track tip history and balances
- Automatic transfer to jar owner

**Key Functions:**
- `create_empty_tip_jar()` - Initialize new tip jar
- `tip()` - Send tip to jar owner
- `add_tip()` - Record tip transaction

Both modules use shared objects for decentralized access and include proper error handling.
