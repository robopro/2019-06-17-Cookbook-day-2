class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    recipes = @cookbook.all
    @view.display(recipes)
  end

  def create
    name = @view.ask_for(:name)
    description = @view.ask_for(:description)
    prep_time = @view.ask_for(:"prep time")

    recipe = Recipe.new({name: name, description: description, prep_time: prep_time})

    @cookbook.add_recipe(recipe)
  end

  def destroy
    list
    index = @view.ask_for_index

    @cookbook.remove_recipe(index)
  end

  def import
    ingredient = @view.ask_for(:ingredient)

    # Separation of concerns.
    # Our controller isn't really responsible for scraping.
    # But it doesn't make sense to put our scraping code in
    # the Cookbook, or the View.
    # So we make a custom class!
    # That class only does _one_ thing => Hence a service!
    # It scrapes a website for recipes, and returns an array of Recipe objects.
    recipes = ScrapeRecipeService.new(ingredient).call

    @view.display(recipes)
    index = @view.ask_for_index

    @cookbook.add_recipe(recipes[index])
  end

  def mark
    # List the recipes
    list

    # Ask for the index of the recipe the user wants to change
    index = @view.ask_for_index

    # Update that recipe in our Cookbook.
    # Why?
    # Separation of concern!
    # The controller is not responsible for saving or updating our CSV.
    # The controller just informs all the other parts of what they should do,
    # and passes information back and forth.
    @cookbook.mark_as_done(index)
  end
end
