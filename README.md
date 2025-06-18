# myFirstDapp-aCasino
I am building my first DApp, it is a decentralized casino, I write in solidity, using remix as ide, tested and deployed on remix environment.
Maybe my code and my description are bad, your comments, suggetions, edits, advices are sincerely wanted. Just feel free to make any comments, suggetions, edits, advices or any other things you want. All of these are certainly supper great help to me and my repository.

CASINO RULE:
1] players enter casino. (sign in with their wallets)
2] every player can organize a room. 
3] casino has a maximum number of room, each room has a maximum number of players.
4] different rooms offer different game. (just has one kind of game so far, which is guess the size)
5] every player can enter one room at the same time.
6] players bet chips when they enter a room.
7] earns chips by odds when he wins, other wise, lose all he bets.
8] each room has a condition for drawing prize, such as time, players number and so on.
9] chip is a ERC20 token.

FILES:
1] cotracts/Caller.sol
imitate the player's operation since i don't have a web3 frontend now.
2] contracts/Proxy.sol
considering the need for later upgrades, a proxy mode is used.
3] contracts/Implementation.sol
logic of the casino.
4] tokenization/Chip.sol
chip token.
5] tokenization/IChip.sol

PLAN IN FUTURE:
optimize contracts, write test scripts, build frontend.

***------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------***

我正在开发我的第一个DApp， 是一个去中心化的游戏厅，solidity语言，使用remix ide在线编写、测试、部署。
也许我的代码和我的描述都很不完善， 我真心地期待你的评价、建议、修改、意见。尽管对我的项目做任何评价、建议、修改、意见或者其他的想法，所有的这些肯定都会成为巨大的帮助。

游戏厅规则：
1】玩家进入游戏厅。（通过连接钱包登录）
2】所有玩家都可以创建房间。
3】游戏厅有房间上限，房间有人数上限。
4】不同房间有不同玩法。（目前只有一种玩法，猜大小）
5】玩家只能同时进入一个房间。
6】玩家进入房间就要下注。
7】赢的时候按赔率赚取筹码，输的时候失去下注的筹码。
8】每个房间都有开奖的条件，如人数上限、时间等。
9】筹码是一种ERC20代币。

文件：
1】cotracts/Caller.sol
模拟玩家行为，正常是通过web前端操作，但目前没有前端
2】contracts/Proxy.sol
考虑到以后可能会升级，用代理合约的方式
3】contracts/Implementation.sol
游戏厅的实现逻辑
4】tokenization/Chip.sol
筹码代币
5】tokenization/IChip.sol

未来计划：
完善合约、编写测试脚本、搭建web界面。
