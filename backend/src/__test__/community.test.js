import request from 'supertest';
import chai from 'chai';
import app from '../../app.js';
import chaiHttp from 'chai-http';
import mockingoose from 'mockingoose';
chai.use(chaiHttp);
import { getCommentInPostDAO } from '../../src/dao/community/community.js';  // 변경 필요
import { createMyCommunityDAO } from '../../src/dao/community/community.js';  // 변경 필요
const { expect } = chai;

describe('/GET Community', () => {
    it('should retrieve community information', async function () {
      this.timeout(0); // Set timeout to 0 to disable timeout
      try {
        const res = await chai.request(app).get('/api/community');

        console.log('Response:', res.body); // Log the response for debugging

        // Your assertions and logic go here
        chai.expect(res).to.have.status(200);
        chai.expect(res.body).to.be.an('object');
        chai.expect(res.body.ok).to.be.true;
        chai.expect(res.body.data).to.be.an('array'); // Assuming data is an array in your response
        chai.expect(res.body.msg).to.equal('커뮤니티 조회 성공');
      } catch (error) {
        // Handle any errors that occurred during the request
        console.error('Error during request:', error);
        throw error; // This will make the test fail
      }
    });
  });


describe('POST /api/community/create', () => {
  it('should create a new community', (done) => {
    const communityData = {
      title: 'New Community',
      hashtags: '#test #community',
      // You may need to adjust this based on your actual file upload mechanism
      // For example, you might need to mock the file upload in your test.
      // If req.file is not available, you may need to provide a mock file object.
      file: {
        location: 'https://example.com/image.jpg',
      },
    };

    request(app)
      .post('/api/community/create')
      .send(communityData)
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);

        // Assuming res.body.data contains the created community details
        const createdCommunity = res.body.data;

        // Your assertion logic based on the actual response
        expect(res.body.ok).to.equal(true);
        expect(res.body.msg).to.equal('커뮤니티 생성 성공');
        expect(createdCommunity).to.be.an('object');

        // Add more specific assertions based on your actual response structure
        // For example:
        expect(createdCommunity).to.have.property('community_id');
        expect(createdCommunity).to.have.property('title');
        expect(createdCommunity).to.have.property('hashtags');
        expect(createdCommunity).to.have.property('img_url');

        done();
      });
  });
});


// Mocking DAO function
const mockCreateMyCommunityDAO = async (connection, title, hashtags, img_url) => {
    // Mock DAO logic here if needed
    return { mockResult: 'Mocked result' };
  };

  describe('POST /api/community/create', () => {
    it('should create a new community', (done) => {
      // Mocking file upload with fake file
      const upload = chai.request(app).post('/api/community/create').attach('img', fakeImage, 'fakeImage.jpg');

      // Mocking DAO function
      mockingoose(createMyCommunityDAO).toReturn({ mockResult: 'Mocked result' }, 'save');  // 변경 필요

      upload
        .field('title', 'Test Community')
        .field('hashtags', 'test,community')
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);

          // Your assertion logic based on the actual response
          expect(res.body.ok).to.equal(true);
          expect(res.body.msg).to.equal('커뮤니티 생성 성공');
          expect(res.body.data).to.deep.equal({ mockResult: 'Mocked result' });

          // Additional test logic if needed

          done();
        });
    });

    // Add other test cases as needed
  });


describe('GET /api/community/:id', () => {
  it('should retrieve community information', (done) => {
    // Mocking DAO function
    mockingoose('path-to-your-model').toReturn(
      [{ community_id: 1, content_id: 1, content_title: 'Test Title', content_detail: 'Test Detail', community_title: 'Test Community' }],
      'find'
    );  // 변경 필요

    // Perform the GET request
    chai.request(app)
      .get('/api/community/1')
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);

        // Your assertion logic based on the actual response
        expect(res.body.ok).to.equal(true);
        expect(res.body.msg).to.equal('커뮤니티 조회 성공');
        expect(res.body.data).to.be.an('array').that.has.lengthOf(1);

        // Additional assertions based on your actual response structure
        const communityInfo = res.body.data[0];
        expect(communityInfo).to.have.property('community_id');
        expect(communityInfo).to.have.property('content_id');
        expect(communityInfo).to.have.property('content_title');
        expect(communityInfo).to.have.property('content_detail');
        expect(communityInfo).to.have.property('community_title');

        // Add more specific assertions based on your actual response structure

        done();
      });
  });

  // Add other test cases as needed
});




describe('GET /api/community/:id', () => {
  it('should retrieve community information', (done) => {
    // Mocking DAO function
    mockingoose(getCommentInPostDAO).toReturn(
      [{ community_id: 1, content_id: 1, content_title: 'Test Title', content_detail: 'Test Detail', community_title: 'Test Community' }],
      'find'
    );  // 변경 필요

    // Perform the GET request
    chai.request(app)
      .get('/api/community/1')
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);

        // Your assertion logic based on the actual response
        expect(res.body.ok).to.equal(true);
        expect(res.body.msg).to.equal('커뮤니티 조회 성공');
        expect(res.body.data).to.be.an('array').that.has.lengthOf(1);

        // Additional assertions based on your actual response structure
        const communityInfo = res.body.data[0];
        expect(communityInfo).to.have.property('community_id');
        expect(communityInfo).to.have.property('content_id');
        expect(communityInfo).to.have.property('content_title');
        expect(communityInfo).to.have.property('content_detail');
        expect(communityInfo).to.have.property('community_title');

        // Add more specific assertions based on your actual response structure

        done();
      });
  });

  // Add other test cases as needed
});


describe('POST /api/create/post/:communityId', () => {
    it('should create a new post in the community', (done) => {
      // Mocking DAO function
      mockingoose('').toReturn(
        { _id: 'some-id', content_title: 'Test Title', content_detail: 'Test Content', community_id: '1', createdAt: new Date() },
        'save'
      );  // 변경 필요

      // Perform the POST request
      chai.request(app)
        .post('/api/create/post/1')
        .send({ title: 'Test Title', content: 'Test Content' })
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);

          // Your assertion logic based on the actual response
          expect(res.body.ok).to.equal(true);
          expect(res.body.msg).to.equal('게시글 생성 성공');
          expect(res.body.data).to.be.an('object');

          // Additional assertions based on your actual response structure
          const createdPost = res.body.data;
          expect(createdPost).to.have.property('_id');
          expect(createdPost).to.have.property('content_title');
          expect(createdPost).to.have.property('content_detail');
          expect(createdPost).to.have.property('community_id');
          expect(createdPost).to.have.property('createdAt');

          // Add more specific assertions based on your actual response structure

          done();
        });
    });

    // Add other test cases as needed
  });