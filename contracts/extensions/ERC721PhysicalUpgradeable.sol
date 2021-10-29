// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @dev ERC721 upgradeable token linked to a physical asset,
 */
abstract contract ERC721PhysicalUpgradeable is Initializable, ERC721Upgradeable {
    function __ERC721Physical_init() internal initializer {
        __Context_init_unchained();
        __ERC165_init_unchained();
        __ERC721Physical_init_unchained();
    }

    function __ERC721Physical_init_unchained() internal initializer {
    }
    using StringsUpgradeable for uint256;    

    // Struct for minimum device information.
    struct Device { 
       string publicKeyHash;
       string merkleRoot;
       bytes32 publicKeyHash;
       bytes32 merkleRoo;
    }

    // The device registry.
    address public _registryAddress;

    // Optional mapping for deivce IDs and and device roots.
    mapping(uint256 => Device) private _devices;

    event UpdateRegistry(address registryAddress);
    event DeviceSet(
        uint256 tokenId,
        bytes32 publicKeyHash,
        bytes32 merkleRoot
    );

    /**
     * @dev Get a deviceId for a given tokenId.
     */
    function deviceId(uint256 tokenId) public view virtual returns(bytes32) {
        require(_exists(tokenId), "Device ID query for nonexistant token");

        bytes32 _deviceId = _devices[tokenId].publicKeyHash;
        return _deviceId;
    }

    /**
     * @dev Get a deviceRoot for a given tokenId.
     */
    function deviceRoot(uint256 tokenId) public view virtual returns(bytes32) {
        require(_exists(tokenId), "Device root query for nonexistant token");

        bytes32 _deviceRoot = _devices[tokenId].merkleRoot;
        return _deviceRoot;
    }

    /**
     * @dev Set token-wide registry address.
     */
    function _setRegistryAddress(address registryAddress) internal virtual {
         _registryAddress = registryAddress;
        emit UpdateRegistry(_registryAddress);
    }

    /**
     * @dev Set a deviceRoot for a given tokenId.
     */
    function _setDevice(uint256 tokenId, bytes32 publicKeyHash, bytes32 merkleRoot) internal virtual {
        require(_exists(tokenId), "Device set for nonexistant token");
        _devices[tokenId].publicKeyHash = publicKeyHash;
        _devices[tokenId].merkleRoot = merkleRoot;
        emit DeviceSet(tokenId, publicKeyHash, merkleRoot);
    }

    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (_devices[tokenId].publicKeyHash.length != 0) {
            delete _devices[tokenId];
        }
    }
    uint256[47] private __gap;
}