// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function mint(address account, uint256 value) external;
    function burn(address account, uint256 value) external;
}

contract ERC20 is IERC20 {
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    address private _owner;

    constructor() {
        _totalSupply = 10000;  // 總發行量: 10000 個token
        _balances[msg.sender] = 10000;  // 將以太幣持有者的賬戶新增10000 顆token
        _owner = msg.sender;
    }

    modifier checkOwner() {
        require(_owner == msg.sender, unicode"不是合約擁有者");
        _;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) external override returns (bool) {
        require(_balances[msg.sender] >= value, unicode"餘額不足");
        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) external override returns (bool) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external override returns (bool) {
        require(_balances[from] >= value, unicode"餘額不足");
        require(_allowances[from][msg.sender] >= value, unicode"許可權不足");
        _balances[from] -= value;
        _balances[to] += value;
        _allowances[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function mint(address account, uint256 value) external override checkOwner {
        require(account != address(0), unicode"address不能是0x0");  // 檢查帳戶不能是0x0
        _totalSupply += value;  // 增加總發行量
        _balances[account] += value;  // 增加目標賬戶餘額
        emit Transfer(address(0), account, value);  // 無中生有(address(0)=>account): (address(0), 指定帳戶, 多少代幣)
    }

    function burn(address account, uint256 value) external override checkOwner {
        uint256 accountBalance = _balances[account];  // 確認賬戶餘額
        require(account != address(0), unicode"address不能是0x0");  // 檢查帳戶不能是0x0
        require(accountBalance >= value, unicode"餘額不足");  // 檢查餘額夠不夠燒毀
        _balances[account] = accountBalance - value;  // 指定賬戶銷毀代幣
        _totalSupply = _totalSupply - value;  // 總發行量也會跟著減少
        emit Transfer(account, address(0), value);  // 回歸虛無(account=>address(0)): (指定賬戶, address(0), 多少代幣)
    }
}