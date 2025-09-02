package com.example;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Simple Hello World demonstration class for Java backend. This class serves as a basic example to
 * demonstrate the Java code quality toolchain with Alibaba P3C PMD rules.
 *
 * @author Claude Code
 * @date 2025-09-02
 * @since 1.0.0
 */
public class HelloWorld {

  private static final Logger LOGGER = LoggerFactory.getLogger(HelloWorld.class);

  /**
   * Main entry point for the Hello World application. Prints greeting messages in English and
   * Chinese to demonstrate basic Java functionality using proper logging framework.
   *
   * @param args command line arguments (not used)
   */
  public static void main(String[] args) {
    LOGGER.info("Hello World from Java Backend!");
    LOGGER.info("欢迎使用Java后端服务 - 已升级到阿里巴巴P3C规范");
  }
}
