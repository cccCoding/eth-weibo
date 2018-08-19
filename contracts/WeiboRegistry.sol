pragma solidity ^0.4.10;

/**
    微博管理平台
 */
contract WeiboRegistry {

    //根据账户昵称，id，地址查询微博账户
    mapping(address => string) _addressToAccountName;

    mapping(uint => address) _accountIdToAddress;

    mapping(string => address) _accountNameToAddress;

    //平台注册账户数量
    uint _numberOfAccount;

    //平台管理员
    address _registryAdmin;

    //权限控制
    modifier onlyRegistryAdmin {
        require(msg.sender == _registryAdmin);
        _;
    }

    function WeiboRegistry() {
        _registryAdmin = msg.sender;
        _numberOfAccount = 0;
    }

    //在平台注册微博
    function register(string name, address accountAddress) {
        //未注册过
        require(_accountNameToAddress[name] == address(0));
        //昵称未注册过
        require(bytes(_addressToAccountName[accountAddress]).length == 0);
        //昵称限制在64字节
        require(bytes(name).length < 64);

        _addressToAccountName[accountAddress] = name;
        _accountNameToAddress[name] = accountAddress;
        _accountIdToAddress[_numberOfAccount] = accountAddress;
        _numberOfAccount++;
    }

    //查询已注册账户数量
    function getNumberOfAccounts() view returns (uint numberOfAccounts) {
        numberOfAccounts = _numberOfAccount;
    }

    //查询昵称对应微博账户地址
    function getAddressOfName(string name) view returns (address addr) {
        addr = _accountNameToAddress[name];
    }

    //查询微博账户地址对应昵称
    function getAddressOfName(address addr) view returns (string name) {
        name = _addressToAccountName[addr];
    }

    //根据id查询微博账户
    function getAddressOfId(uint id) view returns (address addr) {
        addr = _accountIdToAddress[id];
    }

    //取回打赏
    function adminRetrieveDonations() onlyRegistryAdmin {
        assert(_registryAdmin.send(this.balance));
    }

    //摧毁合约
    function adminDeleteRegistry() onlyRegistryAdmin {
        selfdestruct(_registryAdmin);
    }

    //记录每条打赏记录
    event LogDonate(address indexed from, uint256 _amount);

    //接受打赏
    function() payable {
        LogDonate(msg.sender, msg.value);
    }

}
