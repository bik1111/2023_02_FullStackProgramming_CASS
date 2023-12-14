import chai from 'chai';
import chaiHttp from 'chai-http';
import app from '../../app.js'; // Import your Express app

chai.use(chaiHttp);
const { expect } = chai;

describe('/POST Create Review', () => {
  it('should create a review for a cafe', async function () {
    this.timeout(0); // Set timeout to 0 to disable timeout
    try {
      // Replace with actual values or use dynamically generated values
      const cafeId = 1;
      const rating = 4.5;
      const comment = 'Great cafe!';

      const res = await chai
        .request(app)
        .post('/api/create/review')
        .send({ cafe_id: cafeId, rating: rating, comment: comment });

      console.log('Response:', res.body); // Log the response for debugging

      // Your assertions and logic go here
      chai.expect(res).to.have.status(200);
      chai.expect(res.body).to.be.an('object');
      chai.expect(res.body.ok).to.be.true;
      chai.expect(res.body.data).to.be.an('object'); // Assuming data is an object in your response
      chai.expect(res.body.msg).to.equal('리뷰 생성 성공');
    } catch (error) {
      // Handle any errors that occurred during the request
      console.error('Error during request:', error);
      throw error; // This will make the test fail
    }
  });
});


describe('/GET Review for Each Cafe', () => {
    it('should retrieve reviews for a specific cafe', async function () {
      this.timeout(0); // Set timeout to 0 to disable timeout
      try {
        // Replace with an actual cafeId or use a dynamically generated value
        const cafeId = 1;

        const res = await chai.request(app).get(`/api/review/${cafeId}`);

        console.log('Response:', res.body); // Log the response for debugging

        // Your assertions and logic go here
        chai.expect(res).to.have.status(200);
        chai.expect(res.body).to.be.an('object');
        chai.expect(res.body.ok).to.be.true;
        chai.expect(res.body.data).to.be.an('array'); // Assuming data is an array in your response
        chai.expect(res.body.msg).to.equal('리뷰 조회 성공');
      } catch (error) {
        // Handle any errors that occurred during the request
        console.error('Error during request:', error);
        throw error; // This will make the test fail
      }
    });
  });



  describe('/PUT Modify Review', () => {
    it('should modify a review', async function () {
      this.timeout(0); // Set timeout to 0 to disable timeout
      try {
        // Replace with an actual reviewId or use a dynamically generated value
        const reviewId = 1;

        // Replace with actual values or use dynamically generated values
        const rating = 4.0;
        const comment = 'Updated review';

        const res = await chai
          .request(app)
          .put(`/api/modify/${reviewId}`)
          .send({ rating: rating, comment: comment });

        console.log('Response:', res.body); // Log the response for debugging

        // Your assertions and logic go here
        chai.expect(res).to.have.status(200);
        chai.expect(res.body).to.be.an('object');
        chai.expect(res.body.ok).to.be.true;
        chai.expect(res.body.data).to.be.an('object'); // Assuming data is an object in your response
        chai.expect(res.body.msg).to.equal('리뷰 수정 성공');
      } catch (error) {
        // Handle any errors that occurred during the request
        console.error('Error during request:', error);
        throw error; // This will make the test fail
      }
    });
  });


  describe('/DELETE Delete Review', () => {
    it('should delete a review', async function () {
      this.timeout(0); // Set timeout to 0 to disable timeout
      try {
        // Replace with an actual reviewId or use a dynamically generated value
        const reviewId = 1;

        const res = await chai
          .request(app)
          .delete(`/api/delete/${reviewId}`);

        console.log('Response:', res.body); // Log the response for debugging

        // Your assertions and logic go here
        chai.expect(res).to.have.status(200);
        chai.expect(res.body).to.be.an('object');
        chai.expect(res.body.ok).to.be.true;
        chai.expect(res.body.data).to.be.an('object'); // Assuming data is an object in your response
        chai.expect(res.body.msg).to.equal('리뷰 삭제 성공');
      } catch (error) {
        // Handle any errors that occurred during the request
        console.error('Error during request:', error);
        throw error; // This will make the test fail
      }
    });
  });