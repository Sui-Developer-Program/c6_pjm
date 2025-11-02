module tip_jar_project::tip_jar_project {
    use sui::tx_context::sender;
    use sui::coin::{Coin, value};

    public struct Balance has copy, drop, store {
        amount: u64,
    }

    public struct Tips has store, drop {
        amounts: vector<Balance>,
        no_of_tips: u64,
    }

    public struct TipJar has key, store {
        id: UID,
        owner: address,
        balance: Balance,
        tips: Tips,
    }

    public fun create_empty_tip_jar(owner: address, ctx: &mut TxContext): TipJar {
        TipJar {
            id: object::new(ctx),
            owner: owner,
            balance: Balance { amount: 0 },
            tips: Tips {
                amounts: vector::empty<Balance>(),
                no_of_tips: 0,
            },
        }
    }

    fun init(ctx: &mut TxContext) {
        let jar = create_empty_tip_jar(sender(ctx), ctx);
        transfer::share_object(jar);
    }

    public fun tip(jar: &mut TipJar, tip_coin: Coin<u64>) {
        let amount = value(&tip_coin);
        transfer::public_transfer(tip_coin, jar.owner);
        add_tip(jar, amount);
    }

    public fun add_tip(jar: &mut TipJar, amount: u64) {
        jar.balance.amount = jar.balance.amount + amount;
        vector::push_back(&mut jar.tips.amounts, Balance { amount });
        jar.tips.no_of_tips = jar.tips.no_of_tips + 1;
    }
}
