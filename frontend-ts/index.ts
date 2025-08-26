import { processData, handleData } from './src/utils/helpers.js';

/**
 * 主函数
 */
function main(): void {
  console.log('Hello World from TypeScript Frontend!');

  const greeting: string = '欢迎使用TypeScript前端项目';
  console.log(greeting);

  // 测试工具函数
  const testData: string | null = 'test data';
  const processedData: string = processData(testData);
  console.log('Processed data:', processedData);

  const genericData: number = 42;
  const handledData: number = handleData(genericData);
  console.log('Handled data:', handledData);
}

// 执行主函数
main();
