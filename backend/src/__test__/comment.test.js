import chai from 'chai';
import chaiHttp from 'chai-http';
import app from '../../app.js'; // Import your Express app

chai.use(chaiHttp);
const { expect } = chai;

describe('/GET Comment in Post', () => {
  it('should retrieve comments for a post', async function () {
    this.timeout(0); // Set timeout to 0 to disable timeout
    try {
      // Replace 'communityId' and 'contentId' with actual values or use dynamically generated IDs
      const communityId = 1;
      const contentId = 1;

      const res = await chai.request(app).get(`/api/comment/get/${communityId}/${contentId}`);

      console.log('Response:', res.body); // Log the response for debugging

      // Your assertions and logic go here
      chai.expect(res).to.have.status(200);
      chai.expect(res.body).to.be.an('object');
      chai.expect(res.body.ok).to.be.true;
      chai.expect(res.body.data).to.be.an('array'); // Assuming data is an array in your response
      chai.expect(res.body.msg).to.equal('댓글 조회 성공');
    } catch (error) {
      // Handle any errors that occurred during the request
      console.error('Error during request:', error);
      throw error; // This will make the test fail
    }
  });
});


describe('/POST Create Comment in Post', () => {
    it('should create a comment in a post', async function () {
      this.timeout(0); // Set timeout to 0 to disable timeout
      try {
        // Replace 'communityId' and 'contentId' with actual values or use dynamically generated IDs
        const communityId = 1;
        const contentId = 1;
        const commentContent = 'This is a test comment';

        const res = await chai
          .request(app)
          .post(`/api/comment/create/${communityId}/${contentId}`)
          .send({ content: commentContent });

        console.log('Response:', res.body); // Log the response for debugging

        // Your assertions and logic go here
        chai.expect(res).to.have.status(200);
        chai.expect(res.body).to.be.an('object');
        chai.expect(res.body.ok).to.be.true;
        chai.expect(res.body.data).to.be.an('object'); // Assuming data is an object in your response
        chai.expect(res.body.msg).to.equal('댓글 생성 성공');
      } catch (error) {
        // Handle any errors that occurred during the request
        console.error('Error during request:', error);
        throw error; // This will make the test fail
      }
    });
  });


  describe('/PUT Modify Comment in Post', () => {
    it('should modify a comment in a post', async function () {
      this.timeout(0); // Set timeout to 0 to disable timeout
      try {
        // Replace 'communityId', 'contentId', and 'commentId' with actual values or use dynamically generated IDs
        const communityId = 1;
        const contentId = 1;
        const commentId = 1;
        const modifiedContent = 'This is a modified comment';

        const res = await chai
          .request(app)
          .put(`/api/comment/modify/${communityId}/${contentId}/${commentId}`)
          .send({ content: modifiedContent });

        console.log('Response:', res.body); // Log the response for debugging

        // Your assertions and logic go here
        chai.expect(res).to.have.status(200);
        chai.expect(res.body).to.be.an('object');
        chai.expect(res.body.ok).to.be.true;
        chai.expect(res.body.data).to.be.an('object'); // Assuming data is an object in your response
        chai.expect(res.body.msg).to.equal('댓글 수정 성공');
      } catch (error) {
        // Handle any errors that occurred during the request
        console.error('Error during request:', error);
        throw error; // This will make the test fail
      }
    });
  });