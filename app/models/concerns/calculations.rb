module Calculations
  def self.cosine_similarity(vector1, vector2)
    dot_product = 0

    vector1.each do |vector_element|
      element_name = vector_element.keys.first
      vector1_value = vector_element.values.first

      vector2_occurence =
        vector2.select { |vector2_element| vector2_element.keys.first == element_name }.first

      vector2_value = vector2_occurence ? vector2_occurence.values.first : 0

      dot_product += (vector1_value.to_f * vector2_value.to_f)
    end

    vector1_values = 0
    vector1.each { |vector_element| vector1_values += (vector_element.values.first.to_f**2) }

    vector2_values = 0
    vector2.each { |vector_element| vector2_values += (vector_element.values.first.to_f**2) }

    magnitude = Math.sqrt(vector1_values) * Math.sqrt(vector2_values)

    (dot_product / magnitude.to_f).round(2)
  end

  # rubocop:disable Metrics/AbcSize
  def self.pearson_correlation(vector1, vector2)
    dot_product = 0
    vector1_sum = vector1.inject(0) { |sum, hash| sum + hash.values.first }
    vector2_sum = vector2.inject(0) { |sum, hash| sum + hash.values.first }

    vector1_mean = vector1_sum / vector1.size.to_f
    vector2_mean = vector2_sum / vector2.size.to_f

    vector1.each do |vector_element|
      element_name = vector_element.keys.first
      vector1_value = vector_element.values.first

      vector2_occurence =
        vector2.select { |vector2_element| vector2_element.keys.first == element_name }.first

      vector2_value = vector2_occurence ? vector2_occurence.values.first : 0

      dot_product += ((vector1_value.to_f - vector1_mean) * (vector2_value.to_f - vector2_mean))
    end

    vector2.each do |vector_element|
      element_name = vector_element.keys.first
      vector2_value = vector_element.values.first

      vector1_occurence =
        vector1.select { |vector1_element| vector1_element.keys.first == element_name }.first

      next if vector1_occurence

      dot_product += ((0 - vector1_mean) * (vector2_value.to_f - vector2_mean))
    end

    vector1_values = 0
    vector1.each do |vector_element|
      vector1_values += ((vector_element.values.first.to_f - vector1_mean)**2)
    end

    vector2_values = 0
    vector2.each do |vector_element|
      vector2_values += ((vector_element.values.first.to_f - vector2_mean)**2)
    end

    magnitude = Math.sqrt(vector1_values) * Math.sqrt(vector2_values)
    (dot_product / magnitude.to_f)
  end
  # rubocop:enable Metrics/AbcSize
end
