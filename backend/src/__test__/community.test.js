import request from 'supertest';
import chai from 'chai';
import app from '../../app.js';
import chaiHttp from 'chai-http';

chai.use(chaiHttp);

const { expect } = chai;

describe('GET /api/community', () => {
  it('should return a list of communities', (done) => {
    request(app)
      .get('/api/community')
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);

        // Assuming res.body.data is an array of communities
        const communities = res.body.data;

        // Your assertion logic based on the actual response
        expect(res.body.ok).to.equal(true);
        expect(res.body.msg).to.equal('커뮤니티 조회 성공');
        expect(communities).to.be.an('array');
        expect(communities).to.have.length.above(0);

        // Add more specific assertions based on your actual response structure
        // For example:
        expect(communities[0]).to.have.property('community_id');
        expect(communities[0]).to.have.property('title');
        expect(communities[0]).to.have.property('hashtags');
        expect(communities[0]).to.have.property('createdAt');
        expect(communities[0]).to.have.property('community_img');

        done();
      });
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


