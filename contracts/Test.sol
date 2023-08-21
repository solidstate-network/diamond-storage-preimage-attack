// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title diamond storage library with preimage attack vulnerability
 * @notice standard Solidstate storage library, modified to use a STORAGE_SLOT which is vulnerable to attack
 */
library TestStorage {
    struct Layout {
        bool value;
    }

    // the diamond storage slot is calculated by hashing a 32-byte seed string and a 32 zero-bytes
    bytes32 internal constant STORAGE_SLOT_SEED =
        bytes32('diamond.storage.thirtytwobytestr');
    bytes32 internal constant STORAGE_SLOT =
        keccak256(abi.encodePacked(STORAGE_SLOT_SEED, bytes32(0)));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}

/**
 * @title preimage attack test contract
 * @notice demonstrates a preimage attack through an interaction between app storage and diamond storage
 */
contract Test {
    // mapping defined at storage slot 0
    mapping(bytes32 => bool) private map;

    /**
     * @notice write to storage using the mapping defined at slot 0
     */
    function writeToAppStorage() external {
        map[TestStorage.STORAGE_SLOT_SEED] = true;
    }

    /**
     * @notice write to storage using the STORAGE_SLOT defined in the TestStorage library
     */
    function writeToDiamondStorage() external {
        TestStorage.layout().value = true;
    }

    /**
     * @notice read from storage using the mapping defined at slot 0
     * @return value storage value
     */
    function readFromAppStorage() external view returns (bool value) {
        value = map[TestStorage.STORAGE_SLOT_SEED];
    }

    /**
     * @notice read from storage using the STORAGE_SLOT defined in the TestStorage library
     * @return value storage value
     */
    function readFromDiamondStorage() external view returns (bool value) {
        value = TestStorage.layout().value;
    }
}
