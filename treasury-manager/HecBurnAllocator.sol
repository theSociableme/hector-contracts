// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    // function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
    //     require(address(this).balance >= value, "Address: insufficient balance for call");
    //     return _functionCallWithValue(target, data, value, errorMessage);
    // }
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }

  /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }

    function addressToString(address _address) internal pure returns(string memory) {
        bytes32 _bytes = bytes32(uint256(_address));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _addr = new bytes(42);

        _addr[0] = '0';
        _addr[1] = 'x';

        for(uint256 i = 0; i < 20; i++) {
            _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
            _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }

        return string(_addr);

    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function decimals() external view returns(uint8);
    function burn(uint256 amount) external;
}
interface IOwnable {
  function policy() external view returns (address);

  function renounceManagement() external;
  
  function pushManagement( address newOwner_ ) external;
  
  function pullManagement() external;
}

contract Ownable is IOwnable {

    address internal _owner;
    address internal _newOwner;

    event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
    event OwnershipPulled(address indexed previousOwner, address indexed newOwner);

    constructor () {
        _owner = msg.sender;
        emit OwnershipPushed( address(0), _owner );
    }

    function policy() public view override returns (address) {
        return _owner;
    }

    modifier onlyPolicy() {
        require( _owner == msg.sender, "Ownable: caller is not the owner" );
        _;
    }

    function renounceManagement() public virtual override onlyPolicy() {
        emit OwnershipPushed( _owner, address(0) );
        _owner = address(0);
    }

    function pushManagement( address newOwner_ ) public virtual override onlyPolicy() {
        require( newOwner_ != address(0), "Ownable: new owner is the zero address");
        emit OwnershipPushed( _owner, newOwner_ );
        _newOwner = newOwner_;
    }
    
    function pullManagement() public virtual override {
        require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
        emit OwnershipPulled( _owner, _newOwner );
        _owner = _newOwner;
    }
}

interface ITreasury {
    function deposit( uint _amount, address _token, uint _profit ) external returns ( uint send_ );
    function manage( address _token, uint _amount ) external;
    function valueOf( address _token, uint _amount ) external view returns ( uint value_ );
    function isLiquidityToken( address _token ) external view returns (bool) ;
    function isReserveToken( address _token ) external view returns (bool) ;
}

interface IUniswapRouter{
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
}
interface IPair{
    function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
    function token0() external view returns (address);
    function token1() external view returns (address);
}
interface ICurvePool{
    function get_dy(int128 i, int128 j, uint _dx) external view returns(uint);
    function exchange(int128 i, int128 j, uint _dx, uint _min_dy) external returns(uint);
}
interface IBackingCalculator{
    function backing() external view returns (uint lpBacking, uint treasuryBacking);
}

/**
 *  Contract deploys reserves from treasury and send to ethereum allocator contract through anysway router,
 */

