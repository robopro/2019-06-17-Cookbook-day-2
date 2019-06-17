require 'csv'
require 'byebug'

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    load_csv_file
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_to_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    save_to_csv
  end

  def mark_as_done(index)
    # We find our recipe, and mark it as done
    @recipes[index].mark_as_done!

    # Then we save/update our CSV.
    save_to_csv
  end

  private

  def load_csv_file
    # headers: :first_row => The first row in the CSV is our headers
    # header_converters: :symbol => Turn the headers into Symbols instead of Strings
    CSV.foreach(@csv_file_path, headers: :first_row, header_converters: :symbol) do |row|

      # All the information loaded from our CSV are Strings.
      # We need to convert that to a boolean.
      # Any boolean expression:
      # `a > b` or `a == b`
      # is evaluated to either true or false.
      # So `row[:done] == "true"` is either true or false.
      row[:done] = row[:done] == "true"

      # Our Recipe.new takes a hash as an argument, and because
      # we've converted our headers we can now simply pass the entire row.
      @recipes << Recipe.new(row)
    end
  end

  def save_to_csv
    CSV.open(@csv_file_path, 'wb') do |csv|

      # The header needs to be written to the CSV first.
      csv << ['name', 'description', 'prep_time', 'done']

      # Then we can write each recipe.
      @recipes.each do |recipe|

        # Instead of writing:
        # [recipe.name, recipe.description, recipe.prep_time, recipe.done?]
        # We use our Recipe#to_csv helper function.
        csv << recipe.to_csv
      end
    end
  end
end
