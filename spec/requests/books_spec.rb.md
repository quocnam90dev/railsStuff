require 'rails_helper'

describe 'Book API', type: :request do
  let(:first_author) { FactoryBot.create(:author, first_name: 'Lion', last_name: 'King', age: 32) }
  let(:second_author) { FactoryBot.create(:author, first_name: 'Lion', last_name: 'King V1', age: 30) }

  before do
    FactoryBot.create(:user, username: 'lion', password: '123123')
  end

  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title: '1985', author: first_author)
      FactoryBot.create(:book, title: '1986 War', author: second_author)
    end

    it 'returns all books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body).to eq(
        [
          {
            "id" => 1,
            "title" => '1985',
            "author_name" => 'Lion King',
            "author_age" => 32,
          },
          {
            "id" => 2,
            "title" => '1986 War',
            "author_name" => 'Lion King V1',
            "author_age" => 30,
          }
        ]
      )
    end

    it 'returns a subset of books based on pagination' do
      get '/api/v1/books', params: { limit: 1 }

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            "id" => 1,
            "title" => '1985',
            "author_name" => 'Lion King',
            "author_age" => 32,
          }
        ]
      )
    end

    it 'returns a subset of books based on limit and offset ' do
      get '/api/v1/books', params: { limit: 1, offset: 1 }

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            "id" => 2,
            "title" => '1986 War',
            "author_name" => 'Lion King V1',
            "author_age" => 30,
          }
        ]
      )
    end

  end

  describe 'POST /books' do
    it 'create a new book' do

      expect {
        post '/api/v1/books', params: {
          book: { title: "Awesome" },
          author: { first_name: 'Lion', last_name: 'King', age: 32 }
        }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.2BSHfBpZJZJVycWQrmYpfnHMA9BwmiCg9z0YvbiJjQ0" }
      }.to change { Book.count }.from(0).to(1)
      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(response_body).to eq(
        {
          "id" => 1,
          "title" => 'Awesome',
          "author_name" => 'Lion King',
          "author_age" => 32,
        }
      )
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) { FactoryBot.create(:book, title: '1985', author: first_author) }

    it 'deleteds a book' do
      expect {
        delete "/api/v1/books/#{book.id}",
        headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.2BSHfBpZJZJVycWQrmYpfnHMA9BwmiCg9z0YvbiJjQ0" }
      }.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end

end