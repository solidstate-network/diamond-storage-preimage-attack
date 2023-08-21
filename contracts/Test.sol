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

    // the diamond storage slot is calculated by hashing a seed string
    // the seed string in this case is composed of a 32-byte human-readable string, and an arbitrary 32-byte value
    bytes32 internal constant STORAGE_SLOT_PREFIX =
        bytes32('diamond.storage.thirtytwobytestr');
    bytes32 internal constant STORAGE_SLOT_SUFFIX = bytes32(0);
    bytes32 internal constant STORAGE_SLOT =
        keccak256(abi.encodePacked(STORAGE_SLOT_PREFIX, STORAGE_SLOT_SUFFIX));

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
    // mapping defined at slot equal to TestStorage.STORAGE_SLOT_SUFFIX
    mapping(bytes32 => bool) private map;

    /**
     * @notice write to storage using the mapping defined at slot 0
     */
    function writeToAppStorage() external {
        map[TestStorage.STORAGE_SLOT_PREFIX] = true;
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
        value = map[TestStorage.STORAGE_SLOT_PREFIX];
    }

    /**
     * @notice read from storage using the STORAGE_SLOT defined in the TestStorage library
     * @return value storage value
     */
    function readFromDiamondStorage() external view returns (bool value) {
        value = TestStorage.layout().value;
    }
}
