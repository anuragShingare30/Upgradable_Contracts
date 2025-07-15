# Upgradeable contracts

1. **Using upgradeable contracts library** 
    - If using external libraries like `Openzeppelin`, the contracts should be `upgradeable`
    - **Example**: USe `ERC20Upgradeable` instead of `ERC20 contract`


2. **Initializer function and initializer modifier**
    - When using `OpenZeppelin Upgrades contract no constructor should be used to initialize the states`
    - instead we use function name `initialize`, where you run all the setup logic

    ```solidity
    contract UpgradeableContract is Initializable, OwnableUpgradeable, UUPSUpgradeable {
        uint256 internal value;

        constructor() {
            _disableInitializers(); // locks the contract to prevent re-initialization
        }

        /// @dev all setup will be in initialize function instead of constructor
        /// @dev initialize() function should be called by owner just after deployment
        /// @dev failure to initialize will lead to exploit
        function initialize(uint256 _value) public initializer {
            __Ownable_init();
            __UUPSUpgradeable_init();
            value = _value;
        }
    }
    ```




3. **Parent contracts contains an onlyInitializing modifier**:
    - `Inherited/Parent/Base` contracts should have an `initializer function __Parent_init()` that includes `onlyInitializing` modifier

    ```solidity
    /// @dev Parent contract that should contain parent initializer function [__Parent_init()] that contains [onlyInitializing modifier]
    contract ParentContractUpgradeable is Initializable {
        uint256 public value;

        function __ParentContract_init(uint256 _value) internal onlyInitializing {
            __ParentContract_init_unchained(_value);
        }

        function __ParentContract_init_unchained(uint256 _value) internal onlyInitializing {
            value = _value;
        }
    }

    /// @dev Upgradeable contract should implement the parent initializer function compulsorily
    contract UpgradeableContract is Initializable, OwnableUpgradeable, UUPSUpgradeable, ParentContractUpgradeable {
        constructor() {
            _disableInitializers(); // locks the contract to prevent re-initialization
        }

        function initialize(uint256 _value) public initializer {
            __Ownable_init(); // parent contract that contains onlyIntializing modifier
            __UUPSUpgradeable_init();
            __ParentContract_init(tswapAddress); // parent contract that contains onlyIntializing modifier
        }
    }
    ```


   
4. **Initializing Implementation contract**
   - Do not leave an` implementation contract uninitialized`
   -  An uninitialized implementation contract can be taken over by an attacker
   -  `_disableInitializers() function in the constructor` to automatically lock it when it is deployed:

    ```solidity
    contract UpgradeableContract is Initializable {
        constructor() {
            /// @dev locks the contract to prevent re-initialization
            _disableInitializers();
        }
    }
    ```
  

5. **selfdestruct() function or delegate-call to a malicious contract that contains selfdestruct() function**




## **Possible Exploits in using upgradeable contracts**

- If we are upgrading our contracts from `v1 to v2`


1. **Storage Collision:**
    - `storage layouts` of `v1 and v2` should be same
    - If adding new state varaible in `v2`, declared it in last
    - `Swapping or rearranging order` in `v2` will lead to unexpected values of variables as solidity can defualt it's value 

    ```solidity
    contract V1 {
        uint256 public amount;
        address public owner;
    }

    contract V2 {
        uint256 public amount; // This will cause storage collision if order is changed
        address public owner;
        uint256 public newVariable; // new variable should always be added at the last
    }
    ```

2. **Failure to initialize:**
    - failing to initialize the implementation contract can lead to vulnerabilities
    - Always use `initializer` function to initialize the implementation contract and parent contracts
    - Attacker can take over the contract if it is not initialized






## **EIP-1967 -> Storage Slots**

- EIP-1967 is a standard that defines specific storage slots in smart contracts to securely store the addresses of:

1. `The Implementation Contract (Logic Contract)`
2. `The Admin (Owner) Address`

- This standard is widely adopted in upgradable smart contracts **because it prevents storage collisions** and ensures consistency when upgrading contracts.
- `EIP-1967` defines `fixed storage slots` for the implementation address and admin address.
- These slots are designed to be `unique and unlikely to overlap` with other storage variables.


**Note: EIP-1967 prevents the storage clashes by introducing storage slots and also prevents the function selector clashes**





## Sources

1. **Openzeppelin Contract Docs:**
    -  https://docs.openzeppelin.com/upgrades-plugins/writing-upgradeable#initializing_the_implementation_contract
  

2. **Proxy and Implementation contracts**:
   - https://medium.com/@social_42205/proxy-contracts-in-solidity-f6f5ffe999bd


3. **Openzeppelin Upgradable Contracts**:
   -  https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/tree/v5.2.0
