import request from 'supertest';
import chai from 'chai';
import app from '../../app.js';
import chaiHttp from 'chai-http';
import mysql from 'mysql2/promise';

chai.use(chaiHttp);
const { expect } = chai;

const options = {
  host : 'docker.for.mac.host.internal',
  port : 3306,
  user : 'root',
  password : 'tkfkdgo12!',
  database : 'cass'
}


describe('connection test', () => {
  before('create connection', () => {
    /* mysql server와 connection을 맺음 */
    connection = mysql.createConnection(options);
  });

  it('query execute', done => {
    connection.query('select 1 + 1 as sum', (err, results, fields) => {
      /* mysql server와 connection을 끊음 */
      connection.end();
      if(err) {
        console.error("Error >>", err);
        return done(err);
      }
      expect(results[0].sum).to.be.equal(2);
      done();
    });
  });
});



describe('GET /', () => {
    it('should return "Hello, World!"', (done) => {
      request(app)
        .get('/')
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.text).to.equal('Hello World!');
          done();
        });
    });
  });



  describe('GET cafeInformation', () => {
    it('should return a list of cafes when searching by name', (done) => {
      request(app)
        .get('/api/cafe/search')
        .query({ cafeName: '송파' })
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);

          // Assuming res.body.data is an array of cafes
          const cafes = res.body.data;

          // Your assertion logic based on the actual response
          expect(res.body.ok).to.equal(true);
          expect(res.body.msg).to.equal('카페 검색 성공');
          expect(cafes).to.be.an('array');
          expect(cafes).to.have.length.above(0);

          // Add more specific assertions based on your actual response structure
          // For example:
          expect(cafes[0]).to.have.property('cafe_id');
          expect(cafes[0]).to.have.property('name');
          expect(cafes[0]).to.have.property('address');
          expect(cafes[0]).to.have.property('number');

          done();
        });
    });
  });



