/**
 * 工具函数集合
 */

// 用户类型定义
interface User {
  id: number;
  name: string;
  email: string;
  age: number;
  isActive: boolean;
  hasPermission: boolean;
  role: 'admin' | 'moderator' | 'user';
}

// 处理后的用户类型
interface ProcessedUser extends User {
  status: string;
}

/**
 * 处理用户数据
 * @param user 用户对象
 * @returns 处理后的用户对象
 */
export function processUserData(user: User): ProcessedUser {
  const status = determineUserStatus(user);
  return { ...user, status };
}

/**
 * 确定用户状态
 * @param user 用户对象
 * @returns 用户状态字符串
 */
function determineUserStatus(user: User): string {
  if (user.age <= 18) return 'underage';
  if (!user.isActive) return 'suspended';
  if (!user.hasPermission) return 'inactive';

  return user.role === 'admin'
    ? 'admin'
    : user.role === 'moderator'
      ? 'moderator'
      : 'user';
}

/**
 * 验证字符串是否有效
 * @param value 要验证的值
 * @returns 是否为有效字符串
 */
export function isValidString(value: unknown): value is string {
  return typeof value === 'string' && value.length > 0;
}

/**
 * 处理可能为null的数据
 * @param data 可能为null的数据
 * @returns 处理后的字符串
 */
export function processData(data: string | null): string {
  if (isValidString(data)) {
    return data.toUpperCase();
  }
  return '';
}

/**
 * 使用可选链和空值合并处理数据
 * @param data 可能为null的数据
 * @returns 处理后的字符串
 */
export function processDataSafe(data: string | null): string {
  return data?.toUpperCase() ?? '';
}

/**
 * 泛型数据处理函数
 * @param data 泛型数据
 * @returns 处理后的数据
 */
export function handleData<T>(data: T): T {
  return data;
}

/**
 * 使用联合类型处理数据
 * @param data 联合类型数据
 * @returns 处理后的字符串
 */
export function handleUnionData(data: string | number | boolean): string {
  if (typeof data === 'string') {
    return data.toUpperCase();
  } else if (typeof data === 'number') {
    return data.toFixed(2);
  } else {
    return data.toString();
  }
}
