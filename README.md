1.访问链接：https://bcp280-3000.preview.csb.app/;

2.前端部署在codesandbox上，14天free，replit free版本只有1G的磁盘空间，小于next.js依赖包需要的空间，所以没有采用；

3.合约部署在geoli链，address是0x435B3b7aB9b9235304ac54e454ce797cC7156F81,通过https://goerli.etherscan.io/address/0x435B3b7aB9b9235304ac54e454ce797cC7156F81可查看交互记录；

4.游戏背景是mint一个英雄(喜羊羊、懒羊羊或者美羊羊)，向入侵者灰太狼发起攻击；一共四个按钮：
  connect wallet: 进入游戏选择连接metamask,注意选择geoli链，否则后面的mint或者attack会失败,浏览器推荐使用chrome，其他的浏览器没测试过；
  mint lucky boy: mint喜羊羊;
  mint lazy boy : mint懒羊羊
  mint beauty girl： mint美羊羊
  每次mint英雄和灰太狼的blood都是100，英雄的攻击是随机生成的(20-40),狼的攻击为固定值28
  attack:发起攻击时，狼的剩余血量 = 攻击前血量 - 🐏的攻击力，如果狼血=0,游戏结束，🐏获得胜利；如果🐏的剩余血量=0，狼获得胜利
  游戏结束胜利的玩家会在下方显示winner
  mint和attack都是链上的一笔交易，交易会在打包会进行排队，时间会比较长，30s之内都是正常的，可通过metmask加速(提高手续费)获得优先打包权
  
 5.本程序为demo程序，主要考虑了一些happy case，逻辑上不是很完备，前端上也没有进一步优化
 
 6.本地项目部署过程： 
   clone代码： git clone xxx and cd project;
   安装依赖：
   npm install --save-dev hardhat;
   nmp install next;
   npm install @openzeppelin/contracts;
   启动节点： npx hardhat node 
   部署合约： npm run deployNFT
   部署前端： npm run dev
   
