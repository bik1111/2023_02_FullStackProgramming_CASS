import swaggerUi from 'swagger-ui-express';
import swaggereJsdoc from 'swagger-jsdoc';

const options = {
    swaggerDefinition: {
      openapi: "3.0.0",
      info: {
        version: "1.0.0",
        title: "CASS",
        description:
          "CASS API 문서입니다.",
      },
      servers: [
        {
          url: "http://localhost:3000", // 요청 URL
        },
      ],
    },
    apis: ["src/**/*.js",], //Swagger 파일 연동
}

const specs = swaggereJsdoc(options);

export { specs, swaggerUi };