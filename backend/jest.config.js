// jest.config.js

export default {
    testEnvironment: 'node',
    transform: {
      '^.+\\.js$': 'babel-jest',
    },
    testMatch: ['<rootDir>/src/__tests__/**/*.test.js'], // Adjust the path based on your project structure
  };
