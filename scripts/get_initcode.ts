import { ethers } from "hardhat";

async function getInitcode(): Promise<void> {
  const contractName = "Rating"; // コントラクト名を指定
  const constructorArguments = []; // コンストラクタ引数を指定

  // スマートコントラクトのFactoryを取得
  const ContractFactory = await ethers.getContractFactory(contractName);

  let initcode: string;

  if (constructorArguments.length > 0) { 
    // コンストラクタの入力パラメータをエンコード
    const constructorInputs = ContractFactory.interface.fragments.find((item) => item.type === "constructor").inputs;
    const encodedConstructorArguments = ethers.AbiCoder.defaultAbiCoder().encode(constructorInputs, constructorArguments);

    // バイトコードとエンコード済みコンストラクタ引数を結合
    initcode = ContractFactory.bytecode + encodedConstructorArguments.slice(2);
  } else {
    initcode = ContractFactory.bytecode;
  }
  console.log("Initcode:", initcode);
}

getInitcode().catch((error) => {
  console.error(error);
  process.exit(1);
});
