# Diamond Storage Preimage Attack

Proof-of-concept of a diamond storage preimage attack.

## Description

This attack can be executed by crafting a particular seed string for the purpose of calculating a diamond storage slot. This seed consists of 64 bytes and can be thought of as a string composed of two 32-byte substrings.

The first of these substrings (substring A) is human-readable:

```solidity
'diamond.storage.thirtytwobytestr'
```

Here's its hex representation:

```solidity
0x6469616d6f6e642e73746f726167652e74686972747974776f62797465737472
```

The second substring (substring B) is composed of zero-bytes and therefore has no valid string representation:

```solidity
0x0000000000000000000000000000000000000000000000000000000000000000
```

The 64-byte seed is hashed, and the result is used as the storage slot for a diamond storage struct.

Now, a mapping is defined at storage slot 0, matching the value of substring B. Accessing this mapping using substring A as a key is equivalent to accessing the diamond storage struct due to [the way mapping storage slots are calculated](https://docs.soliditylang.org/en/v0.8.21/internals/layout_in_storage.html#mappings-and-dynamic-arrays).

## Instructions

Install dependencies via Yarn:

```bash
yarn install
```

Compile contracts via Hardhat:

```bash
yarn run hardhat compile
```

Run the tests to demonstrate the attack:

```bash
yarn run hardhat test
```
