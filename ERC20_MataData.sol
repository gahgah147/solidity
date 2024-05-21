// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20Metadata {
    function name() external view returns (string memory); // 代幣名稱
    function symbol() external view returns (string memory); // 代幣符號
    function decimals() external view returns (uint8); // 代幣小數點位置
}

contract ERC20 is IERC20Metadata {
    string _name;
    string _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    // 查詢代幣名稱
    function name() public view returns (string memory) {
        return _name;
    }

    // 查詢代幣符號
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    // 代幣小數點位置
    function decimals() public pure returns (uint8) {
        return 18;
    }
}