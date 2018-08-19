pragma solidity ^0.4.10;

/**
    微博账号
 */
contract WeiboAccount {

    //微博结构体
    struct Weibo {
        uint timestamp;
        string weiboString;
    }

    //这个账户所有博客，微博id映射微博内容
    mapping(uint => Weibo) _weibos;

    //该账户下微博数量
    uint _numOfWeibos;

    //微博所有者
    address _adminAddress;

    //权限控制
    modifier onlyAdmin {
        require(msg.sender == _adminAddress);
        _;
    }

    function WeiboAccount() {
        _numOfWeibos = 0;
        _adminAddress = msg.sender;
    }

    //发送微博方法
    function weibo(string weiboString) {
        require(bytes(weiboString).length <= 160);  //限制内容在160字节以下

        _weibos[_numOfWeibos].timestamp = now;
        _weibos[_numOfWeibos].weiboString = weiboString;
        _numOfWeibos++;
    }

    //根据id查找微博
    function getWeibo(uint weiboId) view returns (string weiboString, uint timestamp) {
        weiboString = _weibos[weiboId].weiboString;
        timestamp = _weibos[weiboId].timestamp;
    }

    //查询最新一条微博
    function getLatestWeibo() view returns (string weiboString, uint timestamp, uint numberOfWeibos) {
        weiboString = _weibos[_numOfWeibos - 1].weiboString;
        timestamp = _weibos[_numOfWeibos - 1].timestamp;
        numberOfWeibos = _numOfWeibos;
    }

    //查询微博所有者地址
    function getOwnerAddress() view returns (address adminAddress) {
        return _adminAddress;
    }

    //查询微博总数
    function getNumberOfWeibos() view returns (uint numberOfWeibos) {
        return _numOfWeibos;
    }

    //取回打赏
    function adminRetrieveDonations(address receiver) onlyAdmin {
        assert(receiver.send(this.balance));
    }

    //摧毁合约
    function adminDeleteAccount() onlyAdmin {
        selfdestruct(_adminAddress);
    }

    //记录每条打赏记录
    event LogDonate(address indexed from, uint256 _amount);

    //接受打赏
    function() payable {
        LogDonate(msg.sender, msg.value);
    }
    
}
