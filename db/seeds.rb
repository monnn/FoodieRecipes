HOURS_MINUTES_REGEXP = /\APT(\d+)H(\d+)M\Z/
HOURS_REGEXP = /\APT(\d+)H\Z/
MINUTES_REGEXP = /\APT(\d+)M\Z/

DUMMY_QUANTITY = 50

@admin = User.create!(name: 'Admin', email: 'admin@gmail.com', password: 'password', password_confirmation: 'password')

def import_recipes
  data_raw = File.read("recipes-seed.json")
  parsed_data = JSON.parse(data_raw)

  parsed_data["recipes"].each do |recipe|
    attributes = parse_raw_recipe(recipe)
    attributes[:author_id] = @admin[:id]
    Recipe.new(attributes).save
  end
end

def parse_raw_recipe(recipe)
  name = recipe["name"]
  description = recipe["description"]
  prepTime = parse_time(recipe["prepTime"])
  cookTime = parse_time(recipe["cookTime"])
  url = recipe["url"]
  image = recipe["image"]
  cookingMethod = recipe["cookingMethod"]
  portions = extract_integer(recipe["recipeYield"])

  {
    name: name,
    description: description,
    prepTime: prepTime,
    cookTime: cookTime,
    url: url,
    image: image,
    cookingMethod: cookingMethod,
    portions: portions,

  }
end

def extract_integer(string)
  return unless string.match(/\.*(\d+)\.*/)

  string.match(/\.*(\d+)\.*/).captures.first
end

def parse_time(time)
  hours = 0
  minutes = 0

  if HOURS_MINUTES_REGEXP.match(time)
    groups = HOURS_MINUTES_REGEXP.match(time).captures
    hours = groups.first.to_i
    minutes = groups.last.to_i
  elsif HOURS_REGEXP.match(time)
    groups = HOURS_REGEXP.match(time).captures
    hours = groups.first.to_i
  elsif MINUTES_REGEXP.match(time)
    groups = MINUTES_REGEXP.match(time).captures
    minutes = groups.first.to_i
  end

  hours * 60 + minutes
end

def import_recipe_ingredients
  data_raw = File.read("recipes-seed.json")
  parsed_data = JSON.parse(data_raw)

  parsed_data["recipes"].each do |recipe|
    parse_raw_recipe_ingredients(recipe)
  end
end

def parse_raw_recipe_ingredients(raw_recipe)
  ingredients_array = raw_recipe["ingredients"].split(/\n/)

  ingredients_array.each do |ingredient|
    ingredient_props = ingredient.split(',')
    quantity_original = ingredient_props.first

    quantity = parse_quantity(quantity_original)
    if quantity.to_s.match(/.*\d+.*/)
      ingredient_name = ingredient_props[1]
    else
      ingredient_name = ingredient_props[0]
      quantity = DUMMY_QUANTITY
    end

    note = ingredient_props.last.strip

    ingredient_name = note unless ingredient_name

    ingredient_name = ingredient_name.strip.downcase

    ingredient = Ingredient.find_by(name: ingredient_name)
    unless ingredient
      ingredient = Ingredient.new({name: ingredient_name})
      ingredient.save
    end

    recipe = Recipe.find_by(name: raw_recipe["name"])
    return unless recipe

    return if RecipeIngredient.find_by(recipe_id: recipe[:id], ingredient_id: ingredient[:id])
    
    RecipeIngredient.new({
      recipe_id: recipe[:id],
      ingredient_id: ingredient[:id],
      quantity: quantity,
      quantity_original: quantity_original,
      note: note
    }).save
  end
end

def parse_quantity(string_quantity)
  if string_quantity.match(/.*\/\ (\d+)g/)

    return string_quantity.match(/.*\/\ (\d+)g/).captures[0]
  end

  if string_quantity.match(/(\d+) g/)
    return string_quantity.match(/(\d+) g/).captures[0]
  end

  string_quantity =
    string_quantity.gsub(/cups|Cups/, '* 150')
                   .gsub(/cup|Cup/, '* 150')
                   .gsub(/tablespoons|Tablespoons/, '* 12')
                   .gsub(/tablespoon|Tablespoon/, '* 12')
                   .gsub(/teaspoons|Teaspoons/, '* 6')
                   .gsub(/teaspoon|Teaspoon/, '* 6')
                   .gsub(/pounds|Pounds/, '* 500')
                   .gsub(/pound|Pound/, '* 500')
                   .gsub(/cloves|Cloves/, '* 5')
                   .gsub(/ounces|Ounces/, '* 30')
                   .gsub(/ounce|ounce/, '* 30')
                   .gsub(/Slices|slices/, '* 30')
                   .gsub(/Slice|slice/, '* 30')
                   .gsub(/whole|Whole/, '* 150')
                   .gsub(/sprigs|Sprigs/, '* 10')
                   .gsub(/cans|Cans/, '* 200')
                   .gsub(/can|Can/, '* 200')
                   .gsub(/jars|Jars/, '* 400')
                   .gsub(/jar|Jar/, '* 400')
                   .gsub(/packages|Packages/, '* 400')
                   .gsub(/package|Package/, '* 400')
                   .gsub(/heads|Heads/, '* 500')
                   .gsub(/head|Head/, '* 500')
                   .gsub(/bags|Bags/, '* 600')
                   .gsub(/bag|Bag/, '* 600')
                   .gsub(/sticks|Sticks/, '* 50')
                   .gsub(/stick|Stick/, '* 50')
                   .gsub(/stalks|Stalks/, '* 30')
                   .gsub(/dashes|Dashes/, '* 50')
                   .gsub(/bunch|Bunch/, '* 30')
                   .gsub(/pinches|Pinches/, '* 5')
                   .gsub(/pinch|Pinch/, '* 5')
                   .gsub('1/2', '0.5')
                   .gsub('1/3', '0.33')
                   .gsub('1/4', '0.25')
                   .gsub('2/3', '0.66')

  if string_quantity.match(/(\d+.?\d*) \* (\d+)/)
    groups = string_quantity.match(/(\d+.?\d*) \* (\d+)/).captures
    return groups.first.to_f * groups.last.to_f
  end

  if string_quantity.match(/.*(\d+).*/)
    groups = string_quantity.match(/.*(\d+).*/).captures
    return groups.first.to_f * DUMMY_QUANTITY
  end

  string_quantity
end

import_recipes()
import_recipe_ingredients()