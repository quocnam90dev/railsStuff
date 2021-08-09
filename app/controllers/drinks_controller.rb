class DrinksController < ApiController
  # GET /drinks
  def index
    @drinks = DrinksRepresenter.new(Drink.all).as_json

    render json: @drinks
  end

  # GET /drinks/1
  def show
    @drink = Drink.find(params[:id])
    render json: @drink.to_json(:include => { :ingredients => { :only => [:id, :description] }})
  end

end
