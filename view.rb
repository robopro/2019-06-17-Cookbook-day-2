class View
  def display(recipes)
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1}. #{recipe.to_s}"
    end
  end

  def ask_for(attribute)
    puts "What is the #{attribute} of the recipe?"
    print "> "
    gets.chomp
  end

  def ask_for_index
    puts "What is the index of the recipe?"
    print "> "
    gets.chomp.to_i - 1
  end
end
