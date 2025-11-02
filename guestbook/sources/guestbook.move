module guestbook::guestbook;

use std::string;
use std::string::String;

const MAX_MESSAGE_LENGTH: u64 = 100;

#[error]
const EInvalidMessageLength: u64 = 1;
#[error]
const EMessageTooLong: u64 = 2;


public struct Message has store, drop {
    sender: address,
    message: String,
}

public struct Guestbook has key {
    id: UID,
    no_of_messages: u64,
    messages: vector<Message>,
}

fun init(ctx: &mut tx_context::TxContext) {
    let guestbook = init_guestbook(ctx);
    sui::transfer::share_object(guestbook);
}

fun init_guestbook(ctx: &mut tx_context::TxContext): Guestbook {
    Guestbook {
        id: object::new(ctx),
        no_of_messages: 0,
        messages: vector::empty<Message>(),
    }
}

public fun add_message(
    guestbook: &mut Guestbook,
    message: Message,
) {
    vector::push_back(&mut guestbook.messages, message);
    guestbook.no_of_messages = guestbook.no_of_messages + 1;
}

public fun post_message(
    guestbook: &mut Guestbook,
    message: Message,
    operation: &String,
    ctx: &mut tx_context::TxContext,
) {
    let length: u64 = string::length(&message.message);
    assert!(length <= MAX_MESSAGE_LENGTH, EMessageTooLong);
    assert!(length > 0, EInvalidMessageLength);

    if (operation == "delete") {
        delete_messages(guestbook);
    } else {
        let new_message: Message = create_message(message.message, ctx);
        add_message(guestbook, new_message);
    }
}

public fun delete_messages(guestbook: &mut Guestbook) {
    guestbook.messages = vector::empty<Message>();
    guestbook.no_of_messages = 0;
}

public fun create_message(
    message: String, 
    ctx: &mut tx_context::TxContext
): Message {
    let sender: address = ctx.sender();
    Message {
        sender: sender,
        message: message,
    }
}
