require 'rails_helper'
=begin
  1. create factory data before...do
    - create associate first, then create test data
  2. get endpoint
    - expect have status :success
    - expect size of data input eq output
    -
=end
describe 'Drink API', type: :request do

  before do
    FactoryBot.create(:drink, {
      title: 'drink 01',
      description: 'desc 01',
      steps: '1',
      source: 'https://www.bbcgoodfood.com/recipes/two-minute-breakfast-smoothie'
    })
    FactoryBot.create(:drink, {
      title: 'drink 02',
      description: 'desc 02',
      steps: '2',
      source: 'https://www.bbcgoodfood.com/recipes/two-minute-breakfast-smoothie'
    })
  end
  let(:ingredient) { FactoryBot.create(:ingredient, {description: 'ingredient 01', drink: 1 }) }
  let(:endpoint) { '/api/v1/drinks' }
  it 'GET /drinks' do
    get "#{endpoint}"
    expect(response).to have_http_status(:success)
    expect(response_body.size).to eq(2)
    expect(response_body).to eq([
      {
        "id" => 1,
        "title" => 'drink 01',
      },
      {
        "id" => 2,
        "title" => 'drink 02',
      }
    ])
  end

  it 'GET /drinks/1' do
    get "#{endpoint}/1"

    expect(response).to have_http_status(:success)
  end
end