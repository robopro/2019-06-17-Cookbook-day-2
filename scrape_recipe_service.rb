require 'nokogiri'
require 'open-uri'

class ScrapeRecipeService
  BASE_URL = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt="

  def initialize(ingredient)
    @ingredient = ingredient
  end

  def call
    url = "#{BASE_URL}#{@ingredient}"

    recipes = []

    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    # Note the `take(5)` to limit our results.
    html_doc.search('.m_contenu_resultat').take(5).each do |element|

      # To enhance readability of our code
      # we move our searches to custom methods.
      name = get_name(element)
      description = get_description(element)
      prep_time = get_prep_time(element)

      recipes << Recipe.new({name: name, description: description, prep_time: prep_time})

      # Addendum. We could also have written:
      # recipes << Recipe.new({
      #   name: get_name(element),
      #   description: get_description(element),
      #   prep_time: get_prep_time(element)
      # })
      # Do you see why?
    end

    return recipes
  end

  private

  def get_name(element)
    element.search('.m_titre_resultat').text.strip
  end

  def get_description(element)
    element.search('.m_texte_resultat').text.strip
  end

  def get_prep_time(element)
    # The html class we're searching for is empty.
    # But the parent tag has the information we want.
    # So we access the first element in our search,
    # which is the Nokogiri object,
    # and through that we can access its' parent.
    element.search('.m_prep_time').first.parent.text.strip
  end
end