contract HecBurnAllocator is Ownable {

    /* ======== DEPENDENCIES ======== */

    using SafeERC20 for IERC20;
    using SafeMath for uint;



    /* ======== STRUCTS ======== */

    struct tokenData {
        address token;
        uint tokenSpent;
        uint stableSpent;
        uint hecBought;
        uint hecBurnt;
        uint transactionLimit;
        uint limit;
        uint newLimit;
        uint limitChangeTimelockEnd;
    }



    /* ======== STATE VARIABLES ======== */

    ITreasury public immutable treasury; // Treasury
    string public name;
    

    mapping( address => tokenData ) public tokenInfo; // info for reserve token to burn hec

    uint public totalBought; // total hec bought
    uint public totalBurnt; // total hec burnt

    uint public immutable timelockInBlocks; // timelock to raise deployment limit

    bool public enableSendback;

    address public immutable hec=0x5C4FDfc5233f935f20D2aDbA572F770c2E377Ab0;

    address public immutable dai=0x8D11eC38a3EB5E956B052f67Da8Bdc9bef8Abf3E;
    address public immutable usdc=0x04068DA6C83AFCFA0e13ba15A6696662335D5B75;
    address public immutable daiHec=0xbc0eecdA2d8141e3a26D2535C57cadcb1095bca9;
    address public immutable usdcHec=0xd661952749f05aCc40503404938A91aF9aC1473b;
    address public immutable spooky=0xF491e7B69E4244ad4002BC14e878a34207E38c29;
    address public immutable spirit=0x16327E3FbDaCA3bcF7E38F5Af2599D2DDc33aE52;
    
    ICurvePool constant daiUsdc=ICurvePool(0x27E611FD27b276ACbd5Ffd632E5eAEBEC9761E40);
    address public backingCalculator;
    uint public premium;
    

    /* ======== CONSTRUCTOR ======== */

    constructor ( 
        string memory name_,
        address _treasury,
        address _backingCalculator,
        uint _timelockInBlocks
    ) {
        require( _treasury != address(0) );
        treasury = ITreasury( _treasury );

        require(_backingCalculator!=address(0));
        backingCalculator=_backingCalculator;
        
        timelockInBlocks = _timelockInBlocks;

        enableSendback = true;

        name=name_;
    }



    /* ======== OPEN FUNCTIONS ======== */

    /* ======== POLICY FUNCTIONS ======== */

    /**
     *  @notice withdraws asset from treasury, transfer out to other chain through 
     *  @param token address either usdc or dai
     *  @param amount uint amount of stable coin
     */
    function burnAsset( address token, uint amount ) public onlyPolicy() {
        require(token==dai||token==usdc,"only support buyback with usdc or dai");
        require( !exceedsLimit( token, amount ),"deposit amount exceed limit" ); // ensure deposit is within bounds
        require(!exceedsTransactionLimit(token,amount),"transaction amount too large");
        require(priceMeetCriteria()==true,"price doesn't meet buy back criteria");
        treasury.manage( token, amount ); // retrieve amount of asset from treasury
        uint daiAmount;
        if(token==usdc){
            IERC20(token).approve(address(daiUsdc),amount);
            daiAmount=daiUsdc.exchange(1,0,amount,0);
        }else{
            daiAmount=amount;
        }

        address[] memory path=new address[](2);
        path[0]=dai;
        path[1]=hec;
        IERC20(dai).approve(spooky, daiAmount); // approve uniswap router to spend dai
        uint[] memory amountOuts=IUniswapRouter(spooky).swapExactTokensForTokens(daiAmount,1,path,address(this),block.timestamp);
        uint bought=amountOuts[1];

        IERC20(hec).burn(bought);
        
        // account for burn
        accountingFor( token, amount, amount, bought, bought );
    }

    /**
     *  @notice withdraws asset from treasury, transfer out to other chain through 
     *  @param token address either usdc or dai
     *  @param amount uint amount of stable coin
     */
    function burnLp( address token, uint amount ) public onlyPolicy() {
        require(token==dai||token==usdc,"only support buyback with usdc or dai lp");
        address lpToken;
        address router;
        if(token==dai) {
            lpToken=daiHec;
            router=spooky;
        }else{
            lpToken=usdcHec;
            router=spirit;
        }
        require( !exceedsLimit( lpToken, amount ),"deposit amount exceed limit" ); // ensure deposit is within bounds
        require(!exceedsTransactionLimit(lpToken,amount),"transaction amount too large");
        (,uint stableReserve)=hecStableAmount(IPair(lpToken));
        uint lpAmount=amount.mul(IERC20(lpToken).totalSupply()).div(stableReserve);
        treasury.manage( lpToken, lpAmount ); // retrieve amount of asset from treasury
        IERC20(lpToken).approve(router,lpAmount);
        (uint stableAmount,uint hecAmount)=
        IUniswapRouter(router).removeLiquidity(
            token,
            hec,
            lpAmount,
            0,
            0,
            address(this),
            block.timestamp
        );

        address[] memory path=new address[](2);
        path[0]=token;
        path[1]=hec;
        IERC20(token).approve(router, stableAmount); // approve uniswap router to spend dai
        uint[] memory amountOuts=IUniswapRouter(router).swapExactTokensForTokens(stableAmount,1,path,address(this),block.timestamp);
        uint bought=amountOuts[1];

        IERC20(hec).burn(bought.add(hecAmount));
        
        // account for burn
        accountingFor( lpToken, lpAmount, stableAmount, bought, bought.add(hecAmount) );
    }

    function disableSendback() external onlyPolicy{
        enableSendback=false;
    }

    function sendBack(address _token) external onlyPolicy {
        require(enableSendback==true,"send back token is disabled");
        //require(tokenInfo[_token].underlying==address(0),"only none registered token can be sent back");
        uint amount = IERC20(_token).balanceOf(address(this));
        IERC20(_token).safeTransfer(policy(),amount);
    }

    /**
     *  @notice adds asset token
     *  @param token address
     *  @param max uint
     *  @param transactionLimit uint
     */
    function addToken( address token, uint max ,uint transactionLimit) external onlyPolicy() {
        require(token==dai||token==usdc||token==daiHec||token==usdcHec,"principle token invalid");
        require( tokenInfo[ token ].stableSpent == 0 ,"token is burnt already, can't re-register"); 

        tokenInfo[ token ] = tokenData({
            token: token,
            tokenSpent: 0,
            stableSpent: 0,
            hecBought: 0,
            hecBurnt: 0,
            transactionLimit: transactionLimit,
            limit: max,
            newLimit: 0,
            limitChangeTimelockEnd: 0
        });
    }


    /**
     *  @notice lowers max can be deployed for asset (no timelock)
     *  @param token address
     *  @param newMax uint
     */
    function lowerLimit( address token, uint newMax ) external onlyPolicy() {
        require( newMax < tokenInfo[ token ].limit );
        require( newMax > tokenInfo[ token ].stableSpent ); // cannot set limit below what has been deployed already
        tokenInfo[ token ].limit = newMax;
        tokenInfo[ token ].newLimit = 0;
        tokenInfo[ token ].limitChangeTimelockEnd = 0;
    }

    /**
     *  @notice starts timelock to raise max allocation for asset
     *  @param token address
     *  @param newMax uint
     */
    function queueRaiseLimit( address token, uint newMax ) external onlyPolicy() {
        require(newMax>tokenInfo[ token ].limit,"new max must be greater than current limit");
        tokenInfo[ token ].limitChangeTimelockEnd = block.number.add( timelockInBlocks );
        tokenInfo[ token ].newLimit = newMax;
    }

    /**
     *  @notice changes max allocation for asset when timelock elapsed
     *  @param token address
     */
    function raiseLimit( address token ) external onlyPolicy() {
        require( block.number >= tokenInfo[ token ].limitChangeTimelockEnd, "Timelock not expired" );
        require( tokenInfo[ token ].limitChangeTimelockEnd != 0, "Timelock not started" );

        tokenInfo[ token ].limit = tokenInfo[ token ].newLimit;
        tokenInfo[ token ].newLimit = 0;
        tokenInfo[ token ].limitChangeTimelockEnd = 0;
    }

    function setTransactionLimit(address token, uint transactionLimit) external onlyPolicy(){
        require(tokenInfo[token].token!=address(0),"unregistered token");
        tokenInfo[token].transactionLimit=transactionLimit;
    }

    /* ======== INTERNAL FUNCTIONS ======== */

    /**
     *  @notice accounting of deposits/withdrawals of assets
     *  @param token address
     *  @param tokenSpent uint
     *  @param stableSpent uint
     *  @param hecBought uint
     */
    function accountingFor( address token, uint tokenSpent, uint stableSpent, uint hecBought, uint hecBurnt ) internal {
        tokenInfo[ token ].tokenSpent = tokenInfo[ token ].tokenSpent.add( tokenSpent ); // track amount allocated into pool
        tokenInfo[ token ].stableSpent = tokenInfo[ token ].stableSpent.add( stableSpent );
        tokenInfo[ token ].hecBought = tokenInfo[ token ].hecBought.add(hecBought);
        tokenInfo[ token ].hecBurnt = tokenInfo[ token ].hecBurnt.add(hecBurnt);
        totalBurnt = totalBurnt.add( hecBurnt );
        totalBought = totalBought.add( hecBought );
    }


    /* ======== VIEW FUNCTIONS ======== */

    /**
     *  @notice checks to ensure deposit does not exceed max allocation for asset
     *  @param token address
     *  @param stableSpent uint
     */
    function exceedsLimit( address token, uint stableSpent ) public view returns ( bool ) {
        uint willSpent = tokenInfo[ token ].stableSpent.add( stableSpent );

        return ( willSpent > tokenInfo[ token ].limit );
    }

    function exceedsTransactionLimit(address token, uint stableSpent) public view returns(bool){
        return stableSpent>tokenInfo[token].transactionLimit;
    }

    function setPremium(uint _premium) external onlyPolicy{
        require(_premium<11,"price premium must be in range of 0 to 10");
        premium=_premium;
    }

    function priceMeetCriteria() public view returns (bool){
        //backingPerHec decimals = 4, 101.23$ = 1012300, 75.8321$ = 758321
        (uint lpBacking, uint treasuryBacking) = IBackingCalculator(backingCalculator).backing();
        return treasuryBacking>lpBacking.mul(premium.add(100)).div(100);
    }
    function hecStableAmount( IPair _pair ) public view returns ( uint hecReserve,uint stableReserve){
        ( uint reserve0, uint reserve1, ) =  _pair .getReserves();
        if ( _pair.token0() == hec ) {
            hecReserve=reserve0;
            stableReserve=reserve1;
        } else {
            hecReserve=reserve1;
            stableReserve=reserve0;
        }
    }
}
