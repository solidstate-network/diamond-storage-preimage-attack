// SPDX-License-Identifier: TODO

pragma solidity ^0.8.0;

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

contract Test {
    // mapping defined at slot equal to TestStorage.STORAGE_SLOT_SUFFIX
    mapping(bytes32 => bool) private map;

    function setToAppStorage() external {
        map[TestStorage.STORAGE_SLOT_PREFIX] = true;
    }

    function setToDiamondStorage() external {
        TestStorage.layout().value = true;
    }

    function getFromAppStorage() external view returns (bool value) {
        value = map[TestStorage.STORAGE_SLOT_PREFIX];
    }

    function getFromDiamondStorage() external view returns (bool value) {
        value = TestStorage.layout().value;
    }
}
