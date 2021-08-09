class DrinksRepresenter
  def initialize drinks
    @drinks = drinks
  end

  def as_json
    drinks.map do |drink|
      {
        id: drink.id,
        title: drink.title,
      }
    end
  end

  private

  attr_reader :drinks
end