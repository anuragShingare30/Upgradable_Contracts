## Upgradable contracts

- As we know that contracts are immutable once it is deployed.
- **Upgradable contracts and EIP-1967** gives power to developer to change and add logic/functionality!!!

### Upgradable Contracts methods

1. `Not really/Parameterized`:
    - Can't add new storage,logic
    - Updates parameters only!!!

2. `Migration method`:
    - develop new contract with no relation with older contract
    - Users need to be convenced hardly to move and use new contract
    - Older address will be changed and new address are assigned

3. `Proxies Upgradable contracts`:
    - Uses low-lvel function calls and methods
    - `delegate calls` -> calls the function of other contract delegatally and updates state/storage at own contract



### Proxies and Implementation contracts


1. **`Proxy Contract`**:
    - An intermediate layer between user and contract logic/functionality
    - Holds state data and delegate calls to implementation contract to use the functionality
    - uses `delegate calls` to implementation contract to use the functionality

2. **`Implementation Contract`**:
    - Actual logic or functionality of protocol
    - This contract contains the bugs/componenets that need to be upgrades or modify

3. **`Upgradability Mechanism`**:
    - We will deploy new implementation contract with fresh and new logic
    - Proxy is updated to delegate calls to new implementation contract
    - Maintains users data integrity
  
**Note: all the storage value is stored in proxy contract. Proxies contracts state is changing all time and not of implementation contract.**


### Limitations of Proxies contract

1. **Storage clashes**
2. **Function selector clashes**


### Implementation of Proxy contract


1. `Transparent Proxy Pattern`:
   - `Admins` can call only admins functions and they can't call rest of implementation contract function
   - `Users` can call only impl. functions and not admins's contract 
  

2. **`Universal Upgradable Proxies (UUPs)`**:
    - Main logic/functionality of protocol -> Implementation contract
    - Users interact with Proxies contract
    - Proxies contracts state's is changed and not of impl. contract
    - `Proxies contract` will `delegate calls` to implementaion contract for functionallity


### EIP-1967 -> Storage Slots

- EIP-1967 is a standard that defines specific storage slots in smart contracts to securely store the addresses of:

1. `The Implementation Contract (Logic Contract)`
2. `The Admin (Owner) Address`

- This standard is widely adopted in upgradable smart contracts **because it prevents storage collisions** and ensures consistency when upgrading contracts.
- EIP-1967 defines `fixed storage slots` for the implementation address and admin address.
- These slots are designed to be `unique and unlikely to overlap` with other storage variables.


**Note: EIP-1967 prevents the storage clashes by introducing storage slots and also prevents the function selector clashes**



### DELEGATE CALLS

- A `low-level function call` similar to call
- Uses `function signature` to call the function of another contract
- Stores value in storage slots and access it according to `index/slot assigned` to state in impl. contract
- **The ordering of variables in implementaion contract and proxies contracts should be same**