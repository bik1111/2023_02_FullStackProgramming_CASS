import chai from 'chai';
import mysql from 'mysql2/promise';
import request from 'supertest';
import app from '../../app.js';
import chaiHttp from 'chai-http';

chai.use(chaiHttp);
const { expect } = chai;

describe('Access to DB',  () => {
  describe('#success',  () => {
    it('assertion success', async function () {
      this.timeout(0);
      try {
        const connection = await mysql.createConnection({
          host: 'localhost',
          user: 'root',
          password: 'tkfkdgo12!',
          database: 'cass',
        });

        // Try to connect (this should not throw an error)
        await connection.connect();

        // If the connection is successful, the test should pass
        expect(connection).to.be.ok; // or expect(connection).to.exist;
      } catch (error) {
        // If an error occurs during the connection, the test should fail
        expect.fail(`Expected successful connection, but got an error: ${error.message}`);
      }
    });
  });
});


describe('/GET Search Cafe', () => {
  it('should return a list of cafes', async function () {
    this.timeout(0); // Set timeout to 0 to disable timeout
    try {
      const res = await chai
        .request(app)
        .get('/api/cafe/search')
        .query({ cafeName: '송파' }) // Replace with an actual cafe name

      console.log('Response:', res.body); // Log the response for debugging

      // Your assertions and logic go here
      chai.expect(res).to.have.status(200);
      chai.expect(res.body).to.be.an('object');
      chai.expect(res.body.ok).to.be.true;
      chai.expect(res.body.data).to.be.an('array'); // Assuming data is an array in your response
    } catch (error) {
      // Handle any errors that occurred during the request
      console.error('Error during request:', error);
      throw error; // This will make the test fail
    }
  });
});



describe('/GET All Cafe Information', () => {
  it('should retrieve all cafe information', async function () {
    this.timeout(0); // Set timeout to 0 to disable timeout
    try {
      const res = await chai.request(app).get('/api/cafe/');

      console.log('Response:', res.body); // Log the response for debugging

      // Your assertions and logic go here
      chai.expect(res).to.have.status(200);
      chai.expect(res.body).to.be.an('object');
      chai.expect(res.body.ok).to.be.true;
      chai.expect(res.body.data).to.be.an('array'); // Assuming data is an array in your response
      chai.expect(res.body.msg).to.equal('카페 정보 조회 성공');
    } catch (error) {
      // Handle any errors that occurred during the request
      console.error('Error during request:', error);
      throw error; // This will make the test fail
    }
  });
});