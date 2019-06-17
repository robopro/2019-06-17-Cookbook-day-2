class Recipe
  attr_reader :name, :description, :prep_time

  # **attributes is the same as attributes = {}
  # *attributes is the same as attributes = []
  def initialize(**attributes)
    @description = attributes[:description]
    @name = attributes[:name]
    @prep_time = attributes[:prep_time]
    @done = attributes[:done] || false
  end

  def done?
    @done
  end

  # Remember `!` for destructive methods
  def mark_as_done!
    @done = true
  end

  # We can simplify our lives by writing custom 'to string'
  def to_s
    status = done? ? "[X]" : "[ ]"
    "#{status} "\
    "Name: #{@name} | "\
    "Description: #{@description[0..20]} | "\
    "Prep: #{@prep_time}"
  end

  # and custom 'to csv' helper functions.
  def to_csv
    [@name, @description, @prep_time, @done]
  end
  # This makes sense because we're simply returning the information
  # stored in our model in different formats: String, array.
end
